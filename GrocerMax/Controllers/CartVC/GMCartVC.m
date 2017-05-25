//
//  GMCartVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCartVC.h"
#import "GMCartModal.h"
#import "GMCartDetailModal.h"
#import "GMCartCell.h"
#import "GMShipppingAddressVC.h"
#import "GMLoginVC.h"
#import "GMParentController.h"
#import "GMStateBaseModal.h"
#import "GMCouponVC.h"
#import "GMSoldOutItemCell.h"
#import "GMOrderDetailHeaderView.h"


@interface GMCartVC () <UITableViewDataSource, UITableViewDelegate, GMCartCellDelegate,GMSoldOutItemCellDelegate>

@property (strong, nonatomic) GMNavigationController *loginNavigationController;

@property (weak, nonatomic) IBOutlet UITableView *cartDetailTableView;

@property (weak, nonatomic) IBOutlet UIView *totalView;

@property (nonatomic, strong) GMCartDetailModal *cartDetailModal;

@property (weak, nonatomic) IBOutlet UIButton *updateOrderButton;

@property (weak, nonatomic) IBOutlet UIButton *placeOrderButton;

@property (nonatomic, strong) GMCartModal *cartModal;

@property (weak, nonatomic) IBOutlet UILabel *subTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *savedLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (nonatomic, strong) GMCheckOutModal *checkOutModal;

@property (weak, nonatomic) IBOutlet UILabel *totalItemInCartLbl;


@property (weak, nonatomic) IBOutlet UILabel *billBusterLbl;
@property (strong, nonatomic) IBOutlet UIView *billBusterView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableTopLayoutConstraint;

@property (strong, nonatomic) IBOutlet UIView *proceedView;//PROCEED

@property (strong, nonatomic) IBOutlet UIView *couponBgView;
@property (strong, nonatomic) IBOutlet UIView *couponView;
@property (strong, nonatomic) IBOutlet UIView *afterApplyCouponView;

@property (strong, nonatomic) IBOutlet UILabel *couponNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *couponDescriptionLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomLayoutContraint;

@property (nonatomic, strong) NSString *messageString;



@property (strong, nonatomic) IBOutlet UIView *removeItemsBgView;
@property (strong, nonatomic) IBOutlet UIView *removeItemsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *removeItemsViewHeightConstraints;

@property (weak, nonatomic) IBOutlet UIButton *updateRemoveItemBtn;
@property (weak, nonatomic) IBOutlet UITableView *removedItemsTableView;

@property(strong,nonatomic) NSMutableArray *soldOutItemArray;
@property(strong,nonatomic) NSMutableArray *outOfStockItemArray;


@end

static NSString *kIdentifierHeader = @"IdentifierHeader";

static NSString * const kCartCellIdentifier    = @"cartCellIdentifier";
static NSString * const kOutOFStokeCellIdentifier    = @"OutOFStokeCellIdentifier";

static NSString * const kSoldOutPromotionString = @"Please remove item from cart to proceed.";

static NSString * const kOutOfStockString = @"ONLY 121 IN STOCK.PLEASE REDUCE THE QUANTITY.";

@implementation GMCartVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.messageString = @"Fetching your cart items from server.";
    [self.totalView setHidden:YES];
    [self.proceedView setHidden:YES];
    [self registerCellsForTableView];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_TabCart withCategory:@"" label:nil value:nil];
//    [couponBgView.ro
    
//    self.couponBgView.layer.cornerRadius = 5.0;
//    self.couponBgView.layer.masksToBounds = YES;
//    self.couponBgView.layer.borderWidth = 0.8;
//    self.couponBgView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
    
    
    self.removeItemsView.layer.cornerRadius = 5.0;
    self.removeItemsView.layer.masksToBounds = YES;
    [self couponUIConfiger];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    self.messageString = @"Fetching your cart items from server.";
    self.cartModal = [GMCartModal loadCart];
    //    if(self.cartModal)
    self.cartDetailModal = [self.cartDetailModal initWithCartModal:self.cartModal];
    [self.cartDetailTableView reloadData];
    [self setTotalCount];
    [self fetchCartDetailFromServer];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Cart_Screen];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Open Cart" label:@""];
    
    [self couponUIConfiger];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    [self updateOrderButtonTapped:nil];
}

-(void)couponUIConfiger {
    
    
    [self.updateRemoveItemBtn setBackgroundColor:[UIColor colorFromHexString:@"A7A7A7"]];
    
//    else if([[GMSharedClass sharedClass] getUserLoggedStatus]){
        self.tableBottomLayoutContraint.constant = 50 ;
        self.couponBgView.hidden = FALSE;
        
        if(NSSTRING_HAS_DATA(self.cartDetailModal.couponCode)){
            self.couponView.hidden = TRUE;
            self.afterApplyCouponView.hidden = FALSE;
            self.couponNameLbl.text = [NSString stringWithFormat:@"Coupon Applied - %@",self.cartDetailModal.couponCode];
            if(NSSTRING_HAS_DATA(self.cartDetailModal.couponCodeDescription)){
                self.couponDescriptionLbl.text = self.cartDetailModal.couponCodeDescription;
            }else {
                self.couponDescriptionLbl.text = @"";
            }
        }else {
            self.couponView.hidden = FALSE;
            self.afterApplyCouponView.hidden = TRUE;
        }
        
//    }else {
//        self.tableBottomLayoutContraint.constant = 50 ;
//        self.couponBgView.hidden = TRUE;
//    }
    
    if(self.cartDetailModal.productItemsArray.count==0){
        self.tableBottomLayoutContraint.constant = 5 ;
        self.couponBgView.hidden = TRUE;
        self.updateOrderButton.hidden = TRUE;
        self.totalView.hidden = TRUE;
    }
    
    
}

- (void)registerCellsForTableView {
    
    [self.cartDetailTableView registerNib:[UINib nibWithNibName:@"GMCartCell" bundle:nil] forCellReuseIdentifier:kCartCellIdentifier];
    
    [self.removedItemsTableView registerNib:[UINib nibWithNibName:@"GMSoldOutItemCell" bundle:nil] forCellReuseIdentifier:kOutOFStokeCellIdentifier];
    
    UINib *nib = [UINib nibWithNibName:@"GMOrderDetailHeaderView" bundle:[NSBundle mainBundle]];
    [self.removedItemsTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierHeader];
    
    
}

#pragma mark - GETTER/SETTER Methods

//- (void)setTotalView:(UIView *)totalView {
//
//    _totalView = totalView;
//    _totalView.layer.cornerRadius = 5.0;
//    _totalView.layer.masksToBounds = YES;
//    _totalView.layer.borderWidth = 0.8;
//    _totalView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
//}

#pragma mark - Server handling Method
- (void)fetchCartDetailFromServer {
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    if(!NSSTRING_HAS_DATA(userModal.quoteId)) {
        self.cartDetailModal = nil;
        self.cartDetailModal = nil;
        [self.totalView setHidden:YES];
        [self.proceedView setHidden:YES];
        self.messageString = @"No item in your cart, Please add item.";
        
        self.billBusterView.hidden = TRUE;
        self.tableTopLayoutConstraint.constant = 64;
        self.billBusterLbl.text = @"";
        [self.cartDetailTableView reloadData];
        [self showOrHideItemOutOfStockView];
        
        self.updateOrderButton.hidden = TRUE;
        self.totalView.hidden = TRUE;
        
        self.couponBgView.hidden = TRUE;
        
        return;
    }
    NSDictionary *requestDict = [[GMCartRequestParam sharedCartRequest] cartDetailRequestParameter];
    [self showProgress];
    [[GMOperationalHandler handler] cartDetail:requestDict withSuccessBlock:^(GMCartDetailModal *cartDetailModal) {
        
        [self removeProgress];
        if(cartDetailModal.productItemsArray.count > 0) {
            
            
            
            self.cartDetailModal = cartDetailModal;
            self.cartModal = nil;
            self.cartModal = [[GMCartModal alloc] initWithCartDetailModal:cartDetailModal];
            [self.cartModal archiveCart];
            [self.tabBarController updateBadgeValueOnCartTab];
            [self.totalView setHidden:NO];
            [self.proceedView setHidden:NO];
            [self.updateOrderButton setHidden:YES];
            [self configureAmountView];
            [self couponUIConfiger];
            [self setTotalCount];
            
            [self checkIsAnyItemOutOfStock];
            [self showOrHideItemOutOfStockView];
            self.couponBgView.hidden = FALSE;
            
            NSString *allProductNameAndID = [self allProductNameAndId];
            [[GMSharedClass sharedClass] trakeEventWithNameNew:allProductNameAndID withCategory:kEY_GA_Category_View_Cart label:[NSString stringWithFormat:@"%ld",self.cartDetailModal.productItemsArray.count]];
            
        } else {
            self.cartDetailModal = nil;
            [self.totalView setHidden:YES];
            [self.proceedView setHidden:YES];
            self.messageString = @"No item in your cart, Please add item.";
            self.billBusterView.hidden = TRUE;
            self.tableTopLayoutConstraint.constant = 64;
            self.billBusterLbl.text = @"";
            self.couponBgView.hidden = TRUE;
            [self couponUIConfiger];
            [self showOrHideItemOutOfStockView];
        }
        [self.cartDetailTableView reloadData];
        
        NSMutableDictionary *qaGrapEventDic = [self QATrakerParmeters];
        [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_ViewCart withExtraParameter:qaGrapEventDic];
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
        self.messageString = @"Problem to fetch your cart.";
        [self.totalView setHidden:YES];
        [self.updateOrderButton setHidden:YES];
        [self.proceedView setHidden:YES];
        self.billBusterView.hidden = TRUE;
        self.tableTopLayoutConstraint.constant = 64;
        self.billBusterLbl.text= @"";
        [self.cartDetailTableView reloadData];
        [self couponUIConfiger];
        [self showOrHideItemOutOfStockView];
    }];
}

- (void)configureAmountView {
    
    [self.subTotalLabel setText:[NSString stringWithFormat:@"₹%.2f", self.cartDetailModal.subTotal.doubleValue]];
    if(self.cartDetailModal.shippingAmount.doubleValue <= 0) {
        [self.totalLabel setText:[NSString stringWithFormat:@""]];
    }else{
        [self.totalLabel setText:[NSString stringWithFormat:@"Shipping: ₹%.2f\n", self.cartDetailModal.shippingAmount.doubleValue]];
    }
    [self.totalLabel setText:[NSString stringWithFormat:@"%@Total: ₹%.2f", self.totalLabel.text,self.cartDetailModal.grandTotal.doubleValue]];
    double savingAmount = [self getSavedAmount];
    [self.savedLabel setText:[NSString stringWithFormat:@"₹%.2f", savingAmount]];
    
    if(NSSTRING_HAS_DATA(self.cartDetailModal.billBuster)) {
        self.billBusterView.hidden = FALSE;
        self.tableTopLayoutConstraint.constant = 114;
        [self.billBusterLbl setText:self.cartDetailModal.billBuster];
    } else {
        [self.billBusterLbl setText:@""];
        self.billBusterView.hidden = TRUE;
        self.tableTopLayoutConstraint.constant = 64;
    }
}

- (double)getSavedAmount {
    
    double saving = 0;
    for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
        
        saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
    }
    if(NSSTRING_HAS_DATA(self.cartDetailModal.discountAmount)) {
        
        if(self.cartDetailModal.discountAmount.doubleValue>0) {
            saving = saving + self.cartDetailModal.discountAmount.doubleValue;
        }else {
            saving = saving - self.cartDetailModal.discountAmount.doubleValue;
        }
        
    }
    
    return saving;
}

- (void)updateAmountViewWhenQuantityChanged {
    
    if(self.cartDetailModal.shippingAmount.doubleValue <= 0) {
        [self.totalLabel setText:[NSString stringWithFormat:@""]];
    }else{
        [self.totalLabel setText:[NSString stringWithFormat:@"Shipping: ₹%.2f\n", self.cartDetailModal.shippingAmount.doubleValue]];
    }
//    [self.shippingChargeLabel setText:[NSString stringWithFormat:@"₹%.2f", self.cartDetailModal.shippingAmount.doubleValue]];
    
    double saving = 0;
    double subtotal = 0;
    for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
        
        saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
        subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
    }
//    if(NSSTRING_HAS_DATA(self.cartDetailModal.discountAmount))
//        saving = saving + self.cartDetailModal.discountAmount.doubleValue;
    
    if(NSSTRING_HAS_DATA(self.cartDetailModal.discountAmount)) {
        
        if(self.cartDetailModal.discountAmount.doubleValue>0) {
            saving = saving + self.cartDetailModal.discountAmount.doubleValue;
        }else {
            saving = saving - self.cartDetailModal.discountAmount.doubleValue;
        }
        
    }
    
    [self.subTotalLabel setText:[NSString stringWithFormat:@"₹%.2f", subtotal]];
    [self.savedLabel setText:[NSString stringWithFormat:@"₹%.2f", saving]];
    double grandTotal = subtotal + self.cartDetailModal.shippingAmount.doubleValue;
    [self.totalLabel setText:[NSString stringWithFormat:@"%@Total: ₹%.2f",self.totalLabel.text, grandTotal]];
}

- (void)checkIsAnyItemOutOfStock {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.Status == %@", @"0"];
    NSArray *filteredArr = [self.cartDetailModal.productItemsArray filteredArrayUsingPredicate:pred];
    if(filteredArr.count) {
        
        [self.proceedView setHidden:YES];
        [self.updateOrderButton setHidden:NO];
    }
}



-(void)showOrHideItemOutOfStockView{
   
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.Status == %@", @"0"];
//    
//    NSArray *filteredArr = [self.cartDetailModal.productItemsArray filteredArrayUsingPredicate:pred];
    
    if(self.soldOutItemArray == nil){
        self.soldOutItemArray = [[NSMutableArray alloc]init];
    }else {
        [self.soldOutItemArray removeAllObjects];
    }
    
//    self.soldOutItemArray = (NSMutableArray *)[self.cartDetailModal.productItemsArray filteredArrayUsingPredicate:pred];
    
    
//    if(filteredArr.count) {
//        [self.soldOutItemArray addObjectsFromArray:filteredArr];
//    }
    
//    soldOutItemArray;
//    outOfStockItemArray;
    
    if(self.outOfStockItemArray == nil){
        self.outOfStockItemArray = [[NSMutableArray alloc]init];
    }else {
        [self.outOfStockItemArray removeAllObjects];
    }
    
    
    for(int i = 0; i< self.cartDetailModal.productItemsArray.count; i++) {
        
        GMProductModal *productModal = [self.cartDetailModal.productItemsArray objectAtIndex:i];
        
        
        if ([productModal.Status isEqualToString:@"0"] && [productModal.noOfItemInStock intValue]>0 && productModal.sale_price.integerValue == 0){
            
            
            [self.outOfStockItemArray addObject:productModal];

        }else {
//        if(self.outOfStockItemArray.count>0) {
        
            NSPredicate *addedPred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", productModal.productid];
            
            NSArray *filtereAddeddArr = [self.outOfStockItemArray filteredArrayUsingPredicate:addedPred];
        
            NSArray *filtereSoldOutAddeddArr = [self.soldOutItemArray filteredArrayUsingPredicate:addedPred];
        
            if(filtereSoldOutAddeddArr.count>0) {
                
                
                GMProductModal *filterProductModal = [filtereSoldOutAddeddArr objectAtIndex:0];
                
                if([filterProductModal.productQuantity intValue]<2) {
                    
                }else {
                    
                    int allQuantity = [filterProductModal.productQuantity intValue] + 1;
                    filterProductModal.productQuantity = [NSString stringWithFormat:@"%d",allQuantity];
                    
                }
                continue;
            }else if(filtereAddeddArr.count>0) {
                GMProductModal *filterProductModal = [filtereAddeddArr objectAtIndex:0];
                
                if([filterProductModal.productQuantity intValue]<2) {
                    
                }else {
                    
                    int allQuantity = [filterProductModal.productQuantity intValue] + 1;
                    filterProductModal.productQuantity = [NSString stringWithFormat:@"%d",allQuantity];
                    
                }
                continue;
            }
//        }
        
        
        
        NSPredicate *newPred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", productModal.productid];
        
        NSArray *filteredArr = [self.cartDetailModal.productItemsArray filteredArrayUsingPredicate:newPred];
        
        int totalProductOfGivenId = 0;
        
        for(int k = 0;k<filteredArr.count;k++){
            
            GMProductModal *filterProductModal = [filteredArr objectAtIndex:k];
            
            totalProductOfGivenId = totalProductOfGivenId + [filterProductModal.productQuantity intValue];
        }
        
        
        if ( [productModal.noOfItemInStock intValue]>1 &&[productModal.noOfItemInStock intValue] < totalProductOfGivenId){
                [self.outOfStockItemArray addObject:productModal];
            }else if ([productModal.noOfItemInStock intValue] < totalProductOfGivenId){
                [self.soldOutItemArray addObject:productModal];
            }
        }
    }
    
    if(self.outOfStockItemArray.count > 0 || self.soldOutItemArray.count > 0) {
        
        [self.updateRemoveItemBtn setBackgroundColor:[UIColor colorFromHexString:@"A7A7A7"]];
        self.updateRemoveItemBtn.userInteractionEnabled = FALSE;
        
        
        UIView *footer =
        [[UIView alloc] initWithFrame:CGRectZero];
        self.removedItemsTableView.tableFooterView = footer;
        footer = nil;
        
//        [self.removedItemsTableView setTableFooterView:nil];
        self.removeItemsBgView.hidden = FALSE;
        self.removedItemsTableView.dataSource = self;
        self.removedItemsTableView.delegate = self;
        [self.removedItemsTableView reloadData];
    }else {
        self.removeItemsBgView.hidden = TRUE;
        
        [self.updateRemoveItemBtn setBackgroundColor:[UIColor colorFromHexString:@"F57C01"]];
        self.updateRemoveItemBtn.userInteractionEnabled = TRUE;
    }
}

#pragma mark - UITableView Delegates/Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.removedItemsTableView)
    {
        if(self.soldOutItemArray.count>0 && self.outOfStockItemArray.count>0){
            CGFloat height  = 2*40+44+[GMSoldOutItemCell getCellHeight]*(self.soldOutItemArray.count+self.outOfStockItemArray.count);
            self.removeItemsViewHeightConstraints.constant = height > (kScreenHeight - 120) ? (kScreenHeight - 120) : height;
           return 2;
        }
        else if(self.outOfStockItemArray.count>0){
            CGFloat height   = 1*40+44+[GMSoldOutItemCell getCellHeight]*(self.outOfStockItemArray.count);
            self.removeItemsViewHeightConstraints.constant = height > (kScreenHeight - 120) ? (kScreenHeight - 120) : height;

            return 1;
        }
        else if(self.soldOutItemArray.count>0){
            CGFloat height   = 1*40+44+[GMSoldOutItemCell getCellHeight]*(self.soldOutItemArray.count);
            self.removeItemsViewHeightConstraints.constant = height > (kScreenHeight - 120) ? (kScreenHeight - 120) : height;

            return 1;
        }
        
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.removedItemsTableView)
    {
        if(self.soldOutItemArray.count>0 && self.outOfStockItemArray.count>0){
            if(section == 0)
            {
                return self.soldOutItemArray.count;
            }else{
                 return self.outOfStockItemArray.count;
            }
        }
        else if(self.outOfStockItemArray.count>0)
            return self.outOfStockItemArray.count;
        else if(self.soldOutItemArray.count>0)
            return self.soldOutItemArray.count;
        else {
            return 0;
        }
    }else{
        return [self.cartDetailModal.productItemsArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.removedItemsTableView)
    {
        return [GMSoldOutItemCell getCellHeight]; ;
    }
    else {
    GMProductModal *productModal = [self.cartDetailModal.productItemsArray objectAtIndex:indexPath.row];
//    if(NSSTRING_HAS_DATA(productModal.promotion_level) && [productModal.Status isEqualToString:@"0"])
//        return [GMCartCell cellHeightForPromotionalLabelWithText:kSoldOutPromotionString];
//    else if(NSSTRING_HAS_DATA(productModal.promotion_level))
//        return [GMCartCell cellHeightForPromotionalLabelWithText:productModal.promotion_level];
//    else if ([productModal.Status isEqualToString:@"0"])
//        return [GMCartCell cellHeightForPromotionalLabelWithText:kSoldOutPromotionString];
//    else
//        return [GMCartCell cellHeightWithNoPromotion];
    
    if([productModal.Status isEqualToString:@"0"] && [productModal.noOfItemInStock intValue]>0) {
        
        if(productModal.sale_price.integerValue == 0) {
            if(NSSTRING_HAS_DATA(productModal.promotion_level))
                return [GMCartCell cellHeightForPromotionalLabelWithText:productModal.promotion_level];
            else
                return [GMCartCell cellHeightWithNoPromotion];
        } else {
            return [GMCartCell cellHeightForPromotionalLabelWithText:kOutOfStockString];
        }
        
    }
    else if(NSSTRING_HAS_DATA(productModal.promotion_level) && [productModal.Status isEqualToString:@"0"])
        return [GMCartCell cellHeightForPromotionalLabelWithText:kSoldOutPromotionString];
    else if(NSSTRING_HAS_DATA(productModal.promotion_level))
        return [GMCartCell cellHeightForPromotionalLabelWithText:productModal.promotion_level];
    else if ([productModal.Status isEqualToString:@"0"])
        return [GMCartCell cellHeightForPromotionalLabelWithText:kSoldOutPromotionString];
    else
        return [GMCartCell cellHeightWithNoPromotion];
    
    
    }
//    && [self.productModal.noOfItemInStock intValue]<1
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(tableView == self.removedItemsTableView)
    {
        return 40 ;
    }else {
        
    
        if(self.cartDetailModal.productItemsArray.count>0) {
            return 0;
        }
        else {
            return tableView.frame.size.height;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if(tableView == self.removedItemsTableView)
    {
            UIView *headerView;
            GMOrderDetailHeaderView *header  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierHeader];
            if (!header) {
                header = [[GMOrderDetailHeaderView alloc] initWithReuseIdentifier:kIdentifierHeader];
            }
            
            if(self.soldOutItemArray.count>0 && self.outOfStockItemArray.count>0){
                if(section == 0) {
                    [header congigerHeaderData:[NSString stringWithFormat:@"Please remove items to proceed"]];
                } else {
                    [header congigerHeaderData:[NSString stringWithFormat:@"Please reduce quantity to proceed"]];
                }
            }else if(self.soldOutItemArray.count>0 ){
                [header congigerHeaderData:[NSString stringWithFormat:@"Please remove items to proceed"]];
            }else if(self.outOfStockItemArray.count>0 ){
                [header congigerHeaderData:[NSString stringWithFormat:@"Please reduce quantity to proceed"]];
            }
            header.headerBgView.backgroundColor = [UIColor whiteColor];
            headerView = header;
            return headerView;
        } else {
            if(self.cartDetailModal.productItemsArray.count>0) {
                return nil;
        }
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, CGRectGetHeight(tableView.bounds))];
        [headerView setBackgroundColor:[UIColor clearColor]];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, CGRectGetHeight(tableView.bounds))];
        [headerLabel setTextColor:[UIColor darkTextColor]];
        [headerLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        [headerView addSubview:headerLabel];
        [headerLabel setText:self.messageString];
        
        return headerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.removedItemsTableView)
    {
        
        
        GMSoldOutItemCell *soldOutItemCell = [tableView dequeueReusableCellWithIdentifier:kOutOFStokeCellIdentifier];
        soldOutItemCell.delegate = self;
        
        
        GMProductModal *productModal ;
        
        if(self.soldOutItemArray.count>0 && self.outOfStockItemArray.count>0){
            if(indexPath.section == 0) {
                productModal = [self.soldOutItemArray objectAtIndex:indexPath.row];
                [soldOutItemCell.removeBtn addTarget:self action:@selector(removeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                [soldOutItemCell configerUIForSoldOutWithData:productModal];
            } else {
                productModal = [self.outOfStockItemArray objectAtIndex:indexPath.row];
                [soldOutItemCell configerUIForOutOfStokWithData:productModal];
            }
        }else if(self.soldOutItemArray.count>0 ){
            productModal = [self.soldOutItemArray objectAtIndex:indexPath.row];
            [soldOutItemCell.removeBtn addTarget:self action:@selector(removeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [soldOutItemCell configerUIForSoldOutWithData:productModal];
        }else if(self.outOfStockItemArray.count>0 ){
             productModal = [self.outOfStockItemArray objectAtIndex:indexPath.row];
            [soldOutItemCell configerUIForOutOfStokWithData:productModal];
        }

        return soldOutItemCell ;
    }else {
        GMProductModal *productModal = [self.cartDetailModal.productItemsArray objectAtIndex:indexPath.row];
        GMCartCell *cartCell = [tableView dequeueReusableCellWithIdentifier:kCartCellIdentifier];
        [cartCell.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cartCell setDelegate:self];
        [cartCell configureViewWithProductModal:productModal];
        return cartCell;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CartScroller withCategory:@"" label:nil value:nil];
}
#pragma mark - GMCartCellDelegate Methods

- (void)productQuantityValueChanged {
    
    [self.proceedView setHidden:YES];
    [self.updateOrderButton setHidden:NO];
    [self updateAmountViewWhenQuantityChanged];
    [self setTotalCount];
}

#pragma mark - GMSoldOutItemCellDelegate Methods

- (void)productQuantityValueReduce {
    [self checKUpdateNeedEnable];
}

#pragma mark - IBAction Methods

- (void)deleteButtonTapped:(GMButton *)sender {
    
    GMProductModal *deletedProductModal = [[GMProductModal alloc] initWithProductModal:sender.produtModal];
    [self.cartDetailModal.deletedProductItemsArray addObject:deletedProductModal];
    [self.cartDetailModal.productItemsArray removeObject:sender.produtModal];
    [self productQuantityValueChanged];
    [self removeObjectFromCartArrayWithModal:sender.produtModal];
    if(self.cartDetailModal.productItemsArray.count == 0) {
        [self backButtonTapped:nil];
    }
    [self.cartDetailTableView reloadData];
}

- (void)removeButtonTapped:(GMButton *)sender {
    
    GMProductModal *deletedProductModal = [[GMProductModal alloc] initWithProductModal:sender.produtModal];
    [self.cartDetailModal.deletedProductItemsArray addObject:deletedProductModal];
    [self.cartDetailModal.productItemsArray removeObject:sender.produtModal];
    sender.produtModal.isDeleted = YES;
//    [self.soldOutItemArray removeObject:sender.produtModal];
    
    [self productQuantityValueChanged];
    [self removeObjectFromCartArrayWithModal:sender.produtModal];
    
    
    [self checKUpdateNeedEnable];
    
//    if(self.cartDetailModal.productItemsArray.count == 0) {
//        [self backButtonTapped:nil];
//    }
//    [self.cartDetailTableView reloadData];
    
    if(self.soldOutItemArray.count>0 || self.outOfStockItemArray.count>0) {
        [self.removedItemsTableView reloadData];
    }else {
        [self updateOrderButtonTapped:nil];
        self.removeItemsBgView.hidden = TRUE;
    }
    
}


- (void)checKUpdateNeedEnable {
    
    NSArray *soldArry ;
    NSArray *outOfStockArry ;
    
    if(self.soldOutItemArray.count>0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(GMProductModal *evaluatedObject, NSDictionary *bindings) {
            
            BOOL isDeleted = evaluatedObject.isDeleted;
            
            if(isDeleted == TRUE) {
                return NO;
            }
            else
                return YES;
        }];
        
        soldArry = [self.soldOutItemArray filteredArrayUsingPredicate:predicate];
    }
    
    if(self.outOfStockItemArray.count>0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(GMProductModal *evaluatedObject, NSDictionary *bindings) {
            
            if ( [evaluatedObject.noOfItemInStock intValue]>1 &&[evaluatedObject.noOfItemInStock intValue] >= [evaluatedObject.productQuantity intValue]){
                
                return NO;
                
            }else {
                
                return YES;
                
            }
        }];
        
        outOfStockArry = [self.outOfStockItemArray filteredArrayUsingPredicate:predicate];
    }
    
    if((outOfStockArry != nil && soldArry != nil) || (outOfStockArry.count == 0 && soldArry.count == 0)) {
        [self.updateRemoveItemBtn setBackgroundColor:[UIColor colorFromHexString:@"F57C01"]];
        self.updateRemoveItemBtn.userInteractionEnabled = TRUE;
    }else {
        
        [self.updateRemoveItemBtn setBackgroundColor:[UIColor colorFromHexString:@"A7A7A7"]];
        self.updateRemoveItemBtn.userInteractionEnabled = FALSE;
    }

}

- (void)removeObjectFromCartArrayWithModal:(GMProductModal *)productModal {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", productModal.productid];
    NSArray *filteredArr = [self.cartModal.cartItems filteredArrayUsingPredicate:pred];
    GMProductModal *deleteProductModal = filteredArr.firstObject;
    if(deleteProductModal)
        [self.cartModal.cartItems removeObject:deleteProductModal];
    [self removeFreeItemsFromCartWhenAllCartPricedItemDeleted];
    [self.cartModal archiveCart];
    [self.tabBarController updateBadgeValueOnCartTab];
}

- (void)removeFreeItemsFromCartWhenAllCartPricedItemDeleted {
    
    NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(GMProductModal *evaluatedObject, NSDictionary *bindings) {
        
        if(evaluatedObject.sale_price.integerValue == 0)
            return YES;
        else
            return NO;
    }];
    NSArray *freeItemsArray = [self.cartDetailModal.productItemsArray filteredArrayUsingPredicate:pred];
    if(self.cartDetailModal.productItemsArray.count == freeItemsArray.count) {
        
        [self.cartDetailModal.productItemsArray removeAllObjects];
        [self.cartModal.cartItems removeAllObjects];
    }
}

- (IBAction)placeOrderButtonTapped:(id)sender {
    
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CartPlaceOrder withCategory:@"" label:nil value:nil];
    
    if(self.cartDetailModal.productItemsArray.count) {
        if(self.checkOutModal) {
            self.checkOutModal = nil;
        }
        if([[GMSharedClass sharedClass] getUserLoggedStatus] == NO) {
            
            
            
            GMLoginVC *loginVC = [[GMLoginVC alloc] initWithNibName:@"GMLoginVC" bundle:nil];
            loginVC.isPresent = YES;
            
            // Do any additional setup after loading the view from its nib.
            self.loginNavigationController = [[GMNavigationController alloc]initWithRootViewController:loginVC];
            self.loginNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            self.loginNavigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
            self.loginNavigationController.navigationBarHidden = YES;
            self.navigationController.hidesBottomBarWhenPushed = YES;
            [self.navigationController presentViewController:self.loginNavigationController  animated:YES completion:nil];
        }
        else {
            
            NSMutableDictionary *qaGrapEventDic = [self QATrakerParmeters];
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_ProceedCheckOut withExtraParameter:qaGrapEventDic];
            
            
            
            GMCityModal *cityModal = [GMCityModal selectedLocation];
            [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Proceed to Checkout" label:@""];
            
            NSString *allProductNameAndID = [self allProductNameAndId];
            [[GMSharedClass sharedClass] trakeEventWithNameNew:allProductNameAndID withCategory:kEY_GA_Category_Proceed_To_Checkout label:[NSString stringWithFormat:@"%ld",self.cartDetailModal.productItemsArray.count]];
            
            self.checkOutModal = [[GMCheckOutModal alloc]init];
            GMShipppingAddressVC *shipppingAddressVC = [[GMShipppingAddressVC alloc] initWithNibName:@"GMShipppingAddressVC" bundle:nil];
            self.checkOutModal.cartDetailModal = self.cartDetailModal;
            shipppingAddressVC.checkOutModal = self.checkOutModal;
            [self.navigationController pushViewController:shipppingAddressVC animated:YES];
        }
    } else {
        [[GMSharedClass sharedClass] showErrorMessage:@"No any item in your cart"];
    }
    
}

- (IBAction)actionChangeCoupon:(id)sender {
    
    GMCouponVC *couponVC = [[GMCouponVC alloc]init];
    couponVC.applyedCouponCode = self.cartDetailModal.couponCode;
    [self.navigationController pushViewController:couponVC animated:YES];
    
    
    
}

- (IBAction)actionApplyCoupon:(id)sender {
    
    if([[GMSharedClass sharedClass] getUserLoggedStatus] == NO) {
        GMLoginVC *loginVC = [[GMLoginVC alloc] initWithNibName:@"GMLoginVC" bundle:nil];
        loginVC.isPresent = YES;
        self.loginNavigationController = [[GMNavigationController alloc]initWithRootViewController:loginVC];
        self.loginNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.loginNavigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.loginNavigationController.navigationBarHidden = YES;
        self.navigationController.hidesBottomBarWhenPushed = YES;
        [self.navigationController presentViewController:self.loginNavigationController  animated:YES completion:nil];
    }else {
        GMCouponVC *couponVC = [[GMCouponVC alloc]init];
        [self.navigationController pushViewController:couponVC animated:YES];
    }
}




-(NSString *)allProductNameAndId {
    NSString *productName = @"";
    for(int i = 0; i<self.cartDetailModal.productItemsArray.count; i++) {
        GMProductModal *productModal = [self.cartDetailModal.productItemsArray objectAtIndex:i];
        
        if(i==0){
            if(NSSTRING_HAS_DATA(productModal.name) && NSSTRING_HAS_DATA(productModal.productid)){
                productName = [NSString stringWithFormat:@"%@/%@",productModal.name, productModal.productid];
            }else if(NSSTRING_HAS_DATA(productModal.name)){
                productName = [NSString stringWithFormat:@"%@",productModal.name];
            }else if(NSSTRING_HAS_DATA(productModal.productid)){
                productName = [NSString stringWithFormat:@"%@",productModal.productid];
            }
        }else {
            if(NSSTRING_HAS_DATA(productModal.name) && NSSTRING_HAS_DATA(productModal.productid)){
                productName = [NSString stringWithFormat:@"%@ - %@/%@",productName,productModal.name, productModal.productid];
            }else if(NSSTRING_HAS_DATA(productModal.name)){
                productName = [NSString stringWithFormat:@"%@ - %@",productName, productModal.name];
            }else if(NSSTRING_HAS_DATA(productModal.productid)){
                productName = [NSString stringWithFormat:@"%@ - %@",productName,productModal.productid];
            }
        }
        
        
    }
    
    return productName;
}

- (IBAction)updateOrderButtonTapped:(id)sender {
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CartUpdate withCategory:@"" label:nil value:nil];
    if([self checkWhetherUpdateRequestNeeded]) {
        
        
        GMCityModal *cityModal = [GMCityModal selectedLocation];
        [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Update Cart" label:@""];
        
        
        NSMutableDictionary *qaGrapEventDic = [self QATrakerParmeters];
        [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_UpdateCart withExtraParameter:qaGrapEventDic];
        
        NSDictionary *requestParam = [[GMCartRequestParam sharedCartRequest] updateDeleteRequestParameterFromCartDetailModal:self.cartDetailModal];
        [self showProgress];
        [[GMOperationalHandler handler] deleteItem:requestParam withSuccessBlock:^(GMCartDetailModal *cartDetailModal) {
            
            [self removeProgress];
            
            if(cartDetailModal.productItemsArray.count > 0) {
                
                self.cartDetailModal = cartDetailModal;
                self.cartModal = [[GMCartModal alloc] initWithCartDetailModal:cartDetailModal];
                [self.cartModal archiveCart];
                [self.tabBarController updateBadgeValueOnCartTab];
                [self.totalView setHidden:NO];
                [self.proceedView setHidden:NO];
                [self.updateOrderButton setHidden:YES];
                [self configureAmountView];
                [self checkIsAnyItemOutOfStock];
                [self couponUIConfiger];
                
            } else {
                [self.totalView setHidden:YES];
                [self.proceedView setHidden:YES];
                [self.updateOrderButton setHidden:YES];
                self.messageString = @"No item in your cart, Please add item.";
                self.billBusterView.hidden = TRUE;
                self.tableTopLayoutConstraint.constant = 64;
                self.billBusterLbl.text = @"";
                [self checkIsAnyItemOutOfStock];
                [self couponUIConfiger];
            }
            [self setTotalCount];
            [self showOrHideItemOutOfStockView];
            [self.cartDetailTableView reloadData];
        } failureBlock:^(NSError *error) {
            
            [self removeProgress];
            [self showOrHideItemOutOfStockView];
            [self couponUIConfiger];
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        }];
        
        if(self.cartDetailModal.productItemsArray.count == 0) {
            
            GMUserModal *userModal = [GMUserModal loggedInUser];
            [userModal setQuoteId:@""];
            [userModal persistUser];
        }
    }
    else {
        
        [self.proceedView setHidden:YES];
        [self.updateOrderButton setHidden:NO];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.Status == %@", @"0"];
        NSArray *filteredArr = [self.cartDetailModal.productItemsArray filteredArrayUsingPredicate:pred];
        if(filteredArr.count) {
            
            NSUInteger index = [self.cartDetailModal.productItemsArray indexOfObject:filteredArr.firstObject];
            [self.cartDetailTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            GMCartCell *cartCell = (GMCartCell *)[self.cartDetailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [UIView animateWithDuration:0.5 animations:^{
                cartCell.promotionLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    cartCell.promotionLabel.transform = CGAffineTransformIdentity;
                } completion:nil];
            }];
        }
    }
}


- (IBAction)updateOrderRemoveButtonTapped:(id)sender {
    [self updateOrderButtonTapped:nil];
    
}
- (IBAction)backButtonTapped:(id)sender {
    
    //    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    [self.tabBarController setSelectedIndex:0];
    //    AppDelegate *appdel = APP_DELEGATE;
    //    [appdel goToHomeWithAnimation:NO];
}

- (BOOL)checkWhetherUpdateRequestNeeded {
    
    BOOL updateStatus = YES;
    
    if(!self.cartDetailModal)
        return NO;
    
    if(self.cartDetailModal.deletedProductItemsArray.count)
        return updateStatus;
    
    for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", productModal.productid];
        NSArray *filteredArr = [self.cartModal.cartItems filteredArrayUsingPredicate:pred];
        GMProductModal *cartProductModal = [filteredArr firstObject];
        if([productModal.productQuantity isEqualToString:cartProductModal.productQuantity]) {
            
            //            [productModal setIsProductUpdated:NO];
            updateStatus = updateStatus && NO;
        }
        else {
            
            //            [productModal setIsProductUpdated:YES];
            updateStatus = YES;
            break;
        }
    }
    
    if(!updateStatus) {
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.Status == %@", @"0"];
        NSArray *filteredArr = [self.cartDetailModal.productItemsArray filteredArrayUsingPredicate:pred];
        if(filteredArr.count) {
            
            NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(GMProductModal *evaluatedObject, NSDictionary *bindings) {
                
                if(evaluatedObject.sale_price.integerValue != 0)
                    return YES;
                else
                    return NO;
            }];
            NSArray *arr = [filteredArr filteredArrayUsingPredicate:pred];
            if(!arr.count)
                return YES;
        }
    }
    
    return updateStatus;
}

- (void)setTotalCount {
    
    int totalItems = 0;
    for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
        
        totalItems += productModal.productQuantity.intValue;
    }
    
    if(totalItems > 0)
        self.totalItemInCartLbl.text = [NSString stringWithFormat:@"%d",totalItems];
    else
        self.totalItemInCartLbl.text = [NSString stringWithFormat:@"0"];
}


-(NSMutableDictionary *)QATrakerParmeters{
    
    GMUserModal *userModal = [[GMSharedClass sharedClass] getLoggedInUser];
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.userId)){
        [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    
    if(NSSTRING_HAS_DATA(self.totalItemInCartLbl.text)){
        [qaGrapEventDic setObject:self.totalItemInCartLbl.text forKey:kEY_QA_EventParmeter_TotalQty];
    }
    if(NSSTRING_HAS_DATA(self.cartDetailModal.subTotal)){
        [qaGrapEventDic setObject:self.cartDetailModal.subTotal forKey:kEY_QA_EventParmeter_Subtotal];
    }
    if(NSSTRING_HAS_DATA(self.cartDetailModal.couponCode)){
        [qaGrapEventDic setObject:self.cartDetailModal.couponCode forKey:kEY_QA_EventParmeter_CouponCode];
    }
    
    if(self.cartDetailModal.productItemsArray.count>0){
        
        NSString *categoryIds = @"";
//
        int i = 0;
        for (GMProductModal *productModal in self.cartDetailModal.productItemsArray) {
            
            if(i==0) {
            categoryIds = [NSString stringWithFormat:@"%@",productModal.productid];
            }else {
                categoryIds = [NSString stringWithFormat:@"%@,%@",categoryIds,productModal.productid];
            }
            
            i++;
            
        }
        [qaGrapEventDic setObject:categoryIds forKey:kEY_QA_EventParmeter_ProductIds];
    }
    
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Profile_ViewOrderHistory withExtraParameter:qaGrapEventDic];
    
    return qaGrapEventDic;
}
@end
