//
//  GMLeftMenuVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMLeftMenuVC.h"
#import "GMLeftMenuCell.h"
#import "GMCategoryModal.h"
#import "GMSectionView.h"
#import "GMLeftMenuDetailVC.h"
#import "GMOtpVC.h"
#import "GMHotDealBaseModal.h"
#import "GMRootPageViewController.h"
#import "GMDealCategoryBaseModal.h"
#import "MGSocialMedia.h"
#import "GMCityVC.h"
#import "GMHomeVC.h"
#import "GMStateBaseModal.h"

NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/idAPP_ID";
NSString *templateReviewURLiOS8 = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";

#pragma mark - Interface/Implementation SectionModal

@interface SectionModal : NSObject

@property (nonatomic, strong) NSString *sectionDisplayName;

@property (nonatomic, strong) NSMutableArray *rowArray;

@property (nonatomic, assign) BOOL isExpanded;



- (instancetype)initWithDisplayName:(NSString *)displayName rowArray:(NSMutableArray *)rowArray andIsExpand:(BOOL)isExpand;
@end

@implementation SectionModal

- (instancetype)initWithDisplayName:(NSString *)displayName rowArray:(NSMutableArray *)rowArray andIsExpand:(BOOL)isExpand {
    
    if(self = [super init]) {
        
        _sectionDisplayName = displayName;
        _rowArray = rowArray;
        _isExpanded = isExpand;
    }
    return self;
}
@end

#pragma mark - Interface/Implementation GMLeftMenuVC

@interface GMLeftMenuVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *leftMenuTableView;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic) SectionModal* preSelectedSectionMdl;

@end

static NSString * const kLeftMenuCellIdentifier                     = @"leftMenuCellIdentifier";

static NSString * const kShopByCategorySection                      =  @"SHOP BY CATEGORIES";
static NSString * const kShopByDealSection                          =  @"SHOP BY DEALS";
static NSString * const kGetInTouchSection                          =  @"GET IN TOUCH WITH US";
//static NSString * const kPaymentSection                           =  @"PAYMENTS METHODS";
static NSString * const kChangeCitySection                          =  @"PICK YOUR CITY";
static NSString * const kRateUsSection                              =  @"RATE US";
static NSString * const kMaxCoinSection                              =  @"MAX COINS";
static NSString * const kWalletSection                              =  @"REFUND BALANCE";

static NSString * const kContactSection                             =  @"CONTACT US";



@implementation GMLeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    [self.leftMenuTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self createSectionArray];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_HamburgerMain_Screen];
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    if(cityModal != nil) {
        if(NSSTRING_HAS_DATA(cityModal.cityName)) {
            self.locationLbl.text = cityModal.cityName;
        }
    }
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Open Drawer" label:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    [self.leftMenuTableView registerNib:[UINib nibWithNibName:@"GMLeftMenuCell" bundle:nil] forCellReuseIdentifier:kLeftMenuCellIdentifier];
}

- (void)createSectionArray {
    
    NSMutableArray *shopByCatArray = [self fetchShopByCategoriesFromDB];
    NSMutableArray *hotDeals = [self fetchHotDealsFromDB];
    
    [self.sectionArray removeAllObjects];
    
    SectionModal *maxCoin = [[SectionModal alloc] initWithDisplayName:kMaxCoinSection rowArray:nil andIsExpand:NO];
    [self.sectionArray addObject:maxCoin];
    
    SectionModal *wallet = [[SectionModal alloc] initWithDisplayName:kWalletSection rowArray:nil andIsExpand:NO];
    [self.sectionArray addObject:wallet];
    
    SectionModal *shopByCat = [[SectionModal alloc] initWithDisplayName:kShopByCategorySection rowArray:shopByCatArray andIsExpand:YES];
    [self.sectionArray addObject:shopByCat];
    SectionModal *shopByDeal = [[SectionModal alloc] initWithDisplayName:kShopByDealSection rowArray:hotDeals andIsExpand:NO];
    [self.sectionArray addObject:shopByDeal];
    SectionModal *getInTouch = [[SectionModal alloc] initWithDisplayName:kGetInTouchSection rowArray:nil andIsExpand:NO];
    [self.sectionArray addObject:getInTouch];
    SectionModal *rateUS = [[SectionModal alloc] initWithDisplayName:kRateUsSection rowArray:nil andIsExpand:NO];
    [self.sectionArray addObject:rateUS];
    
    
    SectionModal *contactUs = [[SectionModal alloc] initWithDisplayName:kContactSection rowArray:nil andIsExpand:NO];
    [self.sectionArray addObject:contactUs];
    
//    SectionModal *payment = [[SectionModal alloc] initWithDisplayName:kPaymentSection rowArray:nil andIsExpand:NO];
//    [self.sectionArray addObject:payment];
//    SectionModal *changeLocationInTouch = [[SectionModal alloc] initWithDisplayName:kChangeCitySection rowArray:nil andIsExpand:NO];
//    [self.sectionArray addObject:changeLocationInTouch];
    
    [self.leftMenuTableView reloadData];
}

- (NSMutableArray *)fetchShopByCategoriesFromDB {
    
    GMCategoryModal *rootModal = [GMCategoryModal loadRootCategory];
    GMCategoryModal *defaultCategoryModal = rootModal.subCategories.firstObject;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];
    NSMutableArray *shopBycatArray = [NSMutableArray arrayWithArray:[defaultCategoryModal.subCategories filteredArrayUsingPredicate:pred]];
    return shopBycatArray;
}

- (NSMutableArray *)fetchHotDealsFromDB {
    
    return [[GMHotDealBaseModal loadHotDeals].hotDealArray mutableCopy];
}

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)sectionArray {
    
    if(!_sectionArray) _sectionArray = [NSMutableArray array];
    return _sectionArray;
}

#pragma mark - UITableView Delegates/Datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SectionModal *sectionModal = [self.sectionArray objectAtIndex:section];
    if([sectionModal.sectionDisplayName isEqualToString:kShopByCategorySection])
    {
        if (sectionModal.isExpanded)
            return sectionModal.rowArray.count;
        else
            return 0;
    }
    else if([sectionModal.sectionDisplayName isEqualToString:kShopByDealSection])
    {
        if (sectionModal.isExpanded)
            return sectionModal.rowArray.count;
        else
            return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return [GMSectionView sectionHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMLeftMenuCell cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SectionModal *sectionMdl = [self.sectionArray objectAtIndex:section];
    GMSectionView *sectionView = [[[NSBundle mainBundle] loadNibNamed:@"GMSectionView" owner:self options:nil] lastObject];
    [sectionView.sectionButton addTarget:self action:@selector(sectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView.sectionButton setTag:section];
    [sectionView configureWithSectionDisplayName:sectionMdl.sectionDisplayName];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModal *sectionModal = [self.sectionArray objectAtIndex:indexPath.section];
    if([sectionModal.sectionDisplayName isEqualToString:kShopByCategorySection]) {
        
        GMCategoryModal *categoryModal = [sectionModal.rowArray objectAtIndex:indexPath.row];
        GMLeftMenuCell *leftMenuCell = (GMLeftMenuCell *)[tableView dequeueReusableCellWithIdentifier:kLeftMenuCellIdentifier];
        [leftMenuCell configureWithCategoryName:categoryModal.categoryName];
        [leftMenuCell setIdentationLevelOfCustomCell:1];
        return leftMenuCell;
        
    }else if([sectionModal.sectionDisplayName isEqualToString:kShopByDealSection]){
        
        GMHotDealModal *hotDealModal = [sectionModal.rowArray objectAtIndex:indexPath.row];
        GMLeftMenuCell *leftMenuCell = (GMLeftMenuCell *)[tableView dequeueReusableCellWithIdentifier:kLeftMenuCellIdentifier];
        [leftMenuCell setIdentationLevelOfCustomCell:1];
        [leftMenuCell configureWithCategoryName:hotDealModal.dealType];// confuse to use new func OR same
        return leftMenuCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionModal *sectionModal = [self.sectionArray objectAtIndex:indexPath.section];
    if([sectionModal.sectionDisplayName isEqualToString:kShopByCategorySection]) {
        
        GMCategoryModal *categoryModal = [sectionModal.rowArray objectAtIndex:indexPath.row];
        GMLeftMenuDetailVC *leftMenuDetailVC = [[GMLeftMenuDetailVC alloc] initWithNibName:@"GMLeftMenuDetailVC" bundle:nil];
        leftMenuDetailVC.subCategoryModal = categoryModal;
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:categoryModal.categoryName value:nil];
        
        GMCityModal *cityModal = [GMCityModal selectedLocation];
        [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Drawer - L1" label:categoryModal.categoryName];
        
        [self.navigationController pushViewController:leftMenuDetailVC animated:YES];
    }
    else if ([sectionModal.sectionDisplayName isEqualToString:kShopByDealSection]) {
        
        GMHotDealModal *hotDealModal = [sectionModal.rowArray objectAtIndex:indexPath.row];
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:hotDealModal.dealTypeId value:nil];
        GMCityModal *cityModal = [GMCityModal selectedLocation];
        [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Drawer - Deal Category L1" label:hotDealModal.dealType];
        [self fetchDealCategoriesFromServerWithDealTypeId:hotDealModal.dealTypeId];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    for (GMLeftMenuCell *cell in self.leftMenuTableView.visibleCells) {
        
        CGFloat hiddenFrameHeight = scrollView.contentOffset.y + [GMLeftMenuCell cellHeight] - cell.frame.origin.y;
        if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
            [cell maskCellFromTop:hiddenFrameHeight];
        }
    }
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerScroller withCategory:@"" label:nil value:nil];
}

#pragma mark - IBAction Methods

- (void)sectionButtonTapped:(UIButton *)sender {
    
    SectionModal *sectionModal = [self.sectionArray objectAtIndex:sender.tag];
    if ([sectionModal.sectionDisplayName isEqualToString:kGetInTouchSection]) {
        
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:kGetInTouchSection value:nil];
        
        AppDelegate *appDel = APP_DELEGATE;
        [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self shareExperience];
        
    }else if ([sectionModal.sectionDisplayName isEqualToString:kMaxCoinSection]) {
        
//        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:kWalletSection value:nil];
        
        AppDelegate *appDel = APP_DELEGATE;
        [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self maxcoin];
        
    } else if ([sectionModal.sectionDisplayName isEqualToString:kWalletSection]) {
        
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:kWalletSection value:nil];
        
        AppDelegate *appDel = APP_DELEGATE;
        [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self wallet];
    }else if ([sectionModal.sectionDisplayName isEqualToString:kContactSection]) {
        
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:kContactSection value:nil];
        
        AppDelegate *appDel = APP_DELEGATE;
        [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self contactUs];
    } else if ([sectionModal.sectionDisplayName isEqualToString:kRateUsSection]) {
        
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:kRateUsSection value:nil];
        
        AppDelegate *appDel = APP_DELEGATE;
        [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self rateUs];
    }
    
//    else if ([sectionModal.sectionDisplayName isEqualToString:kPaymentSection]) {
//        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:kPaymentSection value:nil];
//    }
    else if ([sectionModal.sectionDisplayName isEqualToString:kChangeCitySection]) {
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:kChangeCitySection value:nil];
        AppDelegate *appDel = APP_DELEGATE;
        [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        GMCityVC * cityVC  = [GMCityVC new];
        GMHomeVC *homeVc = [appDel rootHomeVCFromFourthTab];
        
        cityVC.isCommimgFromHamberger = YES;
        [homeVc.navigationController pushViewController:cityVC animated:NO];
    }

    
    else {
        
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:nil value:nil];
        for (SectionModal *mdl in self.sectionArray) {
            mdl.isExpanded = NO;
        }
        [sectionModal setIsExpanded:YES];
        [self.leftMenuTableView reloadData];
        
        for (GMLeftMenuCell *cell in self.leftMenuTableView.visibleCells) {
            
            CGFloat hiddenFrameHeight = self.leftMenuTableView.contentOffset.y + [GMLeftMenuCell cellHeight] - cell.frame.origin.y;
            if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                [cell maskCellFromTop:hiddenFrameHeight];
            }
        }
    }
}

- (IBAction)homeButtonTapped:(id)sender {
    
    AppDelegate *appDel = APP_DELEGATE;
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma nark - Fetching Hot Deals Methods

- (void)fetchDealCategoriesFromServerWithDealTypeId:(NSString *)dealTypeId {
    
    [self showProgress];
    [[GMOperationalHandler handler] dealsByDealType:@{kEY_deal_type_id :dealTypeId, kEY_device : kEY_iOS} withSuccessBlock:^(id dealCategoryBaseModal) {
        
        [self removeProgress];
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
//        rootVC.isFromDrawerDeals = YES;
//        [APP_DELEGATE setTopVCOnHotDealsController:rootVC];
        
        
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
        
        //        GMHotDealModal *hotDealModal =  [self.hotDealsArray objectAtIndex:0];
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.navigationTitleString = @"Deals";
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeDealGA;
//        [APP_DELEGATE setTopVCOnHotDealsController:rootVC];
        
        GMHomeVC *homeVC  = [APP_DELEGATE rootHomeVCFromFourthTab];
        [homeVC.navigationController pushViewController:rootVC animated:YES];
        [self.drawerController closeDrawerAnimated:YES completion:nil];
        
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

- (void)shareExperience{
    
    MGSocialMedia *socalMedia = [MGSocialMedia sharedSocialMedia];
    [socalMedia showActivityView:@"Hey, I cut my grocery bill by 30% at GrocerMax.com. Over 8000 grocery items, all below MRP and unbelievable offers. Apply code APP200 and start with Flat Rs. 200 off on your first bill."];
    
}
- (void)wallet{
    if([self.delegate respondsToSelector:@selector(goToWallet)]) {
        [self.delegate goToWallet];
    }
    
}
- (void)maxcoin{
    if([self.delegate respondsToSelector:@selector(goToMaxCoins)]) {
        [self.delegate goToMaxCoins];
    }
    
}
- (void)contactUs{
    
    if([self.delegate respondsToSelector:@selector(goContactUs)]) {
        [self.delegate goContactUs];
    }
}
- (void)rateUs{
    
    NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", APPLE_APP_ID]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        reviewURL = [templateReviewURLiOS7 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", APPLE_APP_ID]];
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        reviewURL = [templateReviewURLiOS8 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", APPLE_APP_ID]];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    
}
- (IBAction)actionEditLocation:(id)sender {
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DrawerOptionSelect withCategory:@"" label:kChangeCitySection value:nil];
    AppDelegate *appDel = APP_DELEGATE;
    [appDel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    GMCityVC * cityVC  = [GMCityVC new];
    GMHomeVC *homeVc = [appDel rootHomeVCFromFourthTab];
    
    cityVC.isCommimgFromHamberger = YES;
    [homeVc.navigationController pushViewController:cityVC animated:NO];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"City Change" label:@""];

}

@end
