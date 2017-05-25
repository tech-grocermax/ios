//
//  GMSinglePageVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 12/08/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMSinglePageVC.h"
#import "GMBannerModal.h"
#import "GMOperationalHandler.h"
#import "GMSearchResultModal.h"
#import "GMStateBaseModal.h"
#import "GMProductListingVC.h"
#import "GMProductDescriptionVC.h"

@interface GMSinglePageVC ()

@property(nonatomic, strong) GMBannerModal *bannerModal;


@property (weak, nonatomic) IBOutlet UIImageView *singlePageImageView;

@end

@implementation GMSinglePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.singlePageImageView  setImage:[UIImage subCategoryPlaceHolderImage]];
    [self configure];
    [self getSinglePageDataFromServer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configure{
    
    if(NSSTRING_HAS_DATA(self.displayName)){
        self.title = self.displayName;
    }else {
    self.title = @"Offer";
    }
}

#pragma mark - Server date

-(void)getSinglePageDataFromServer {
    
    [self showProgress];
    
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];

    
    if(NSSTRING_HAS_DATA(self.bannerSinglePageId)) {
        [userDic setObject:self.bannerSinglePageId forKey:@"id"];
    }
    
    [[GMOperationalHandler handler] getSinglepage:userDic withSuccessBlock:^(GMBannerModal *bannerModal) {
        
        self.bannerModal = bannerModal;
        
        if(NSSTRING_HAS_DATA(self.bannerModal.imageURL)){
            [self.singlePageImageView setImageWithURL:[NSURL URLWithString:self.bannerModal.imageURL] placeholderImage:[UIImage subCategoryPlaceHolderImage]];
        }else {
            [self.singlePageImageView  setImage:[UIImage subCategoryPlaceHolderImage]];
        }
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

- (IBAction)actionSinglePage:(id)sender {
    
    if(self.bannerModal){
        [self handleBannerAction:self.bannerModal];
    }
}




-(void)handleBannerAction:(GMBannerModal*)bannerMdl {
    
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
        
        [self fetchProductListingDataForCategory:bannerCatMdl];
        
    }else if ([typeStr isEqualToString:KEY_Banner_dealproductlisting]) {
        
        
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
        
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
        
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.navigationTitleString = @"Deals";;
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
@end
