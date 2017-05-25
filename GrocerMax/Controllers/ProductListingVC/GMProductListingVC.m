//
//  GMProductListingVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductListingVC.h"
#import "GMProductListTableViewCell.h"
#import "GMProductDescriptionVC.h"
#import "GMStateBaseModal.h"
#import "GMShortProductListVC.h"

NSString *const kGMProductListTableViewCell = @"GMProductListTableViewCell";

@interface GMProductListingVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,GMRootPageAPIControllerDelegate, GMProductListCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *tblFooterLoadMoreView;
@property (weak, nonatomic) IBOutlet UITableView *productListTblView;
@property (strong, nonatomic) GMProductListingBaseModal *productBaseModal;
@property (strong, nonatomic) NSArray *displayProductListArray;
@property (assign, nonatomic) BOOL isLoading;

@property (strong, nonatomic) NSString *productRequestID;

@property (strong, nonatomic) IBOutlet UIButton *sortButton;

@end

@implementation GMProductListingVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self registerCellsForTableView];
    [self configureUI];
    
    self.rootPageAPIController.delegate = self;
    
    self.productRequestID = self.catMdl.categoryId;
    
    self.productBaseModal = [self.rootPageAPIController.modalDic objectForKey:self.productRequestID];
    
    if (self.productBaseModal.productsListArray.count == 0) {
        self.productBaseModal = [[GMProductListingBaseModal alloc] init];
        self.productBaseModal.productsListArray =(NSMutableArray *) self.catMdl.productListArray;
        self.productBaseModal.totalcount = self.catMdl.totalCount;//14/10/2015
        [self.rootPageAPIController.modalDic setObject:self.productBaseModal forKey:self.productRequestID];
    }
    
    if (self.productBaseModal.productsListArray.count == 0) {
        [self getProducListFromServer];
    }
    
    [self productDataSorting];
    
    [self.productListTblView reloadData];
    
    if(self.productListPageViewType == GMRootPageViewControllerTypeProductlistingCategory){
        self.sortButton.hidden = FALSE;
    }else {
        self.sortButton.hidden = TRUE;
    }
    
    [self eventTrack];
    [self QAeventTrackForIntration];
    
    [[GMSharedClass sharedClass] showSubscribePopUp];
}

- (void) viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_ProducList_Screen];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:self.gaTrackingEventText];
    if(self.parentVC != nil) {
    self.parentVC.cartModal = [GMCartModal loadCart];
    }
    [self productDataSorting];
    [self.productListTblView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configureUI

- (void) configureUI {

    if (NSSTRING_HAS_DATA(self.catMdl.categoryName)) {
        self.navigationItem.title = self.catMdl.categoryName;
    }else{
        self.navigationItem.title = @"Product List";
    }
    self.productListTblView.delegate = self;
    self.productListTblView.dataSource = self;
    self.productListTblView.tableFooterView = [UIView new];
    
//    if(self)
//    self.sortButton.hidden = TRUE;
}

#pragma mark - Register Cells

- (void)registerCellsForTableView {
    
    [self.productListTblView registerNib:[UINib nibWithNibName:@"GMProductListTableViewCell" bundle:nil] forCellReuseIdentifier:kGMProductListTableViewCell];
}

#pragma mark - UITableviewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return self.productBaseModal.productsListArray.count;
    return self.displayProductListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    GMProductModal *productModal = [self.productBaseModal.productsListArray objectAtIndex:indexPath.row];
    GMProductModal *productModal = [self.displayProductListArray objectAtIndex:indexPath.row];
    
    GMProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGMProductListTableViewCell];
    cell.delegate = self;
    
//    if(self.parentVC!= nil) {
////    if(self.parentVC.cartModal == nil){
//        
//            GMCartModal *newNewCartModal = [GMCartModal loadCart];
//            if(newNewCartModal != nil){
//                self.parentVC.cartModal = newNewCartModal;
//            }else {
//                GMCartModal *newCartModal = [[GMCartModal alloc]init];
//                newCartModal.cartItems = [[NSMutableArray alloc]init];
//                [newCartModal archiveCart];;
//                self.parentVC.cartModal = newCartModal;
//            }
//            [cell configureCellWithProductModal:productModal andCartModal:self.parentVC.cartModal];
////    }else{
////        [cell configureCellWithProductModal:productModal andCartModal:self.parentVC.cartModal];
////    }
//    }else{
    
        GMCartModal *newCartModal = [GMCartModal loadCart];
        if(newCartModal == nil){
            newCartModal = [[GMCartModal alloc]init];
            newCartModal.cartItems = [[NSMutableArray alloc]init];
            [newCartModal archiveCart];;
        }

        [cell configureCellWithProductModal:productModal andCartModal:newCartModal];
//    }
    
    
    [cell.imgBtn addTarget:self action:@selector(imgbtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.viewAllProductButton addTarget:self action:@selector(viewAllProductButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMProductModal *productModal = [self.displayProductListArray objectAtIndex:indexPath.row];
//    GMProductModal *productModal = [self.productBaseModal.productsListArray objectAtIndex:indexPath.row];
    
    
    if (productModal.promotion_level.length > 1 ){
        if(productModal.product_count>1){
            return [GMProductListTableViewCell cellHeightForPromotionalLabelWithText:productModal.promotion_level]+43;
        }else {
           return [GMProductListTableViewCell cellHeightForPromotionalLabelWithText:productModal.promotion_level];
        }
        
    }
    
    if(productModal.product_count>1){
        return [GMProductListTableViewCell cellHeightForNonPromotionalLabel]+43;
    }else {
    return [GMProductListTableViewCell cellHeightForNonPromotionalLabel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
//    vc.modal = self.productBaseModal.productsListArray[indexPath.row];
//    vc.parentVC = self.parentVC;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - scrollView Delegate

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ProductListScrolling withCategory:@"" label:self.catMdl.categoryName value:nil];

    if(self.isLoading)
        return; // currently executing this method
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat targetY = scrollView.contentSize.height - scrollView.bounds.size.height;
    
    if (offsetY > targetY) { // hit api for next page
        
        if (self.productBaseModal.productsListArray.count < self.productBaseModal.totalcount) {
            self.isLoading = YES;
            self.productListTblView.tableFooterView = self.tblFooterLoadMoreView;
            [self getProducListFromServer];
        }
    }
    
}

#pragma mark -

- (void)rootPageAPIControllerDidFinishTask:(GMRootPageAPIController *)controller {
    
    self.isLoading = NO;
    self.productListTblView.tableFooterView = nil;
    self.productBaseModal = [self.rootPageAPIController.modalDic objectForKey:self.productRequestID];
    
    
    [self productDataSorting];
    
    [self.productListTblView reloadData];
    
    [self removeProgress];
}

#pragma mark - API Hit

- (void)getProducListFromServer {
    
    switch (self.productListingType) {
            
        case GMProductListingFromTypeCategory:
        {
            [self.rootPageAPIController fetchProductListingDataForCategory:self.productRequestID];
        }
            break;
        case GMProductListingFromTypeOffer_OR_Deal:
        {
//            [self showProgress];
            [self.rootPageAPIController fetchDealProductListingDataForOffersORDeals:self.productRequestID];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - IBAction methods

- (void)imgbtnPressed:(GMButton*)sender {
    
    GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
    vc.modal = sender.produtModal;
    vc.parentVC = self.parentVC;
    vc.productListingFromTypeForGA = self.productListingFromTypeForGA;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)sortButtonPressed:(id)sender{
    
    GMShortProductListVC *shortProductListVC =  [[GMShortProductListVC alloc]init];
    [self.navigationController pushViewController:shortProductListVC animated:YES];
    
}
- (void)viewAllProductButtonPressed:(GMButton*)sender {
    
//    GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
//    vc.modal = sender.produtModal;
//    vc.parentVC = self.parentVC;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
//    GMHotDealModal *hotDealModal = [self.hotdealArray objectAtIndex:indexPath.row];
    [self fetchDealCategoriesFromServerWithDealTypeId:sender.produtModal.promo_id];
    
}


#pragma mark - Server handling Methods

- (void)fetchDealCategoriesFromServerWithDealTypeId:(NSString *)dealTypeId {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:dealTypeId forKey:kEY_deal_id];
    [localDic setObject:@"1" forKey:kEY_page];
    [localDic setObject:kEY_iOS forKey:kEY_device];
    
    
    [self showProgress];
    [[GMOperationalHandler handler] dealProductListing:localDic withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
        GMProductListingBaseModal *newModal = responceData;
        
        GMCategoryModal *categoryModal = [[GMCategoryModal alloc]init];
        categoryModal.productListArray = newModal.productsListArray;
        categoryModal.totalCount = newModal.totalcount;
        categoryModal.categoryId = self.catMdl.categoryId;
        categoryModal.categoryName = self.catMdl.categoryName;
        
        GMProductListingVC *proListVC = [[GMProductListingVC alloc] initWithNibName:@"GMProductListingVC" bundle:nil];
        proListVC.catMdl = categoryModal;
        proListVC.rootPageAPIController = [[GMRootPageAPIController alloc] init];
        proListVC.productListingType = GMProductListingFromTypeOffer_OR_Deal;
        proListVC.parentVC = nil;// do your work, deepak
        proListVC.gaTrackingEventText =  kEY_GA_Event_ProductListingThroughHomeBanner;
        proListVC.productListingFromTypeForGA =  self.productListingFromTypeForGA;
//        [self.tabBarController setSelectedIndex:2];
        [self.navigationController pushViewController:proListVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];}

- (void)addProductModalInCart:(GMProductModal *)productModal {
    
    if (![[GMSharedClass sharedClass] isInternetAvailable]) {
        
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"no_internet_connection")];
        return;
    }
    
    [self eventTrackForAddToCart:productModal];
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_AddCartitems withCategory:@"" label:[NSString stringWithFormat:@"%@ %@",productModal.productid,productModal.name] value:nil];
    
    NSString *title= @"";
    title = [NSString stringWithFormat:@"%@-%@-%@",productModal.productid,productModal.name,productModal.productQuantity];
        GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Add to Cart" label:title];

    NSDictionary *requestParam = [[GMCartRequestParam sharedCartRequest] addToCartParameterDictionaryNEWFromProductModal:productModal];
    
    
    [[GMOperationalHandler handler] addTocartGust:requestParam withSuccessBlock:nil failureBlock:nil];
    [self QAeventTrackForAddToCart:productModal];
    self.parentVC.cartModal = [GMCartModal loadCart];
    [self.tabBarController updateBadgeValueOnCartTab];
    
    
    
}


-(void)productDataSorting{
    int userSelecctedSortIndex = [[GMSharedClass sharedClass]getProductSortIndex];
    
    NSArray *sortedArray;
    switch (userSelecctedSortIndex) {
        case GMProductListingSortTypePopularity:
        {
            sortedArray = [self.productBaseModal.productsListArray sortedArrayUsingComparator:^(id obj1, id obj2){
                
                // TODO: default is the same?
                
                GMProductModal *productModalObj1 =(GMProductModal *) obj1;
                GMProductModal *productModalObj2 =(GMProductModal *) obj2;
                
                if([productModalObj1.rank intValue]>[productModalObj2.rank intValue])
                {
                    return (NSComparisonResult)NSOrderedAscending;
                }else if([productModalObj1.rank intValue]<[productModalObj2.rank intValue])
                {
                    return (NSComparisonResult)NSOrderedDescending;
                }else{
                    return (NSComparisonResult)NSOrderedSame;
                }
            }];
        }
            break;
        case GMProductListingSortTypeDiscounts:
        {
            
//            self.productModal.sale_price
            sortedArray = [self.productBaseModal.productsListArray sortedArrayUsingComparator:^(id obj1, id obj2){
                
                // TODO: default is the same?
                
                GMProductModal *productModalObj1 =(GMProductModal *) obj1;
                GMProductModal *productModalObj2 =(GMProductModal *) obj2;
                
                float firstDiscount = [productModalObj1.Price floatValue]-[productModalObj1.sale_price floatValue];
                float secondDiscount = [productModalObj2.Price floatValue]-[productModalObj2.sale_price floatValue];
                
                if(firstDiscount>secondDiscount)
                {
                    return (NSComparisonResult)NSOrderedAscending;
                }else if(firstDiscount<secondDiscount)
                {
                    return (NSComparisonResult)NSOrderedDescending;
                }else{
                    return (NSComparisonResult)NSOrderedSame;
                }
            }];

        }
            break;
        case GMProductListingSortTypeTitle_A_to_Z:
        {
            sortedArray = [self.productBaseModal.productsListArray sortedArrayUsingComparator:^NSComparisonResult(GMProductModal *productModalObj1, GMProductModal *productModalObj2){
                
                return [productModalObj1.p_brand compare:productModalObj2.p_brand];
                
            }];
        }
            break;
        case GMProductListingSortTypeTitle_Z_to_A:
        {
            sortedArray = [self.productBaseModal.productsListArray sortedArrayUsingComparator:^NSComparisonResult(GMProductModal *productModalObj1, GMProductModal *productModalObj2){
                
                return [productModalObj2.p_brand compare:productModalObj1.p_brand];
                
            }];
        }
            break;
        case GMProductListingSortTypePrice_Low_To_High:
        {
            sortedArray = [self.productBaseModal.productsListArray sortedArrayUsingComparator:^(id obj1, id obj2){
                
                // TODO: default is the same?

                GMProductModal *productModalObj1 =(GMProductModal *) obj1;
                GMProductModal *productModalObj2 =(GMProductModal *) obj2;
                
                if([productModalObj1.sale_price floatValue]>[productModalObj2.sale_price floatValue])
                {
                    return (NSComparisonResult)NSOrderedDescending;
                }else if([productModalObj1.sale_price floatValue]<[productModalObj2.sale_price floatValue])
                {
                    return (NSComparisonResult)NSOrderedAscending;
                }else{
                    return (NSComparisonResult)NSOrderedSame;
                }
            }];
        }
            break;
        case GMProductListingSortTypePrice_High_To_Low:
        {
            sortedArray = [self.productBaseModal.productsListArray sortedArrayUsingComparator:^(id obj1, id obj2){
                
                // TODO: default is the same?
                
                GMProductModal *productModalObj1 =(GMProductModal *) obj1;
                GMProductModal *productModalObj2 =(GMProductModal *) obj2;
                
                if([productModalObj1.sale_price floatValue]>[productModalObj2.sale_price floatValue])
                {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                else if([productModalObj1.sale_price floatValue]<[productModalObj2.sale_price floatValue])
                {
                    return (NSComparisonResult)NSOrderedDescending;
                }else {
                    return (NSComparisonResult)NSOrderedSame;
                }
            }];
            

        }
            break;
            
        default:
            break;
    }
        self.displayProductListArray = sortedArray;
    
}

-(void)eventTrack{
    switch (self.productListingFromTypeForGA) {
        case GMProductListingFromTypeCategoryGA:
        {
            NSString *categoryName = @"Category name";
            if(NSSTRING_HAS_DATA(self.catMdl.categoryName)) {
                categoryName = self.catMdl.categoryName;
            }
            [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Category_Page withCategory:kEY_GA_Category_Category_Interaction label:categoryName];
        }
            
            break;
        case GMProductListingFromTypeSearchGA:
        {
            NSString *keyword = @"Search";
            if (NSSTRING_HAS_DATA(self.catMdl.categoryName)) {
                keyword = self.catMdl.categoryName;
            }else if(NSSTRING_HAS_DATA(self.parentVC.navigationTitleString)) {
                keyword = self.parentVC.navigationTitleString;
            }
            [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventLabel_Keyword withCategory:kEY_GA_Category_Category_Interaction label:keyword];
        }
            
            break;
        case GMProductListingFromTypeDealGA:
        {
            NSString *dealName = @"Deal";
            if (NSSTRING_HAS_DATA(self.catMdl.categoryName)) {
                dealName = self.catMdl.categoryName;
            }else if(NSSTRING_HAS_DATA(self.parentVC.navigationTitleString)) {
                dealName = self.parentVC.navigationTitleString;
            }
            [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventLabel_Deal_Label withCategory:kEY_GA_Category_Category_Interaction label:dealName];
        }
            
            break;
        case GMProductListingFromTypeSaveMoreGA:
        {
            NSString *saveBigLableName = @"Save Big label";
            if (NSSTRING_HAS_DATA(self.catMdl.categoryName)) {
                saveBigLableName = self.catMdl.categoryName;
            }else if(NSSTRING_HAS_DATA(self.parentVC.navigationTitleString)) {
                saveBigLableName = self.parentVC.navigationTitleString;
            }
            [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Save_More withCategory:kEY_GA_Category_Category_Interaction label:saveBigLableName];
        }
            
            break;
            
        default:
            break;
    }
}

-(void)eventTrackForAddToCart:(GMProductModal *)productModal{
    
    NSString *productName = @"Product Name";
    
    if(NSSTRING_HAS_DATA(productModal.name) && NSSTRING_HAS_DATA(productModal.productid) ){
        productName = [NSString stringWithFormat:@"%@/%@",productModal.name,productModal.productid];
    }else if(NSSTRING_HAS_DATA(productModal.name) ){
        productName = [NSString stringWithFormat:@"%@",productModal.name];
    }
    else if(NSSTRING_HAS_DATA(productModal.productid) ){
        productName = [NSString stringWithFormat:@"%@",productModal.productid];
    }
    
    
    switch (self.productListingFromTypeForGA) {
        case GMProductListingFromTypeCategoryGA:
        {
            
            [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Category_Page withCategory:kEY_GA_Category_Add_To_Cart label:productName];
        }
            
            break;
        case GMProductListingFromTypeSearchGA:
        {
            [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventLabel_Keyword withCategory:kEY_GA_Category_Add_To_Cart label:productName];
        }
            
            break;
        case GMProductListingFromTypeDealGA:
        {
            
            [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventLabel_Deal_Label withCategory:kEY_GA_Category_Add_To_Cart label:productName];
        }
            
            break;
        case GMProductListingFromTypeSaveMoreGA:
        {
            [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Save_More withCategory:kEY_GA_Category_Add_To_Cart label:productName];
        }
            
            break;
            
        default:
            break;
    }
}


-(void)QAeventTrackForAddToCart:(GMProductModal *)productModal{
    
    GMUserModal *userModal = [[GMSharedClass sharedClass] getLoggedInUser];
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.userId)){
        [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    
    if(NSSTRING_HAS_DATA(productModal.name)){
        [qaGrapEventDic setObject:productModal.name forKey:kEY_QA_EventParmeter_ProductName];
    }
    
    if(NSSTRING_HAS_DATA(productModal.sku)){
        [qaGrapEventDic setObject:productModal.sku forKey:kEY_QA_EventParmeter_ProductCode];
    }
    
    if(NSSTRING_HAS_DATA(productModal.addedQuantity)){
        [qaGrapEventDic setObject:productModal.addedQuantity forKey:kEY_QA_EventParmeter_ProductQty];
    }
    
    if(NSSTRING_HAS_DATA(productModal.sale_price)){
        [qaGrapEventDic setObject:productModal.sale_price forKey:kEY_QA_EventParmeter_ProductSp];
    }
    
    
    if(NSSTRING_HAS_DATA(userModal.quoteId)){
        [qaGrapEventDic setObject:userModal.quoteId forKey:kEY_QA_EventParmeter_CartId];
    }
    
    
    
    switch (self.productListingFromTypeForGA) {
        case GMProductListingFromTypeCategoryGA:
        {
            
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_AddCart_Category withExtraParameter:qaGrapEventDic];
            
        }
            
            break;
        case GMProductListingFromTypeSearchGA:
        {
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_AddCart_Search withExtraParameter:qaGrapEventDic];
        }
            
            break;
        case GMProductListingFromTypeDealGA:
        {
            
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_AddCart_Deal withExtraParameter:qaGrapEventDic];
        }
            
            break;
        case GMProductListingFromTypeSaveMoreGA:
        {
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_AddCart_Banner withExtraParameter:qaGrapEventDic];
        }
            
            break;
            
        default:
            break;
    }
}


-(void)QAeventTrackForIntration{
    
    GMUserModal *userModal = [[GMSharedClass sharedClass] getLoggedInUser];
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.userId)){
        [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    
    switch (self.productListingFromTypeForGA) {
        case GMProductListingFromTypeCategoryGA:
        {
            NSString *categoryName = @"Category name";
            if(NSSTRING_HAS_DATA(self.catMdl.categoryName)) {
                categoryName = self.catMdl.categoryName;
            }
            [qaGrapEventDic setObject:categoryName forKey:kEY_QA_EventParmeter_CategoryName];
            
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Category withExtraParameter:qaGrapEventDic];
            
        }
            
            break;
        case GMProductListingFromTypeSearchGA:
        {
            NSString *keyword = @"Search";
            if (NSSTRING_HAS_DATA(self.catMdl.categoryName)) {
                keyword = self.catMdl.categoryName;
            }else if(NSSTRING_HAS_DATA(self.parentVC.navigationTitleString)) {
                keyword = self.parentVC.navigationTitleString;
            }
            [qaGrapEventDic setObject:keyword forKey:kEY_QA_EventParmeter_Keyword];
            
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Search withExtraParameter:qaGrapEventDic];
        }
            
            break;
        case GMProductListingFromTypeDealGA:
        {
            
            NSString *dealName = @"Deal";
            if (NSSTRING_HAS_DATA(self.catMdl.categoryName)) {
                dealName = self.catMdl.categoryName;
            }else if(NSSTRING_HAS_DATA(self.parentVC.navigationTitleString)) {
                dealName = self.parentVC.navigationTitleString;
            }
            [qaGrapEventDic setObject:dealName forKey:kEY_QA_EventParmeter_Deallabel];
            
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Deal withExtraParameter:qaGrapEventDic];
        }
            
            break;
        case GMProductListingFromTypeSaveMoreGA:
        {
            
            NSString *saveBigLableName = @"Save Big label";
            if (NSSTRING_HAS_DATA(self.catMdl.categoryName)) {
                saveBigLableName = self.catMdl.categoryName;
            }else if(NSSTRING_HAS_DATA(self.parentVC.navigationTitleString)) {
                saveBigLableName = self.parentVC.navigationTitleString;
            }
            [qaGrapEventDic setObject:saveBigLableName forKey:kEY_QA_EventParmeter_BannerName];
            
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Banner withExtraParameter:qaGrapEventDic];
        }
            
            break;
            
        default:
            break;
    }
}
@end
