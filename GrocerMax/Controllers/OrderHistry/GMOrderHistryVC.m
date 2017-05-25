//
//  GMOrderHistryVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderHistryVC.h"
#import "GMOrderHistoryCell.h"
#import "GMBaseOrderHistoryModal.h"
#import "GMOrderDetailVC.h"
#import "GMStateBaseModal.h"
static NSString *kIdentifierOrderHistoryCell = @"orderHistoryIdentifierCell";
@interface GMOrderHistryVC ()
@property (weak, nonatomic) IBOutlet UITableView *orderHistryTableView;
@property (nonatomic, strong) GMUserModal *userModal;
@property (nonatomic, strong) GMOrderHistoryModal *selectedOderHistoryModal;

@end

@implementation GMOrderHistryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userModal = [GMUserModal loggedInUser];
    self.navigationController.navigationBarHidden = NO;
    self.orderHistoryDataArray = [[NSMutableArray alloc]init];
    [self registerCellsForTableView];
    [self getOrderHistryFromServer];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Profile Activity" label:@"Order History"];
    
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init]; if(NSSTRING_HAS_DATA(self.userModal.userId)){
        [qaGrapEventDic setObject:self.userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Profile_ViewOrderHistory withExtraParameter:qaGrapEventDic];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Order History";
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_OrderHistory_Screen];
}

#pragma mark - WebService Handler
- (void)getOrderHistryFromServer
{
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.userModal.email))
        [userDic setObject:self.userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(self.userModal.userId))
        [userDic setObject:self.userModal.userId forKey:kEY_userid];
    
    [self showProgress];
    
    //2015-07-24 10:26:58
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [[GMOperationalHandler handler] orderHistory:userDic withSuccessBlock:^(NSArray *responceData) {
        [self.orderHistoryDataArray addObjectsFromArray:responceData];
        
        self.orderHistoryDataArray = [[self.orderHistoryDataArray sortedArrayUsingComparator:^NSComparisonResult(GMOrderHistoryModal* obj1, GMOrderHistoryModal *obj2) {
            
            NSDate *date1 = [dateFormatter dateFromString:obj1.orderDate];
            NSDate *date2 = [dateFormatter dateFromString:obj2.orderDate];
            
            
            
            return [date1 compare:date2] == NSOrderedAscending;
            
        }] mutableCopy];
        [self removeProgress];
        [self.orderHistryTableView reloadData];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        [self removeProgress];
        
    }];
}

#pragma mark - Register Cell

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMOrderHistoryCell" bundle:[NSBundle mainBundle]];
    [self.orderHistryTableView registerNib:nib forCellReuseIdentifier:kIdentifierOrderHistoryCell];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
        return self.orderHistoryDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMOrderHistoryCell *orderHistoryCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierOrderHistoryCell];
    orderHistoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    orderHistoryCell.tag = indexPath.row;
    GMOrderHistoryModal *orderHistoryModal  = [self.orderHistoryDataArray objectAtIndex:indexPath.row];
    [orderHistoryCell.reorderBtn addTarget:self action:@selector(reorderButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [orderHistoryCell configerViewWithData:orderHistoryModal];
    
    return orderHistoryCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [GMOrderHistoryCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMOrderHistoryModal *orderHistoryModal  = [self.orderHistoryDataArray objectAtIndex:indexPath.row];
    
    GMOrderDetailVC *orderDetailVC = [GMOrderDetailVC new];
    orderDetailVC.orderHistoryModal = orderHistoryModal;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    //use for detail;
    
}

-(void)reorderButtonTapped:(GMButton *)sender {
    
    self.selectedOderHistoryModal = sender.orderHistoryModal;
    
    
    if(NSSTRING_HAS_DATA(self.userModal.quoteId)) {
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:@"Existing items in the cart will be removed." preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self reorder];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [alertController addAction:actionCancel];
        [alertController addAction:actionContinue];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self reorder];
    }
    
}

-(void)reorder {
//    NSLog(@"oderHistoryModal.orderId = %@",self.selectedOderHistoryModal.incrimentId);
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Profile Activity" label:@"Reorder"];
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc]init];
    
    if(NSSTRING_HAS_DATA(self.selectedOderHistoryModal.incrimentId)) {
        [dicData setValue:self.selectedOderHistoryModal.incrimentId forKey:kEY_orderid];
        [dicData setValue:self.selectedOderHistoryModal.incrimentId forKey:@"orderId"];
    }
    if(NSSTRING_HAS_DATA(self.userModal.userId)) {
        [dicData setValue:self.userModal.userId forKey:kEY_userid];
        [dicData setObject:self.userModal.userId forKey:@"CustId"];
    }
    
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.userModal.userId)){
        [qaGrapEventDic setObject:self.userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    if(NSSTRING_HAS_DATA(self.selectedOderHistoryModal.totalItem)){
        [qaGrapEventDic setObject:self.selectedOderHistoryModal.totalItem forKey:kEY_QA_EventParmeter_TotalQty];
    }
    if(NSSTRING_HAS_DATA(self.selectedOderHistoryModal.paidAmount)){
        [qaGrapEventDic setObject:self.selectedOderHistoryModal.paidAmount forKey:kEY_QA_EventParmeter_Subtotal];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Profile_Reorder withExtraParameter:qaGrapEventDic];
    
    [self showProgress];
    [[GMOperationalHandler handler] reorderItem:dicData withSuccessBlock:^(id responceData) {
        [self removeProgress];
        if([responceData isKindOfClass:[NSDictionary class]]) {
            
            NSString *quoteId;
            if(HAS_KEY(responceData, @"QuoteId")) {
                [[GMSharedClass sharedClass] clearCart];
                quoteId = responceData[@"QuoteId"];
                GMUserModal *userModal = [GMUserModal loggedInUser];
                
                if(userModal) {
                    [userModal setQuoteId:quoteId];
                    [userModal persistUser];
                }
                
               
                
                [self.tabBarController setSelectedIndex:4];
            }
        }
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:@"Problem to reorder your order, Try again!"];
    }];

}


@end
