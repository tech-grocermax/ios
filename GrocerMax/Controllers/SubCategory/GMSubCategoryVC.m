//
//  GMSubCategoryVC.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSubCategoryVC.h"
#import "GMSubCategoryHeaderView.h"
#import "GMCategoryModal.h"
#import "GMSubCategoryCell.h"
#import "GMRootPageViewController.h"
#import "GMStateBaseModal.h"
#import "GMShopByCategoryCell.h"
//#import "GMOffersByDealTypeBaseModal.h"
#import "GMOffersByDealTypeModal.h"
#import "GMBannerModal.h"
#import "GMProductListingVC.h"

static NSString *kIdentifierSubCategoryHeader = @"subcategoryIdentifierHeader";
static NSString *kIdentifierSubCategoryCell = @"subcategoryIdentifierCell";

NSString *const kIdentifierNewSubCategoryCell = @"GMShopByCategoryCell";
//static NSString *kIdentifierSubCategoryLastCell = @"lastSubcategoryIdentifierCell";


@interface GMSubCategoryVC ()<UITableViewDelegate,UITableViewDataSource,GMShopByCategoryCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *subCategoryTableView;

@property (nonatomic, strong) NSMutableArray *subCategoryBannerModalArray;

@property (assign, nonatomic) NSInteger  expandedIndex;
@end

@implementation GMSubCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    self.expandedIndex = -1;
    self.navigationController.navigationBarHidden = NO;
    self.subcategoryDataArray = [[NSMutableArray alloc]init];
    self.subCategoryBannerModalArray = [[NSMutableArray alloc]init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isActive == %@", @"1"];
    self.subcategoryDataArray = [[self.rootCategoryModal.subCategories filteredArrayUsingPredicate:pred] mutableCopy];
    
    self.navigationController.title = self.rootCategoryModal.categoryName;
    if(NSSTRING_HAS_DATA(self.rootCategoryModal.categoryName)) {
        self.title = self.rootCategoryModal.categoryName;
    }
    
    if([self.rootCategoryModal.offercount integerValue]>0){
        GMCategoryModal *tempCategoryModal = [[GMCategoryModal alloc]init];
        tempCategoryModal.categoryId = @"-1";
        [self.subcategoryDataArray addObject:tempCategoryModal];
    }
    
    [self fetchCategoryBanner:self.rootCategoryModal];
    
    [[GMSharedClass sharedClass] showSubscribePopUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(NSSTRING_HAS_DATA(self.rootCategoryModal.categoryName)) {
        self.title = self.rootCategoryModal.categoryName;
    }
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_SubCategory_Screen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMSubCategoryHeaderView" bundle:[NSBundle mainBundle]];
    [self.subCategoryTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierSubCategoryHeader];
    
    nib = [UINib nibWithNibName:@"GMSubCategoryCell" bundle:[NSBundle mainBundle]];
    [self.subCategoryTableView registerNib:nib forCellReuseIdentifier:kIdentifierSubCategoryCell];
    
    
    [self.subCategoryTableView registerNib:[UINib nibWithNibName:@"GMShopByCategoryCell" bundle:nil] forCellReuseIdentifier:kIdentifierNewSubCategoryCell];
    
}

#pragma mark TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.subCategoryBannerModalArray.count;
    
    if(self.subCategoryBannerModalArray.count>0 ){
        return 1 + self.subCategoryBannerModalArray.count;
    }
    return 1;//self.subcategoryDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if(self.subcategoryDataArray.count>0 && section==0){
        return 1;
    }else if(section == 0){
        return 0;
    }else {
        return 0;
    }
    
//    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:section];
//    
//    if(categoryModal.isExpand)
//    {
//        if(section == self.expandedIndex) {
//            if(categoryModal.subCategories.count%2 == 0) {
//                return (categoryModal.subCategories.count/2)+1;
//            }
//            else {
//                return (categoryModal.subCategories.count/2) + 2;
//            }
//            
//        }
//        else {
//            return 0;
//        }
//    }
//    else
//    {
//        return 0;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(self.subcategoryDataArray.count>0 && indexPath.section==0){
        return [self shopByCategoryCellForTableView:tableView indexPath:indexPath];
    }else {
        
    }
    
    
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:indexPath.section];
    BOOL isLast = FALSE;
    
    if(categoryModal.subCategories.count%2 == 0) {
        if((categoryModal.subCategories.count/2) == indexPath.row) {
            isLast = TRUE;
        }
    }
    else {
        if((categoryModal.subCategories.count/2)+1 == indexPath.row) {
            isLast = TRUE;
        }
    }

    if(isLast) {
        GMSubCategoryCell *subCategoryCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierSubCategoryCell];
        [subCategoryCell configerLastCell];
        return subCategoryCell;
        
    } else {
    
        GMSubCategoryCell *subCategoryCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierSubCategoryCell];
        subCategoryCell.tag = indexPath.row;
        [subCategoryCell configerViewWithData:categoryModal.subCategories];
        
        [subCategoryCell.subCategoryBtn2 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [subCategoryCell.subCategoryBtn2 setExclusiveTouch:YES];
        
        [subCategoryCell.subCategoryBtn1 addTarget:self action:@selector(actionSubCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [subCategoryCell.subCategoryBtn1 setExclusiveTouch:YES];
        
        return subCategoryCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        
        NSUInteger items = self.subcategoryDataArray.count/3;
        if(self.subcategoryDataArray.count%3 !=0 ) {
            items= items+1;
        }
        return items * (SCREEN_SIZE.width/3) +10;
    }else {
        return 0;
    }
    
    
//    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:indexPath.section];
//    if(categoryModal.subCategories.count%2 == 0) {
//        if((categoryModal.subCategories.count/2) == indexPath.row) {
//            return 10;
//        } else {
//            return 50;
//        }
//        
//    }
//    else {
//        if((categoryModal.subCategories.count/2)+1 == indexPath.row) {
//            return 10;
//        } else {
//            return 50;
//        }
//    }
//        return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return 0;
    }else {
        return 156.0f;
    }
//        return 114.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return nil;
    }else {
        UIView *headerView;
       GMSubCategoryHeaderView *header  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierSubCategoryHeader];
        if (!header) {
                        header = [[GMSubCategoryHeaderView alloc] initWithReuseIdentifier:kIdentifierSubCategoryHeader];
                }
        
        GMBannerModal *bannerModal = [self.subCategoryBannerModalArray objectAtIndex:section-1];
        
//        GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:section];
        header.subcategoryBtn.tag = section;
        [header.subcategoryBtn addTarget:self action:@selector(actionHeaderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [header.subcategoryBtn setExclusiveTouch:YES];
//        [header configerViewWithData:categoryModal];
        [header configerViewWithNewData:bannerModal];
         headerView = header;
        return headerView;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SubcategoryScroller withCategory:@"" label:nil value:nil];
}



-(GMShopByCategoryCell*)shopByCategoryCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath{
    
    GMShopByCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierNewSubCategoryCell];
    [cell configureCellWithData:self.subcategoryDataArray cellIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}


-(void)didSelectCategoryItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath{
    
    
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:collectionIndexpath.row];
    
    if([categoryModal.categoryId isEqualToString:@"-1"]){
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_OfferCategorySelection withCategory:@"" label:self.rootCategoryModal.categoryName value:nil];
        [self getOffersDealFromServerWithCategoryModal:self.rootCategoryModal];
    }else {
    
        [self fetchProductListingDataForCategory:categoryModal];
        
        GMCityModal *cityModal = [GMCityModal selectedLocation];
        
        [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"L2" label:categoryModal.categoryName];
    }
    
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
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeCategoryGA;
        [self.navigationController pushViewController:rootVC animated:YES];

        
        
        return;
        
        
        
//        GMOffersByDealTypeBaseModal *baseMdl = offersByDealTypeBaseModal;
//        
//        if (baseMdl.allArray.count == 0 || baseMdl.deal_categoryArray == 0) {
//            return ;
//        }
//        
//        NSMutableArray *offersByDealTypeArray = [self createOffersByDealTypeModalFrom:baseMdl];
//        
//        if (offersByDealTypeArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
//            return ;
//        }
//        
//        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
//        rootVC.pageData = offersByDealTypeArray;
//        rootVC.navigationTitleString = categoryModal.categoryName;
//        rootVC.rootControllerType = GMRootPageViewControllerTypeOffersByDealTypeListing;
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
    return offersByDealTypeArray;
}


#pragma mark -

-(void)actionHeaderBtnClicked:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    
    
    
    
     GMBannerModal *bannerModal = [self.subCategoryBannerModalArray objectAtIndex:btnTag-1];
    
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init]; if(NSSTRING_HAS_DATA(bannerModal.name)){
        [qaGrapEventDic setObject:bannerModal.name forKey:kEY_QA_EventParmeter_BannerName];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:[NSString stringWithFormat:@"%@ %ld",kEY_QA_EventLabel_CategoryBanner_Click,(long)btnTag] withExtraParameter:qaGrapEventDic];
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    
    if(NSSTRING_HAS_DATA(bannerModal.sku)) {
        [localDic setObject:bannerModal.sku forKey:kEY_sku];
    }else {
        if (!NSSTRING_HAS_DATA(bannerModal.linkUrl)) {
            return;
        }
        
//        NSArray *typeStringArr = [bannerModal.linkUrl componentsSeparatedByString:@"?"];
//        NSString *typeStr = typeStringArr.firstObject;
        NSArray *valueStringArr = [bannerModal.linkUrl componentsSeparatedByString:@"="];
        NSString *value = valueStringArr.lastObject;
        
        if(NSSTRING_HAS_DATA(value)){
            [localDic setObject:value forKey:kEY_sku];
        }else {
            return;
        }
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] specialdeal:localDic withSuccessBlock:^(id productListingBaseModal) {
        [self removeProgress];
        
        GMProductListingBaseModal *productListingBaseMdl = productListingBaseModal;
        
        GMCategoryModal *categoryModal = [[GMCategoryModal alloc]init];
//        categoryModal.categoryId = bannerModal.categoryId;
        if(NSSTRING_HAS_DATA(bannerModal.categoryId)){
            categoryModal.categoryId = bannerModal.categoryId;
        }else {
            categoryModal.categoryId = @"-1";
        }
        categoryModal.categoryName = bannerModal.name;
        categoryModal.productListArray = productListingBaseMdl.productsListArray;
        categoryModal.totalCount = productListingBaseMdl.totalcount;
        
        GMProductListingVC *proListVC = [[GMProductListingVC alloc] initWithNibName:@"GMProductListingVC" bundle:nil];
        proListVC.catMdl = categoryModal;
        proListVC.rootPageAPIController = [[GMRootPageAPIController alloc] init];
        proListVC.productListingType = GMProductListingFromTypeOffer_OR_Deal;
        proListVC.productListPageViewType =
        GMRootPageViewControllerTypeOffersByDealTypeListing;
        proListVC.parentVC = nil;
        proListVC.gaTrackingEventText =  kEY_GA_Event_ProductListingThroughOffers;
        proListVC.productListingFromTypeForGA =  GMProductListingFromTypeSaveMoreGA;
        
        [self.navigationController pushViewController:proListVC animated:YES];

        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];

    
    return;
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:btnTag];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SubCategorySelection withCategory:@"" label:categoryModal.categoryName value:nil];
    if(categoryModal.isExpand)
    {
        if(self.expandedIndex != btnTag)
        {
            self.expandedIndex = btnTag;
            [self.subCategoryTableView reloadData];
            [self.subCategoryTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:btnTag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    else
    {
       
        
        [self fetchProductListingDataForCategory:categoryModal];
        
        GMCityModal *cityModal = [GMCityModal selectedLocation];
        
        [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"L2" label:categoryModal.categoryName];
    }
}

- (void)actionSubCategoryBtnClicked:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    GMCategoryModal *categoryModal = [self.subcategoryDataArray objectAtIndex:self.expandedIndex];;
    
    GMCategoryModal *categoryModal1 = [categoryModal.subCategories objectAtIndex:btnTag];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SubCategoryNext withCategory:@"" label:categoryModal1.categoryName value:nil];
    
    [self fetchProductListingDataForCategory:categoryModal1];

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
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlistingCategory;
        rootVC.navigationTitleString = categoryModal.categoryName;
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeCategoryGA;
        [self.navigationController pushViewController:rootVC animated:YES];

    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}



- (void)fetchCategoryBanner:(GMCategoryModal*)categoryModal {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:categoryModal.categoryId forKey:kEY_cat_id];
    
    [self showProgress];
    [[GMOperationalHandler handler] subcategoryBanner:localDic withSuccessBlock:^(id reposceArray) {
        [self removeProgress];
        
        self.subCategoryBannerModalArray = reposceArray;
        [self.subCategoryTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}





@end
