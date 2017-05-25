//
//  GMHotDealVC.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHotDealVC.h"
#import "GMHotDealCollectionViewCell.h"
#import "GMHotDealBaseModal.h"
#import "GMDealCategoryBaseModal.h"
#import "GMRootPageViewController.h"
#import "GMProductListingVC.h"

static NSString *kIdentifierHotDealCollectionCell = @"hotDealIdentifierCollectionCell";

@interface GMHotDealVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *dealCollectionView;

@property (strong, nonatomic) NSMutableArray *hotdealArray;

@end

@implementation GMHotDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForCollectionView];
    [self fetchHotDealsDataFronDB];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage backBtnImage]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(homeButtonPressed:)];
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_TabDeal withCategory:@"" label:nil value:nil];
    
    [[GMSharedClass sharedClass] showSubscribePopUp];
}

- (void)registerCellsForCollectionView {
    
    UINib *nib = [UINib nibWithNibName:@"GMHotDealCollectionViewCell" bundle:[NSBundle mainBundle]];
    
    [self.dealCollectionView registerNib:nib forCellWithReuseIdentifier:kIdentifierHotDealCollectionCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Hot Offers";
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_HotDeal_Screen];
}

#pragma mark - Button action

- (void)homeButtonPressed:(UIBarButtonItem*)sender {
    
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - WebService Handler

- (void)fetchHotDealsDataFronDB {
    
    GMHotDealBaseModal *hotDealBaseModal = [GMHotDealBaseModal loadHotDeals];
    self.hotdealArray = [NSMutableArray arrayWithArray:hotDealBaseModal.hotDealArray];
    [self.dealCollectionView reloadData];
}

#pragma mark - UICollectionView DataSource and Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.hotdealArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    GMHotDealModal *hotDealModal = [self.hotdealArray objectAtIndex:indexPath.row];
    GMHotDealCollectionViewCell *hotDealCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierHotDealCollectionCell forIndexPath:indexPath];
    [hotDealCollectionViewCell configureCellWithData:hotDealModal];
    return hotDealCollectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize retval =  CGSizeMake(SCREEN_SIZE.width, 170);
    return retval;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GMHotDealModal *hotDealModal = [self.hotdealArray objectAtIndex:indexPath.row];
    [self fetchDealCategoriesFromServerWithDealTypeId:hotDealModal.dealTypeId];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DealCategoryOpened withCategory:@"" label:hotDealModal.dealTypeId value:nil];

}

#pragma mark - Server handling Methods

- (void)fetchDealCategoriesFromServerWithDealTypeId:(NSString *)dealTypeId {
    
    [self showProgress];
    [[GMOperationalHandler handler] dealsByDealType:@{kEY_deal_type_id :dealTypeId, kEY_device : kEY_iOS} withSuccessBlock:^(id dealCategoryBaseModal) {
        
        [self removeProgress];
//        NSMutableArray *dealCategoryArray = [self createCategoryDealsArrayWith:dealCategoryBaseModal];
//        
//        if (dealCategoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
//            [[GMSharedClass sharedClass] showErrorMessage:@"Sorry, No products listed in this category"];
//            return ;
//        }
//
//        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
//        rootVC.pageData = dealCategoryArray;
//        rootVC.navigationTitleString = [dealCategoryBaseModal.dealNameArray firstObject];
//        rootVC.rootControllerType = GMRootPageViewControllerTypeDealCategoryTypeListing;
//        [self.navigationController pushViewController:rootVC animated:YES];
        
        
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
        rootVC.navigationTitleString = @"Deals";
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeDealGA;
        [self.navigationController pushViewController:rootVC animated:YES];
        

        
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

#pragma mark - banner handling

#pragma mark - fetchProductListingDataFor Offers OR Deals for 1 first page

- (void)fetchDealProductListingDataForOffersORDeals:(GMCategoryModal*)catMdl {
    
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
        proListVC.productListingFromTypeForGA =  GMProductListingFromTypeDealGA;
        
        [self.tabBarController setSelectedIndex:2];
        [self.navigationController pushViewController:proListVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}


- (void)fetchDealProductListingDataForOffersORDeals:(GMCategoryModal*)catMdl withNotificationId:(NSString *)notificationId{
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:catMdl.categoryId forKey:kEY_deal_id];
    [localDic setObject:@"1" forKey:kEY_page];
    [localDic setObject:kEY_iOS forKey:kEY_device];
    
    if(NSSTRING_HAS_DATA(notificationId)) {
        [localDic setObject:notificationId forKey:KEY_Notification_Id];
    }
    
    
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
        proListVC.productListingFromTypeForGA =  GMProductListingFromTypeDealGA;
        
        [self.tabBarController setSelectedIndex:2];
        [self.navigationController pushViewController:proListVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

@end
