//
//  GMOfferListVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOfferListVC.h"
#import "GMProductModal.h"


static NSString *kIdentifierOfferListCell = @"offerListIdentifierCell";
@interface GMOfferListVC ()
@property (strong, nonatomic) IBOutlet UITableView *offerListTableView;

@property (strong, nonatomic) NSMutableArray *productListArray;

@end

@implementation GMOfferListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"BEBEBE"]];
    [self registerCellsForTableView];
    [self getproductList];
    [[GMSharedClass sharedClass] showSubscribePopUp];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_OfferList_Screen];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Register Cells

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMTOfferListCell" bundle:[NSBundle mainBundle]];
    [self.offerListTableView registerNib:nib forCellReuseIdentifier:kIdentifierOfferListCell];
    
}

#pragma mark - Request Methods

- (void)getproductList {
    
    [self showProgress];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    if(self.categoryModal) {
        if(NSSTRING_HAS_DATA(self.categoryModal.categoryId)) {
            [dataDic setObject:self.categoryModal.categoryId forKey:kEY_cat_id];
        } else {
            [[GMSharedClass sharedClass] showErrorMessage:@"category not available"];
            return;
        }
    } else {
        [[GMSharedClass sharedClass] showErrorMessage:@"Category not available"];
        return;
    }
    
    [dataDic setObject:@"1" forKey:kEY_page];
    
    [[GMOperationalHandler handler] productList:dataDic  withSuccessBlock:^(GMProductListingBaseModal *responceData) {
        self.productListArray = (NSMutableArray *)responceData.productsListArray;
        
        if(self.productListArray.count>0) {
            [self.offerListTableView reloadData];
        }
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        
        [self removeProgress];
    }];
}

#pragma mark - TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.productListArray count];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    GMProductModal *productModal = [self.productListArray objectAtIndex:indexPath.row];
//    GMTOfferListCell *offerListCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierOfferListCell];
//    offerListCell.tag = indexPath.row;
//    [offerListCell.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [offerListCell configureViewWithProductModal:productModal];
//    return offerListCell;
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [GMTOfferListCell getCellHeight];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - IBAction Methods

- (void)deleteButtonTapped:(GMButton *)sender {
    
    
}

@end
