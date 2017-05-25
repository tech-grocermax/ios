//
//  GMBillingAddressVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMBillingAddressVC.h"
#import "GMAddressCell.h"
#import "GMTAddAddressCell.h"
#import "GMDeliveryDetailVC.h"
#import "GMAddBillingAddressVC.h"
#import "GMStateBaseModal.h"

static NSString *kIdentifierBillingAddressCell = @"BillingAddressIdentifierCell";
static NSString *kIdentifierAddAddressCell = @"AddAddressIdentifierCell";

@interface GMBillingAddressVC () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL isHitOnServer;
}
//@property (strong, nonatomic) NSMutableArray *billingAddressArray;
@property (strong, nonatomic) IBOutlet UITableView *billingAddressTableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *footerBgView;

@property (weak, nonatomic) IBOutlet UIButton *addNewAddressBtn;

@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) GMAddressModalData *selectedAddressModalData;

@end

@implementation GMBillingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    
    self.userModal = [GMUserModal loggedInUser];
    [self registerCellsForTableView];
    self.addNewAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth - 30 - 7 - 7, 0, 0);
    self.footerBgView.layer.borderColor = BORDER_COLOR;
    self.footerBgView.layer.borderWidth = BORDER_WIDTH;
    self.footerBgView.layer.cornerRadius = CORNER_RADIUS;
    [self.billingAddressTableView setTableFooterView:self.footerView];
    self.addNewAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth - 30 - 7 - 7, 0, 0);
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Billing address" label:@""];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(isHitOnServer)
        [self getBillingAddress];
    self.title = @"Billing Address";
    
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_CartBilling_Screen];
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.billingAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierBillingAddressCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods

- (void)selectUnselectBtnClicked:(GMButton *)sender {
    
    GMAddressModalData *addressModalData = sender.addressModal;
    
    self.selectedAddressModalData.isBillingSelected = FALSE;
    
    self.selectedAddressModalData = addressModalData;
    
    if(addressModalData.isBillingSelected) {
        sender.selected = FALSE;
        addressModalData.isBillingSelected = FALSE;
    }
    else {
        sender.selected = TRUE;
        addressModalData.isBillingSelected = TRUE;
    }
    self.checkOutModal.billingAddressModal = addressModalData;
    [self.billingAddressTableView reloadData];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ExistingBillingSelect withCategory:@"" label:addressModalData.street value:nil];
    
}

- (void) editBtnClicked:(GMButton *)sender {
    
    isHitOnServer = TRUE;
    GMAddBillingAddressVC *addShippingAddressVC = [GMAddBillingAddressVC new];
    addShippingAddressVC.editAddressModal = sender.addressModal;
    [self.navigationController pushViewController:addShippingAddressVC animated:YES];
}

- (IBAction)addAddressBtnClicked:(UIButton *)sender {
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_NewBillingSelect withCategory:@"" label:nil value:nil];
    isHitOnServer = TRUE;
    GMAddBillingAddressVC *addShippingAddressVC = [GMAddBillingAddressVC new];
    [self.navigationController pushViewController:addShippingAddressVC animated:YES];
}

- (IBAction)actionProcess:(id)sender {
    
    
    isHitOnServer = FALSE;
    if(self.checkOutModal.billingAddressModal) {
        NSString *userName = @"";
        GMUserModal *userModal = [GMUserModal loggedInUser];
        if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName) && NSSTRING_HAS_DATA(userModal.userId)){
            userName = [NSString stringWithFormat:@"%@/%@",userModal.firstName,userModal.userId];
            
        }else if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName)){
            userName = [NSString stringWithFormat:@"%@",userModal.firstName];
        }else if(userModal != nil && NSSTRING_HAS_DATA(userModal.userId)){
            userName = [NSString stringWithFormat:@"%@",userModal.userId];
        }
        
        
        [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Billing withCategory:kEY_GA_Category_Checkout_Funnel label:userName];
        
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ProceedBilling withCategory:@"" label:nil value:nil];
        GMDeliveryDetailVC *deliveryDetailVC = [GMDeliveryDetailVC new];
        deliveryDetailVC.checkOutModal = self.checkOutModal;
        deliveryDetailVC.timeSlotBaseModal = self.timeSlotBaseModal;
        [self.navigationController pushViewController:deliveryDetailVC animated:YES];
    } else {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please select billing address."];
    }
}

#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.billingAddressArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMAddressCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierBillingAddressCell];
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

#pragma mark Request Methods

- (void)getBillingAddress {
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.userModal.email))
        [dataDic setObject:self.userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(self.userModal.userId))
        [dataDic setObject:self.userModal.userId forKey:kEY_userid];
    [self showProgress];
    [[GMOperationalHandler handler] getAddressWithTimeSlot:dataDic withSuccessBlock:^(GMTimeSlotBaseModal *responceData) {
        isHitOnServer = FALSE;
        self.timeSlotBaseModal = responceData;
        if(responceData.addressesArray.count>0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(GMAddressModalData *evaluatedObject, NSDictionary *bindings) {
                int isBillingValue = evaluatedObject.is_default_billing.intValue;
                
                if(isBillingValue == 1) {
                    return YES;
                }
                else
                    return NO;
            }];
            
            NSArray *arry = [responceData.addressesArray filteredArrayUsingPredicate:predicate];
            if(arry.count>0)
            {
                self.billingAddressArray = (NSMutableArray *)arry;
                self.checkOutModal.billingAddressModal = nil;
                [self.billingAddressTableView reloadData];
            }
        }
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        isHitOnServer = FALSE;
        [self removeProgress];
        
    }];
}


@end
