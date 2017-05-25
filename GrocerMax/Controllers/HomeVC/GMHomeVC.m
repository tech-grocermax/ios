//
//  GMHomeVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHomeVC.h"
#import "GMPageControllCell.h"
#import "GMShopByCategoryCell.h"
#import "GMShopByDealCell.h"
#import "GMRootPageViewController.h"
#import "GMSubCategoryVC.h"
#import "GMOrderHistryVC.h"
#import "GMOfferListVC.h"
#import "GMHotDealVC.h"
#import "GMDeliveryDetailVC.h"
#import "GMBillingAddressVC.h"
#import "GMShipppingAddressVC.h"
#import "GMEditProfileVC.h"
#import "GMCityVC.h"
#import "GMStateBaseModal.h"
#import "Sequencer.h"
#import "GMHotDealBaseModal.h"
#import "GMOurPromisesCell.h"
#import "GMOffersByDealTypeModal.h"

#import "GMOrderDetailVC.h"
#import "GMSearchResultModal.h"
#import "GMDealCategoryBaseModal.h"
#import "GMHomeBannerModal.h"
#import "GMSearchVC.h"
#import "GMHomeBannerModal.h"
#import "GMPaymentVC.h"
#import "GMProductListingVC.h"
#import "GMHomeModal.h"
#import "GMProductDescriptionVC.h"
#import "GMSpecialDealCell.h"
#import "MGInternalNotificationAlert.h"
#import "GMSinglePageVC.h"

//#define   KEY_Banner_search @"search"
//#define   KEY_Banner_offerbydealtype @"offerbydealtype"
//#define   KEY_Banner_dealsbydealtype @"dealsbydealtype"
//#define   KEY_Banner_productlistall @"productlistall"

NSString *const pageControllCell = @"GMPageControllCell";
NSString *const shopByCategoryCell = @"GMShopByCategoryCell";
NSString *const shopByDealCell = @"GMShopByDealCell";
NSString *const ourPromisesCell = @"GMOurPromisesCell";
NSString *const specialDealCell = @"specialDealCell";

@interface GMHomeVC ()<UITableViewDataSource,UITableViewDelegate,GMPageControllCellDelegate,GMShopByCategoryCellDelegate,GMShopByDealCellDelegate>
{
    BOOL isProductListFromBottomBanner;
}
@property (nonatomic,weak) IBOutlet UITableView *tblView;
@property (nonatomic,strong) NSArray *categoriesArray;
@property (nonatomic,strong) NSArray *hotDealsArray;
@property (nonatomic,strong) NSArray *bannerListArray;
@property (nonatomic,strong) NSArray *specialDealArray;

@property (nonatomic, strong) GMCategoryModal *rootCategoryModal;

@end

@implementation GMHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addLeftMenuButton];
    //    [self showSearchIconOnRightNavBarWithNavTitle:@"Home"];
    //    self.navigationItem.title = @"Home";
    self.navigationItem.title = @"";
    UIImage *image = [UIImage imageNamed:@"logo"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.navigationController.navigationBar.topItem setTitleView:imageView];
    
    [self fetchAllCategoriesAndDeals];
    
    [self registerCellsForTableView];
    [self configureUI];
    [self userSelectLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_TabHome withCategory:@"" label:nil value:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[GMSharedClass sharedClass]setTabBarVisible:YES ForController:self animated:YES];
    // if categoies exist in memory
//    GMCategoryModal *mdl = [GMCategoryModal loadRootCategory];
//    if (mdl != nil) {
//        [self getShopByCategoriesFromServer];
//    }
    
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Home_Screen];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configureUI

- (void)configureUI {
    
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    self.tblView.tableFooterView = [UIView new];
    
    
}
- (void)userSelectLocation {

    if([GMCityModal selectedLocation] == nil) {
        GMCityVC * cityVC  = [GMCityVC new];
        [self.navigationController pushViewController:cityVC animated:NO];
    }
}

#pragma mark - Register Cells

- (void)registerCellsForTableView {
    
    [self.tblView registerNib:[UINib nibWithNibName:@"GMPageControllCell" bundle:nil] forCellReuseIdentifier:pageControllCell];
    [self.tblView registerNib:[UINib nibWithNibName:@"GMShopByCategoryCell" bundle:nil] forCellReuseIdentifier:shopByCategoryCell];
    [self.tblView registerNib:[UINib nibWithNibName:@"GMShopByDealCell" bundle:nil] forCellReuseIdentifier:shopByDealCell];
    [self.tblView registerNib:[UINib nibWithNibName:@"GMOurPromisesCell" bundle:nil] forCellReuseIdentifier:ourPromisesCell];
    [self.tblView registerNib:[UINib nibWithNibName:@"GMSpecialDealCell" bundle:nil] forCellReuseIdentifier:specialDealCell];
}

#pragma mark - UITableviewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3 + self.specialDealArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            return [self pageControllCellForTableView:tableView indexPath:indexPath];
        }
            break;
        case 1:
            return [self shopByCategoryCellForTableView:tableView indexPath:indexPath];
            break;
        case 2:
            return [self shopByDealCellForTableView:tableView indexPath:indexPath];
            break;
        default:
            return [self specialDellCellForTableView:tableView indexPath:indexPath];
            break;
    }
    
    // rare conditon
    static NSString *cellidentifire = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifire];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Section:%ld",(long)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            return 156;
        }
            break;
        case 1:
        {
//            return 215;
            NSUInteger items = self.categoriesArray.count/3;
            if(self.categoriesArray.count%3 !=0 ) {
                items= items+1;
            }
            return items * (SCREEN_SIZE.width/3) + 10;
            break;
        }
        case 2:
            if(self.hotDealsArray.count>0) {
                return 210;
            }else {
                return 0;
            }
            break;
        default:
            return [GMSpecialDealCell cellHeight];
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Taking action of special Deal cell
    if(indexPath.row > 2) {
        
        GMBannerModal *bannerModal = [self.specialDealArray objectAtIndex:indexPath.row-3];
        
//        [self specailBanner:bannerModal];
        GMHomeBannerModal *homeBannerModal = [[GMHomeBannerModal alloc]init];
        homeBannerModal.name = bannerModal.name;
        homeBannerModal.linkUrl = bannerModal.linkUrl;
        homeBannerModal.imageUrl = bannerModal.imageURL;
        [self handleBannerAction:homeBannerModal];
        
        NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init]; if(NSSTRING_HAS_DATA(bannerModal.name)){
            [qaGrapEventDic setObject:bannerModal.name forKey:kEY_QA_EventParmeter_BannerName];
        }
        [[GMSharedClass sharedClass] trakeForQAWithEventame:[NSString stringWithFormat:@"%@ %ld",kEY_QA_EventLabel_HomeBanner_Click,(long)indexPath.row-2] withExtraParameter:qaGrapEventDic];
        
//        indexPath.row-3
    }
}


-(void)specailBanner:(NSString *)sku categoryId:(NSString *)categoryId name:(NSString *)name {
//    GMBannerModal *bannerModal = [self.specialDealArray objectAtIndex:atIndex];
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:sku forKey:kEY_sku];
    
    
    
    [self showProgress];
    [[GMOperationalHandler handler] specialdeal:localDic withSuccessBlock:^(id productListingBaseModal) {
        [self removeProgress];
        
        GMProductListingBaseModal *productListingBaseMdl = productListingBaseModal;
        
        GMCategoryModal *categoryModal = [[GMCategoryModal alloc]init];
        if(NSSTRING_HAS_DATA(categoryId)){
            categoryModal.categoryId = categoryId;
        }else {
            categoryModal.categoryId = @"-1";
        }
        categoryModal.categoryName = name;
        categoryModal.productListArray = productListingBaseMdl.productsListArray;
        categoryModal.totalCount = productListingBaseMdl.totalcount;
        
        GMProductListingVC *proListVC = [[GMProductListingVC alloc] initWithNibName:@"GMProductListingVC" bundle:nil];
        proListVC.catMdl = categoryModal;
        proListVC.rootPageAPIController = [[GMRootPageAPIController alloc] init];
        proListVC.productListingType = GMProductListingFromTypeOffer_OR_Deal;
        proListVC.parentVC = nil;
        proListVC.productListPageViewType =
        GMRootPageViewControllerTypeOffersByDealTypeListing;
        proListVC.productListingFromTypeForGA = GMProductListingFromTypeSaveMoreGA;
        
        proListVC.gaTrackingEventText =  kEY_GA_Event_ProductListingThroughOffers;
        
        [self.navigationController pushViewController:proListVC animated:YES];
        
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];

}
#pragma mark - cells

-(GMPageControllCell*)pageControllCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    GMPageControllCell *cell = [tableView dequeueReusableCellWithIdentifier:pageControllCell];
    [cell configureCellWithData:self.bannerListArray cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

-(GMShopByCategoryCell*)shopByCategoryCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    GMShopByCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:shopByCategoryCell];
    [cell configureCellWithData:self.categoriesArray cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (GMShopByDealCell*)shopByDealCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    GMShopByDealCell *cell = [tableView dequeueReusableCellWithIdentifier:shopByDealCell];
    [cell configureCellWithData:self.hotDealsArray cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (GMOurPromisesCell*)ourPromisesCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    GMOurPromisesCell *cell = [tableView dequeueReusableCellWithIdentifier:ourPromisesCell];
    [cell configureCellWithData:nil cellIndexPath:nil];
    return cell;
}

- (GMSpecialDealCell *)specialDellCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    GMSpecialDealCell *cell = [tableView dequeueReusableCellWithIdentifier:specialDealCell];
    [cell configureSpecialDealCellWith:self.specialDealArray[indexPath.row - 3]];
    return cell;
}

#pragma mark - paggin cell Delegate

-(void)didSelectItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    GMHomeBannerModal *homeBannerModal =self.bannerListArray[collectionIndexpath.item];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Banner Click" label:homeBannerModal.imageUrl];
    
    [self handleBannerAction:homeBannerModal];
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init]; if(NSSTRING_HAS_DATA(homeBannerModal.name)){
        [qaGrapEventDic setObject:homeBannerModal.name forKey:kEY_QA_EventParmeter_BannerName];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_HomeFlaship_Click withExtraParameter:qaGrapEventDic];
}

#pragma mark - Categories cell Delegate

- (void)didSelectCategoryItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    
    GMCategoryModal *catModal = [self.categoriesArray objectAtIndex:collectionIndexpath.row];
    GMSubCategoryVC * categoryVC  = [GMSubCategoryVC new];
    categoryVC.rootCategoryModal = catModal;
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CategorySelection withCategory:@"" label:catModal.categoryName value:nil];
    
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"L1" label:catModal.categoryName];
    
    [self.navigationController pushViewController:categoryVC animated:YES];
}

- (void)offerBtnPressedAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    
    GMCategoryModal *catModal = [self.categoriesArray objectAtIndex:collectionIndexpath.row];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_OfferCategorySelection withCategory:@"" label:catModal.categoryName value:nil];
    [self getOffersDealFromServerWithCategoryModal:catModal];
}

#pragma mark - Deal cell Delegate


- (void)didSelectDealItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    
    GMHotDealModal *hotDealModal = [self.hotDealsArray objectAtIndex:collectionIndexpath.row];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DealSelection withCategory:@"" label:hotDealModal.dealTypeId value:nil];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Deal Category L1" label:hotDealModal.dealType];
    
    
    [self fetchDealCategoriesFromServerWithDealTypeId:hotDealModal.dealTypeId];
}

#pragma mark -

- (void)fetchAllCategoriesAndDeals {
    
    [self showProgress];
    [[GMOperationalHandler handler] fetchHomeScreenDataFromServerWithSuccessBlock:^(GMHomeModal *homeModal) {
        
        self.rootCategoryModal = homeModal.rootCategoryModal;
        
        [[GMSharedClass sharedClass] setTrendingBaseMdl:homeModal.trendingBaseModal];
        [self categoryLevelCategorization];
        [self.rootCategoryModal archiveRootCategory];
        GMCategoryModal *mdl = [GMCategoryModal loadRootCategory];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];
        GMCategoryModal *defaultCategory = mdl.subCategories.firstObject;
        self.categoriesArray = defaultCategory.subCategories;
        self.categoriesArray = [self.categoriesArray filteredArrayUsingPredicate:pred];
        
        GMHotDealBaseModal *hotDealBaseModal = [[GMHotDealBaseModal alloc] init];
        [hotDealBaseModal setHotDealArray:homeModal.hotDealArray];
        [hotDealBaseModal archiveHotDeals];
        self.hotDealsArray = [GMHotDealBaseModal loadHotDeals].hotDealArray;
        
        self.bannerListArray = homeModal.bannerListArray;
        self.specialDealArray = homeModal.specialDealArray;
        [self saveSubscriptionPopUpData:homeModal];
    
        NSArray *arr = homeModal.categoryArray;
        
        for (NSDictionary *dic in arr) {
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.categoryId == %@", dic[kEY_category_id]];
            
            GMCategoryModal *defaultCategory = [[self.categoriesArray filteredArrayUsingPredicate:pred] firstObject];
            defaultCategory.offercount = dic[kEY_offercount];
            defaultCategory.categoryImageURL = dic[kEY_images];
        }

        [self removeProgress];
        [self.tblView reloadData];
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
    }];
}


-(void)saveSubscriptionPopUpData:(GMHomeModal *)homeModal {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL isSubscriptionPopUpShow =  [[defaults objectForKey:key_IsSubscriptionPopUpShow] boolValue];
    if([defaults objectForKey:key_SubscriptionPopUp_Cancel]) {
        [defaults removeObjectForKey:key_SubscriptionPopUp_Cancel];
    }
    if([defaults objectForKey:key_SubscriptionPopUp_Ok]) {
        [defaults removeObjectForKey:key_SubscriptionPopUp_Ok];
    }
    
    if([defaults objectForKey:key_SubscriptionPopUp_Message]) {
        [defaults removeObjectForKey:key_SubscriptionPopUp_Message];
    }
    if([defaults objectForKey:key_SubscriptionPopUp_ExpTime]) {
        [defaults removeObjectForKey:key_SubscriptionPopUp_ExpTime];
    }
    
    if(isSubscriptionPopUpShow == FALSE){
        if(homeModal.subscriptionPopUp != nil) {
            if(NSSTRING_HAS_DATA(homeModal.subscriptionPopUp.cancel_button_text)) {
                [defaults setObject:homeModal.subscriptionPopUp.cancel_button_text forKey:key_SubscriptionPopUp_Cancel];
            }if(NSSTRING_HAS_DATA(homeModal.subscriptionPopUp.ok_button_text)) {
                [defaults setObject:homeModal.subscriptionPopUp.ok_button_text forKey:key_SubscriptionPopUp_Ok];
            }if(NSSTRING_HAS_DATA(homeModal.subscriptionPopUp.message)) {
                [defaults setObject:homeModal.subscriptionPopUp.message forKey:key_SubscriptionPopUp_Message];
            }if(NSSTRING_HAS_DATA(homeModal.subscriptionPopUp.expTime)) {
                [defaults setObject:homeModal.subscriptionPopUp.expTime forKey:key_SubscriptionPopUp_ExpTime];
            }
            
        }
    }
    [defaults synchronize];
}
- (void)categoryLevelCategorization {
    
    GMCategoryModal *defaultCategory = self.rootCategoryModal.subCategories.firstObject;
    [self createCategoryLevelArchitecturForDisplay:defaultCategory.subCategories];
}

- (void)createCategoryLevelArchitecturForDisplay:(NSArray *)menuArray {
    
    for (GMCategoryModal *categoryModal in menuArray) {
        
        [self updateExpandPropertyOfSubCategory:categoryModal];
    }
}

- (void)updateExpandPropertyOfSubCategory:(GMCategoryModal *)categoryModal {
    
    if(categoryModal.subCategories.count) {
        
        BOOL expandStatus = [self checkIsCategoryExpanded:categoryModal.subCategories];
        [categoryModal setIsExpand:expandStatus];
        [self createCategoryLevelArchitecturForDisplay:categoryModal.subCategories]; // recursion for sub categories
    }
    else {
        
        [categoryModal setIsExpand:NO];
        return;
    }
}

// checking the two level categories count

- (BOOL)checkIsCategoryExpanded:(NSArray *)subCategoryArray {
    
    GMCategoryModal *subCatModal = subCategoryArray.firstObject;
    if(subCatModal.subCategories.count)
        return YES;
    else
        return NO;
}

#pragma mark - Get categories from server

- (void)getShopByCategoriesFromServer {
    
    [self showProgress];
    [[GMOperationalHandler handler] shopbyCategory:nil withSuccessBlock:^(id catArray) {
        
        NSArray *arr = catArray;
        
        for (NSDictionary *dic in arr) {
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.categoryId == %@", dic[kEY_category_id]];
            
            GMCategoryModal *defaultCategory = [[self.categoriesArray filteredArrayUsingPredicate:pred] firstObject];
            defaultCategory.offercount = dic[kEY_offercount];
        }
        [self.tblView reloadData];
        
        [self removeProgress];
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

#pragma mark - offersByDeal

- (void)getOffersDealFromServerWithCategoryModal:(GMCategoryModal*)categoryModal {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:categoryModal.categoryId forKey:kEY_cat_id];
    [localDic setObject:kEY_iOS forKey:kEY_device];
    
    [self showProgress];
    [[GMOperationalHandler handler] getOfferByDeal:localDic withSuccessBlock:^(id offersByDealTypeBaseModal) {
        
        [self removeProgress];
        
        GMProductListingBaseModal *productListingBaseMdl = offersByDealTypeBaseModal;
        
        // All Cat list side by ALL Tab
        NSMutableArray *categoryArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.hotProductListArray) {
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // All products, for ALL Tab category
        NSMutableArray *allCatProductListArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.productsListArray) {
            [allCatProductListArray addObjectsFromArray:catMdl.productListArray];
            
            if (catMdl.productListArray.count >= 1) {
                
                //                if(!NSSTRING_HAS_DATA(catMdl.categoryId)) {
                //                    catMdl.categoryId = @"0";
                //                }
                [categoryArray addObject:catMdl];
            }
        }
        
        // set all product list in ALL tab category mdl
        categoryModal.productListArray = allCatProductListArray;
        
        // set this cat modal as ALL tab
        [categoryArray insertObject:categoryModal atIndex:0];
        
        if (categoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
            [[GMSharedClass sharedClass] showErrorMessage:@"Sorry, No products listed in this category"];
            return ;
        }
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.navigationTitleString = categoryModal.categoryName;
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeDealGA;
        [self.navigationController pushViewController:rootVC animated:YES];
//        [self.navigationController pushViewController:rootVC animated:YES];
        
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

- (NSMutableArray *)createOffersByDealTypeModalFrom:(GMOffersByDealTypeBaseModal *)baseModal {
    
    NSMutableArray *offersByDealTypeArray = [NSMutableArray array];
    GMOffersByDealTypeModal *allModal = [[GMOffersByDealTypeModal alloc] initWithDealType:@"All" dealId:@"" dealImageUrl:@"" andDealsArray:baseModal.allArray];
    [offersByDealTypeArray addObject:allModal];
    [offersByDealTypeArray addObjectsFromArray:baseModal.deal_categoryArray];
    //    [offersByDealTypeArray removeLastObject];
    return offersByDealTypeArray;
}

#pragma nark - Fetching Hot Deals Methods

- (void)fetchDealCategoriesFromServerWithDealTypeId:(NSString *)dealTypeId {
    
    [self showProgress];
    [[GMOperationalHandler handler] dealsByDealType:@{kEY_deal_type_id :dealTypeId, kEY_device : kEY_iOS} withSuccessBlock:^(id dealCategoryBaseModal) {
        
        [self removeProgress];
        
        GMProductListingBaseModal *productListingBaseMdl = dealCategoryBaseModal;
        
        // All Cat list side by ALL Tab
        NSMutableArray *categoryArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.hotProductListArray) {
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // All products, for ALL Tab category
        NSMutableArray *allCatProductListArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.productsListArray) {
            [allCatProductListArray addObjectsFromArray:catMdl.productListArray];
            
            if (catMdl.productListArray.count >= 1) {
                
                //                if(!NSSTRING_HAS_DATA(catMdl.categoryId)) {
                //                    catMdl.categoryId = @"0";
                //                }
                [categoryArray addObject:catMdl];
            }
        }
        
        // set all product list in ALL tab category mdl
        GMCategoryModal *categoryModal = [[GMCategoryModal alloc]init];
        categoryModal.categoryId = @"-1";
        categoryModal.productListArray = allCatProductListArray;
        
        // set this cat modal as ALL tab
        [categoryArray insertObject:categoryModal atIndex:0];
        
        if (categoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
            [[GMSharedClass sharedClass] showErrorMessage:@"Sorry, No products listed in this category"];
            return ;
        }
        
      GMHotDealModal *hotDealModal =  [self.hotDealsArray objectAtIndex:0];
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.navigationTitleString = hotDealModal.dealType;
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeDealGA;
        [self.navigationController pushViewController:rootVC animated:YES];

        
//        NSMutableArray *dealCategoryArray = [self createCategoryDealsArrayWith:dealCategoryBaseModal];
//        
//        if (dealCategoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
//            return ;
//        }
//        
//        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
//        rootVC.pageData = dealCategoryArray;
//        rootVC.navigationTitleString = [dealCategoryBaseModal.dealNameArray firstObject];
//        rootVC.rootControllerType = GMRootPageViewControllerTypeDealCategoryTypeListing;
//        [APP_DELEGATE rootHotDealVCFromThirdTab];
//        [self.navigationController pushViewController:rootVC animated:NO];
//        [APP_DELEGATE setTopVCOnHotDealsController:rootVC];
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

- (NSMutableArray *)createCategoryDealsArrayWith:(GMDealCategoryBaseModal *)dealCategoryBaseModal {
    
    NSMutableArray *dealCategoryArray = [NSMutableArray arrayWithArray:dealCategoryBaseModal.dealCategories];
    GMDealCategoryModal *allModal = [[GMDealCategoryModal alloc] initWithCategoryId:@"" images:@"" categoryName:@"All" isActive:@"1" andDeals:dealCategoryBaseModal.allDealCategory];
    [dealCategoryArray insertObject:allModal atIndex:0];
    return dealCategoryArray;
}


- (void)handleBannerAction:(GMHomeBannerModal*)bannerMdl {
    
    if (!NSSTRING_HAS_DATA(bannerMdl.linkUrl)) {
        return;
    }
    
    NSArray *typeStringArr = [bannerMdl.linkUrl componentsSeparatedByString:@"?"];
    NSString *typeStr = typeStringArr.firstObject;
    NSArray *valueStringArr = [bannerMdl.linkUrl componentsSeparatedByString:@"="];
    NSString *value = valueStringArr.lastObject;
    
    if ([bannerMdl.linkUrl isEqualToString:KEY_Banner_shopbydealtype]) {
        [self.tabBarController setSelectedIndex:2];
        return;
    }
    
    if (!(NSSTRING_HAS_DATA(typeStr) && NSSTRING_HAS_DATA(value))) {
        return;
    }
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_BannerSelection withCategory:bannerMdl.linkUrl label:value value:nil];
    
    if ([typeStr isEqualToString:KEY_Banner_search]) {
        
//        NSMutableDictionary *localDic = [NSMutableDictionary new];
//        [localDic setObject:value forKey:kEY_keyword];
//        
//        GMSearchVC *searchVC = [APP_DELEGATE rootSearchVCFromFourthTab];
//        if (searchVC == nil)
//            return;
//        [searchVC performSearchOnServerWithParam:localDic isBanner:YES];
        [self searchBanner:value];
        
    }else if ([typeStr isEqualToString:KEY_Banner_offerbydealtype]) {
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(bannerMdl.name)) {
            bannerCatMdl.categoryName = bannerMdl.name;
        } else {
            bannerCatMdl.categoryName = @"Banner Result";
        }
        
        
        [self getOffersDealFromServerWithCategoryModal:bannerCatMdl];
        
    }else if ([typeStr isEqualToString:KEY_Banner_dealsbydealtype]) {
        
        [self fetchDealCategoriesFromServerWithDealTypeId:value];
        
    }else if ([typeStr isEqualToString:KEY_Banner_productlistall]) {
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(bannerMdl.name)) {
            bannerCatMdl.categoryName = bannerMdl.name;
        } else {
            bannerCatMdl.categoryName = @"Banner Result";
        }
//        bannerCatMdl.categoryName = @"Banner Result";
        isProductListFromBottomBanner = TRUE;
        [self fetchProductListingDataForCategory:bannerCatMdl];
        
    }else if ([typeStr isEqualToString:KEY_Banner_dealproductlisting]) {
        
        
        
        ///Arvind
//        GMHotDealVC *hotDealVC = [APP_DELEGATE rootHotDealVCFromThirdTab];
//        if (hotDealVC == nil)
//            return;
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(bannerMdl.name)) {
            bannerCatMdl.categoryName = bannerMdl.name;
        } else {
            bannerCatMdl.categoryName = @"Banner Result";
        }
//        bannerCatMdl.categoryName = @"Banner Result";
        
        [self fetchDealProductListingDataForBannerOffersORDeals:bannerCatMdl];
        
        
        
    }else if([typeStr isEqualToString:KEY_Notification_Productdetail]){
        
        
        GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
        GMProductModal *productModal = [[GMProductModal alloc]init];
        productModal.productid = value;
        vc.modal = productModal;
        vc.parentVC = nil;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if([typeStr isEqualToString:KEY_Notification_Specialdeal])
    {
        
        [self specailBanner:value categoryId:@"-1" name:bannerMdl.name];
        
    }else if([typeStr isEqualToString:KEY_Notification_Singlepage])
    {
        GMSinglePageVC *singlePageVC = [[GMSinglePageVC alloc]init];
        singlePageVC.bannerSinglePageId = value;
        singlePageVC.displayName = bannerMdl.name;
        [self.navigationController pushViewController:singlePageVC animated:YES];
    }
}



- (void)fetchDealProductListingDataForBannerOffersORDeals:(GMCategoryModal*)catMdl {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:catMdl.categoryId forKey:kEY_deal_id];
    [localDic setObject:@"1" forKey:kEY_page];
    [localDic setObject:kEY_iOS forKey:kEY_device];
    
    
    [self showProgress];
    [[GMOperationalHandler handler] dealProductListing:localDic withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
        GMProductListingBaseModal *newModal = responceData;
        
        catMdl.productListArray = newModal.productsListArray;
        catMdl.totalCount = newModal.totalcount;
        
        GMProductListingVC *proListVC = [[GMProductListingVC alloc] initWithNibName:@"GMProductListingVC" bundle:nil];
        proListVC.catMdl = catMdl;
        proListVC.rootPageAPIController = [[GMRootPageAPIController alloc] init];
        proListVC.productListingType = GMProductListingFromTypeOffer_OR_Deal;
        proListVC.parentVC = nil;// do your work, deepak
        proListVC.gaTrackingEventText =  kEY_GA_Event_ProductListingThroughHomeBanner;
        proListVC.productListPageViewType =
        GMRootPageViewControllerTypeOffersByDealTypeListing;
        proListVC.productListingFromTypeForGA = GMProductListingFromTypeCategoryGA;
        
//        [self.tabBarController setSelectedIndex:2];
        [self.navigationController pushViewController:proListVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}


-(void)searchBanner:(NSString *)keyword {
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SearchQuery withCategory:@"" label:keyword value:nil];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Search" label:keyword];
    
    
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(keyword)){
        [prams setObject:keyword forKey:kEY_keyword];
    }else {
        return;
    }
    
    
    [self showProgress];
    [[GMOperationalHandler handler] search:prams withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
        GMSearchResultModal *searchResultModal = responceData;
        [self createCategoryModalFromSearchResult:searchResultModal];
        
        
        if (searchResultModal.categorysListArray.count == 0) {
            [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"noResultFound")];
            return;
        }
        
//        [self.tabBarController setSelectedIndex:3];
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData =(NSMutableArray *) searchResultModal.categorysListArray;
        if(NSSTRING_HAS_DATA(keyword)) {
            rootVC.navigationTitleString = keyword;
        } else {
            rootVC.navigationTitleString = @"";
        }
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeSearchGA;
        rootVC.isFromSearch = YES;
        [self.navigationController pushViewController:rootVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

- (void)createCategoryModalFromSearchResult:(GMSearchResultModal *)searchModal {
    
    
    for (GMCategoryModal *catModal in searchModal.categorysListArray) {
        
        NSString *categoryId = catModal.categoryId;
        NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(GMProductModal *evaluatedObject, NSDictionary *bindings) {
            
            NSArray *categoriesIdArr = evaluatedObject.categoryIdArray;
            if([categoriesIdArr containsObject:categoryId])
                return YES;
            else
                return NO;
        }];
        NSArray *productListArr = [searchModal.productsListArray filteredArrayUsingPredicate:pred];
        catModal.productListArray = productListArr;
        catModal.totalCount = productListArr.count;
    }
}


#pragma mark - fetchProductListingDataForCategory

- (void)fetchProductListingDataForCategory:(GMCategoryModal*)categoryModal {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:categoryModal.categoryId forKey:kEY_cat_id];
    
    [self showProgress];
    [[GMOperationalHandler handler] productListAll:localDic withSuccessBlock:^(id productListingBaseModal) {
        [self removeProgress];
        
        GMProductListingBaseModal *productListingBaseMdl = productListingBaseModal;
        
        // All Cat list side by ALL Tab
        NSMutableArray *categoryArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.hotProductListArray) {
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // All products, for ALL Tab category
        NSMutableArray *allCatProductListArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.productsListArray) {
            [allCatProductListArray addObjectsFromArray:catMdl.productListArray];
            
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // set all product list in ALL tab category mdl
        categoryModal.productListArray = allCatProductListArray;
        
        // set this cat modal as ALL tab
        [categoryArray insertObject:categoryModal atIndex:0];
        
        if (categoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
            isProductListFromBottomBanner = FALSE;
            return ;
        }
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlistingCategory;
        rootVC.navigationTitleString = categoryModal.categoryName;
        if(isProductListFromBottomBanner) {
            isProductListFromBottomBanner = FALSE;
            rootVC.productListingFromTypeForGA = GMProductListingFromTypeSaveMoreGA;
        }else {
            rootVC.productListingFromTypeForGA = GMProductListingFromTypeCategoryGA;
        }
        [self.navigationController pushViewController:rootVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
        isProductListFromBottomBanner = FALSE;
    }];
}

@end
