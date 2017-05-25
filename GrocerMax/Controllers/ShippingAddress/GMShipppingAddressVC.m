//
//  GMShipppingAddressVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMShipppingAddressVC.h"

#import "GMAddressCell.h"
#import "GMTAddAddressCell.h"
#import "GMBillingAddressVC.h"
#import "GMDeliveryDetailVC.h"
#import "GMAddShippingAddressVC.h"
#import "GMStateBaseModal.h"
#import "GMOrderDetailHeaderView.h"
#import "GMAddressFooterView.h"
#import "GMAddBillingAddressVC.h"

static NSString *kIdentifierShippingAddressCell = @"ShippingAddressIdentifierCell";
static NSString *kIdentifierAddAddressCell = @"AddAddressIdentifierCell";
static NSString *kIdentifierShippingHeader = @"shippingIdentifierHeader";
static NSString *kIdentifierAddressFooterView = @"AddressFooterIdentifier";




@interface GMShipppingAddressVC () <AddAShippingddressDelegate>
{
    BOOL isHitOnServer;
}

@property (weak, nonatomic) IBOutlet UITableView *shippingAddressTableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *footerBgView;

@property (weak, nonatomic) IBOutlet UIButton *addNewAddressBtn;

@property (weak, nonatomic) IBOutlet UIView *addAddressView;

@property (strong, nonatomic) NSMutableArray *addressArray;

@property (strong, nonatomic) NSMutableArray *billingAddressArray;

@property (weak, nonatomic) IBOutlet UIView *lastAddressView;

@property (weak, nonatomic) IBOutlet UIButton *shippingAsBillingBtn;

@property (nonatomic, strong) GMAddressModalData *selectedAddressModalData;

@property (nonatomic, strong) GMTimeSlotBaseModal *timeSlotBaseModal;

@property (nonatomic, strong) GMAddShippingAddressVC *addAddressVC;

@property (weak, nonatomic) IBOutlet UILabel *youShavedLbl;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;



@end

@implementation GMShipppingAddressVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self getShippingAddress];
    [self registerCellsForTableView];
//    [self.shippingAddressTableView setTableFooterView:self.footerView];
    self.addNewAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth - 30 - 7 - 7, 0, 0);
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Shipping address" label:@""];
    [self actionShippingAsBilling:nil];
    [self configureAmountView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
//    self.title = @"Shipping Address";
    self.title = @"Delivery Address";
    
    if(isHitOnServer)
        [self getShippingAddress];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Shipping_Screen];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.shippingAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierShippingAddressCell];
    
    nib = [UINib nibWithNibName:@"GMOrderDetailHeaderView" bundle:[NSBundle mainBundle]];
    [self.shippingAddressTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierShippingHeader];
    
    nib = [UINib nibWithNibName:@"GMAddressFooterView" bundle:[NSBundle mainBundle]];
    [self.shippingAddressTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierAddressFooterView];
    
    
}

#pragma mark - GETTER/SETTER Methods

- (void)setLastAddressView:(UIView *)lastAddressView {
    
    _lastAddressView = lastAddressView;
    _lastAddressView.layer.borderColor = BORDER_COLOR;
    _lastAddressView.layer.borderWidth = BORDER_WIDTH;
    _lastAddressView.layer.cornerRadius = CORNER_RADIUS;
    
}

- (void)setFooterBgView:(UIView *)footerBgView {
    
    _footerBgView = footerBgView;
    _footerBgView.layer.borderColor = BORDER_COLOR;
    _footerBgView.layer.borderWidth = BORDER_WIDTH;
    _footerBgView.layer.cornerRadius = CORNER_RADIUS;
}
#pragma mark - IBAction Methods

- (void)selectUnselectBtnClicked:(GMButton *)sender {
    
    CGPoint pointInTable = [sender convertPoint:sender.bounds.origin toView:self.shippingAddressTableView];
    NSIndexPath *indexPath = [self.shippingAddressTableView indexPathForRowAtPoint:pointInTable];
    
    if(indexPath.section == 0) {
        GMAddressModalData *addressModalData = sender.addressModal;
        
        self.selectedAddressModalData.isShippingSelected = FALSE;
        if(addressModalData.isShippingSelected) {
            sender.selected = FALSE;
            addressModalData.isShippingSelected = FALSE;
        }
        else {
            sender.selected = TRUE;
            addressModalData.isShippingSelected = TRUE;
        }
        
        self.checkOutModal.shippingAddressModal = [addressModalData copy];
        self.selectedAddressModalData = addressModalData;
        [self.shippingAddressTableView reloadData];
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ExistingShippingSelect withCategory:@"" label:addressModalData.street value:nil];
    }else {
        
        GMAddressModalData *addressModalData = sender.addressModal;
        
        self.selectedAddressModalData.isBillingSelected = FALSE;
        
//        self.selectedAddressModalData = addressModalData;
        
        if(addressModalData.isBillingSelected) {
            sender.selected = FALSE;
            addressModalData.isBillingSelected = FALSE;
            self.checkOutModal.billingAddressModal = nil;
        }
        else {
            sender.selected = TRUE;
            addressModalData.isBillingSelected = TRUE;
            self.checkOutModal.billingAddressModal = addressModalData;
        }
        
        [self.shippingAddressTableView reloadData];
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ExistingBillingSelect withCategory:@"" label:addressModalData.street value:nil];
        
    }
}

- (void)editBtnClicked:(GMButton *)sender {
    
    
    CGPoint pointInTable = [sender convertPoint:sender.bounds.origin toView:self.shippingAddressTableView];
    NSIndexPath *indexPath = [self.shippingAddressTableView indexPathForRowAtPoint:pointInTable];
    if(indexPath.section == 0) {
    
        GMAddShippingAddressVC *addShippingAddressVC = [GMAddShippingAddressVC new];
        addShippingAddressVC.editAddressModal = sender.addressModal;
        addShippingAddressVC.newAddressHandler = ^(GMAddressModalData *addressModal, BOOL edited) {
            
            [self getShippingAddress];
        };
        [self.navigationController pushViewController:addShippingAddressVC animated:YES];
    }else {
        isHitOnServer = TRUE;
        GMAddBillingAddressVC *addShippingAddressVC = [GMAddBillingAddressVC new];
        addShippingAddressVC.editAddressModal = sender.addressModal;
        [self.navigationController pushViewController:addShippingAddressVC animated:YES];
    }
}

- (IBAction)addAddressBtnClicked:(UIButton *)sender {
    
    if(sender.tag == 0){
    
        GMAddShippingAddressVC *addShippingAddressVC = [GMAddShippingAddressVC new];
        if(sender == nil) {
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_NewShippingSelect withCategory:@"" label:nil value:nil];
            addShippingAddressVC.isComeFromShipping = TRUE;
            [self.navigationController pushViewController:addShippingAddressVC animated:NO];
        } else {
            
            addShippingAddressVC.newAddressHandler = ^(GMAddressModalData *addressModal, BOOL edited) {
                
                [self getShippingAddress];
            };
            [self.navigationController pushViewController:addShippingAddressVC animated:YES];
        }
    }else if(sender.tag == 1){
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_NewBillingSelect withCategory:@"" label:nil value:nil];
        isHitOnServer = TRUE;
        GMAddBillingAddressVC *addShippingAddressVC = [GMAddBillingAddressVC new];
        [self.navigationController pushViewController:addShippingAddressVC animated:YES];
    }
}

- (IBAction)actionProcess:(id)sender {
    
    isHitOnServer = FALSE;
    
    if(self.checkOutModal.shippingAddressModal) {
        
        NSString *userName = @"";
        GMUserModal *userModal = [GMUserModal loggedInUser];
        if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName) && NSSTRING_HAS_DATA(userModal.userId)){
            userName = [NSString stringWithFormat:@"%@/%@",userModal.firstName,userModal.userId];
            
        }else if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName)){
            userName = [NSString stringWithFormat:@"%@",userModal.firstName];
        }else if(userModal != nil && NSSTRING_HAS_DATA(userModal.userId)){
            userName = [NSString stringWithFormat:@"%@",userModal.userId];
        }
        
        
        [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Shipping withCategory:kEY_GA_Category_Checkout_Funnel label:userName];
        
        if(self.shippingAsBillingBtn.selected || self.checkOutModal.billingAddressModal!= nil) {
            
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ProceedShippingBilling withCategory:@"" label:nil value:nil];
            GMDeliveryDetailVC *deliveryDetailVC = [GMDeliveryDetailVC new];
            if(self.shippingAsBillingBtn.selected){
                self.checkOutModal.billingAddressModal = [self.selectedAddressModalData copy];
            }
            deliveryDetailVC.checkOutModal = self.checkOutModal;
            deliveryDetailVC.timeSlotBaseModal = self.timeSlotBaseModal;
            
            NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
            if(NSSTRING_HAS_DATA(userModal.userId)){
                [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
            }
            [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_CheckOutShipping withExtraParameter:qaGrapEventDic];
            
            [self.navigationController pushViewController:deliveryDetailVC animated:YES];
            
            return ;
        }else  {
            [[GMSharedClass sharedClass] showErrorMessage:@"Please select billing address."];
            return;
        }
        
        GMBillingAddressVC *billingAddressVC = [GMBillingAddressVC new];
        billingAddressVC.checkOutModal = self.checkOutModal;
        billingAddressVC.timeSlotBaseModal = self.timeSlotBaseModal;
        
        if(self.timeSlotBaseModal.addressesArray.count>0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(GMAddressModalData *evaluatedObject, NSDictionary *bindings) {
                
                int isBillingValue = evaluatedObject.is_default_billing.intValue;
                
                if(isBillingValue == 1) {
                    return YES;
                }
                else
                    return NO;
            }];
            
            NSArray *arry = [self.timeSlotBaseModal.addressesArray filteredArrayUsingPredicate:predicate];
            if(arry.count>0)
            {
                NSMutableArray *billingAddressArray = [[NSMutableArray alloc]init];
                [billingAddressArray addObjectsFromArray:arry];
                billingAddressVC.billingAddressArray = billingAddressArray;
            }
        }
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ProceedShipping withCategory:@"" label:nil value:nil];
        [self.navigationController pushViewController:billingAddressVC animated:YES];
    } else {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please select shipping address."];
    }
    
}

- (IBAction)actionShippingAsBilling:(UIButton *)sender {
    
    if(self.shippingAsBillingBtn.selected) {
        self.shippingAsBillingBtn.selected = FALSE;
        for(int i= 0; i<self.billingAddressArray.count; i++){
            GMAddressModalData *addressModalData = [self.billingAddressArray objectAtIndex:i];
            addressModalData.isBillingSelected = FALSE;
        }
    }
    else {
        self.shippingAsBillingBtn.selected = TRUE;
    }
    self.checkOutModal.billingAddressModal = nil;
    
     [self.shippingAddressTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    
    
    
    [self.shippingAddressTableView reloadData];
}


- (void)configureAmountView {
    
    if(self.checkOutModal.cartDetailModal.shippingAmount.doubleValue <= 0) {
        [self.totalPriceLbl setText:[NSString stringWithFormat:@""]];
    }else{
        [self.totalPriceLbl setText:[NSString stringWithFormat:@"Shipping: ₹%.2f\n", self.self.checkOutModal.cartDetailModal.shippingAmount.doubleValue]];
    }
    [self.totalPriceLbl setText:[NSString stringWithFormat:@"%@Total: ₹%.2f", self.totalPriceLbl.text,self.checkOutModal.cartDetailModal.grandTotal.doubleValue]];
    
    double savingAmount = [self getSavedAmount];
    [self.youShavedLbl setText:[NSString stringWithFormat:@"₹%.2f", savingAmount]];
    
}

- (double)getSavedAmount {
    
    double saving = 0;
    for (GMProductModal *productModal in self.checkOutModal.cartDetailModal.productItemsArray) {
        
        saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
    }
    if(NSSTRING_HAS_DATA(self.checkOutModal.cartDetailModal.discountAmount))
        saving = saving - self.checkOutModal.cartDetailModal.discountAmount.doubleValue;
    return saving;
}

#pragma mark - TableView DataSource and Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.shippingAsBillingBtn.selected){
        return 1;
    }else {
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        return [self.addressArray count];
    }else if(section == 1){
        return [self.billingAddressArray count];
    }else {
        return 0;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 7.0)];
//    [headerView setBackgroundColor:[UIColor grayBackgroundColor]];
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierShippingAddressCell];
        
        GMAddressModalData *addressModalData = [self.addressArray objectAtIndex:indexPath.row];
        [addressCell configerViewWithData:addressModalData];
        if(addressModalData.isShippingSelected)
            addressCell.selectUnSelectBtn.selected = YES;
        else
            addressCell.selectUnSelectBtn.selected = NO;
        [addressCell.selectUnSelectBtn addTarget:self action:@selector(selectUnselectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [addressCell.editAddressBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return addressCell;
    }else{
        
        GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierShippingAddressCell];
        GMAddressModalData *addressModalData = [self.billingAddressArray objectAtIndex:indexPath.row];
        [addressCell configerViewWithData:addressModalData];
        if(addressModalData.isBillingSelected)
            addressCell.selectUnSelectBtn.selected = YES;
        else
            addressCell.selectUnSelectBtn.selected = NO;
        [addressCell.selectUnSelectBtn addTarget:self action:@selector(selectUnselectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [addressCell.editAddressBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return addressCell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMAddressCell cellHeight];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 0.1f;
    } else if(section == 1) {
        return 42.0f;
    } else  {
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 1) {
        UIView *headerView;
        GMOrderDetailHeaderView *header  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierShippingHeader];
        if (!header) {
            header = [[GMOrderDetailHeaderView alloc] initWithReuseIdentifier:kIdentifierShippingHeader];
        }
        [header.headerBgView setBackgroundColor:[UIColor clearColor]];
        [header congigerHeaderData:@"BILLING ADDRESS"];
        header.headerTitleLbl.font = FONT_MEDIUM(14);
        
        headerView = header;
        
        return headerView;
    }
    else {
        
        return nil;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
//    if(section == 1) {
//        UIView *headerView;
        GMAddressFooterView *footer  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierAddressFooterView];
        if (!footer) {
            footer = [[GMAddressFooterView alloc] initWithReuseIdentifier:kIdentifierAddressFooterView];
        }
    footer.addNewAddressBtn.tag = section;
    
    [footer.addNewAddressBtn addTarget:self action:@selector(addAddressBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //        [header.headerBgView setBackgroundColor:[UIColor clearColor]];
//        [header congigerHeaderData:@"BILLING ADDRESS"];
//        header.headerTitleLbl.font = FONT_MEDIUM(14);
        
//        headerView = header;
        
        return footer;
//    }
//    else {
//        
//        return nil;
//    }
    
//    nib = [UINib nibWithNibName:@"GMAddressFooterView" bundle:[NSBundle mainBundle]];
//    [self.shippingAddressTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierAddressFooterView];
    
}
#pragma mark Request Methods

- (void)getShippingAddress {
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.email))
        [dataDic setObject:userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(userModal.userId))
        [dataDic setObject:userModal.userId forKey:kEY_userid];
    [self showProgress];
    isHitOnServer = FALSE;
    [[GMOperationalHandler handler] getAddressWithTimeSlot:dataDic withSuccessBlock:^(GMTimeSlotBaseModal *responceData) {
        self.timeSlotBaseModal = responceData;
        if(responceData.addressesArray.count > 0) {
            
            GMCityModal *cityModal = [GMCityModal  selectedLocation];
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(GMAddressModalData *evaluatedObject, NSDictionary *bindings) {
                
                int isShippingValue = evaluatedObject.is_default_shipping.intValue;
                int isBillingValue = evaluatedObject.is_default_billing.intValue;
                
                if(((isShippingValue == 1) || ((isShippingValue == 0) && (isBillingValue == 0))) && [cityModal.cityName caseInsensitiveCompare:evaluatedObject.city] == NSOrderedSame  && [cityModal.stateName caseInsensitiveCompare:evaluatedObject.region] == NSOrderedSame) {
                    return YES;
                }
                else
                    return NO;
            }];
            
            NSArray *shippingAddressArray = [responceData.addressesArray filteredArrayUsingPredicate:predicate];
            if(shippingAddressArray.count > 0) {
                
                self.addressArray = [NSMutableArray arrayWithArray:shippingAddressArray];
                [self.shippingAddressTableView reloadData];
            } else
                [self addSubviewAddressView];
        
        
            
            
            
            
            
            NSPredicate *billingPredicate = [NSPredicate predicateWithBlock:^BOOL(GMAddressModalData *evaluatedObject, NSDictionary *bindings) {
                int isBillingValue = evaluatedObject.is_default_billing.intValue;
                
                if(isBillingValue == 1) {
                    return YES;
                }
                else
                    return NO;
            }];
            
            NSArray *arry = [responceData.addressesArray filteredArrayUsingPredicate:billingPredicate];
            if(arry.count>0)
            {
                self.billingAddressArray = (NSMutableArray *)arry;
                self.checkOutModal.billingAddressModal = nil;
                [self.shippingAddressTableView reloadData];
//                [self.billingAddressTableView reloadData];
            }

            
            
            
        
        } else {
            [self addSubviewAddressView];
        }
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        [self removeProgress];
        
    }];
}

- (void)addSubviewAddressView {
    
    self.addAddressVC = [GMAddShippingAddressVC new];
    self.addAddressVC.isComeFromShipping = TRUE;
    self.addAddressVC.delegate = self;
    self.addAddressVC.view.frame = self.addAddressView.bounds;
    [self.addAddressView addSubview:self.addAddressVC.view];
    self.addAddressView.hidden = FALSE;
}

#pragma mark - AddShippingVC Delegate method

- (void)removeFromSupperView {
    
    [self.addAddressVC.view removeFromSuperview];
    self.addAddressVC = nil;
    self.addAddressView.hidden = TRUE;
    [self getShippingAddress];
}
@end
