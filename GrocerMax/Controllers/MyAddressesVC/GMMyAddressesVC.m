//
//  GMMyAddressesVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMMyAddressesVC.h"
#import "GMAddressCell.h"
#import "GMTAddAddressCell.h"
#import "GMAddShippingAddressVC.h"
#import "GMStateBaseModal.h"

static NSString *kIdentifierMyAddressCell = @"MyAddressIdentifierCell";

@interface GMMyAddressesVC ()

@property (weak, nonatomic) IBOutlet UITableView *myAddressTableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *addNewAddressBtn;

@property (weak, nonatomic) IBOutlet UIView *addNewAddressView;

@property (strong, nonatomic) NSMutableArray *addressArray;

@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) GMAddShippingAddressVC *addressShippingVC;
@end

@implementation GMMyAddressesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self getMyAddress];
    [self registerCellsForTableView];
    [self.myAddressTableView setTableFooterView:self.footerView];
    self.addNewAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, kScreenWidth - 30 - 7 - 7, 0, 0);
    
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.userModal.userId)){
        [qaGrapEventDic setObject:self.userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Profile_ViewAddresses withExtraParameter:qaGrapEventDic];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMAddressCell" bundle:[NSBundle mainBundle]];
    [self.myAddressTableView registerNib:nib forCellReuseIdentifier:kIdentifierMyAddressCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"My Addresses";
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    [self getMyAddress];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_MyAddress_Screen];
}

#pragma mark - GETTER/SETTER Methods

- (GMUserModal *)userModal {
    
    if(!_userModal) _userModal = [GMUserModal loggedInUser];
    return _userModal;
}

- (GMAddShippingAddressVC *)addressShippingVC {
    
    if(!_addressShippingVC) {
        
        _addressShippingVC = [[GMAddShippingAddressVC alloc] initWithNibName:@"GMAddShippingAddressVC" bundle:nil];
        [_addressShippingVC.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    }
    return _addressShippingVC;
}

- (void)setAddNewAddressView:(UIView *)addNewAddressView {
    
    _addNewAddressView = addNewAddressView;
    _addNewAddressView.layer.cornerRadius = 5.0;
    _addNewAddressView.layer.masksToBounds = YES;
    _addNewAddressView.layer.borderWidth = 0.8;
    _addNewAddressView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
}

#pragma mark - Request Methods

- (void)getMyAddress {
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    GMCityModal *cityModal =[GMCityModal selectedLocation];
    if(cityModal == nil) {
        [userDic setObject:@"1" forKey:kEY_cityId];
    } else {
        if(NSSTRING_HAS_DATA(cityModal.cityId))  {
            [userDic setObject:cityModal.cityId forKey:kEY_cityId];
        } else {
            [userDic setObject:@"1" forKey:kEY_cityId];
        }
        
    }
    if(NSSTRING_HAS_DATA(self.userModal.userId))
    [userDic setObject:self.userModal.userId forKey:kEY_userid];
    
    [self showProgress];
    [[GMOperationalHandler handler] getAddress:userDic  withSuccessBlock:^(GMAddressModal *responceData) {
        
        [self removeProgress];
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
        
        NSArray *shippingAddressArray = [responceData.addressArray filteredArrayUsingPredicate:predicate];
        self.addressArray = (NSMutableArray *)shippingAddressArray;
        for (GMAddressModalData *addressModal in self.addressArray) {
            [addressModal updateHouseNoLocalityAndLandmarkWithStreet:addressModal.street];
        }
        if(!self.addressArray.count) {
            
//            [self addNewAddressButtonTapped:nil];
//            self.title = @"Shipping Address";
//            [self.view addSubview:self.addressShippingVC.view];
//            return;
        }
        [self.myAddressTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        [self removeProgress];
    }];
}


#pragma mark - TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.addressArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMAddressCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierMyAddressCell];
    
    GMAddressModalData *addressModalData = [self.addressArray objectAtIndex:indexPath.row];
    addressCell.tag = indexPath.row;
    [addressCell configerViewWithData:addressModalData];
    [addressCell.selectUnSelectBtn setHidden:YES];
    [addressCell.editAddressBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return addressCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Button Action Methods

- (void) editBtnClicked:(GMButton *)sender {
    
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Profile Activity" label:@"Edit Address"];
    
    GMAddressModalData *addressModalData = sender.addressModal;
    GMAddShippingAddressVC *shippingAddressVC = [[GMAddShippingAddressVC alloc] initWithNibName:@"GMAddShippingAddressVC" bundle:nil];
    shippingAddressVC.editAddressModal = addressModalData;
    [self.navigationController pushViewController:shippingAddressVC animated:YES];
}

- (IBAction)addNewAddressButtonTapped:(id)sender {
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Profile Activity" label:@"Create Address"];
    
    GMAddShippingAddressVC *shippingAddressVC = [[GMAddShippingAddressVC alloc] initWithNibName:@"GMAddShippingAddressVC" bundle:nil];
    [self.navigationController pushViewController:shippingAddressVC animated:YES];
}


@end
