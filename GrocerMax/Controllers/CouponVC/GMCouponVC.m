//
//  GMCouponVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 02/07/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMCouponVC.h"
#import "TPKeyboardAvoidingTableView.h"
#import "GMCouponModal.h"
#import "GMCouponCell.h"
#import "GMCoupanCartDetail.h"

static NSString * const kCouponIdentifier    = @"couponCellIdentifier";

@interface GMCouponVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *couponTableView;
@property (weak, nonatomic) IBOutlet UILabel *applyedCouponCodeLbl;


@property (strong, nonatomic) IBOutlet UIView *tblHeaderView;
@property (weak, nonatomic) IBOutlet UITextField *txt_couponCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_apply;
@property (weak, nonatomic) IBOutlet UILabel *lbl_or;



@property (strong, nonatomic)  NSMutableArray *couponListArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

@end

@implementation GMCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    [self configer];
    [self fetchCouponListFromServer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    self.title = @"Coupons";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configer{
    
    self.couponListArray = [[NSMutableArray alloc]init];
    self.couponTableView.dataSource = self;
    self.couponTableView.delegate = self;
    
    self.couponTableView.tableFooterView = [UIView new];
    
    self.lbl_or.layer.cornerRadius = 15;
    self.lbl_or.layer.masksToBounds = YES;
    
    self.btn_apply.layer.cornerRadius = 3.0;
    self.btn_apply.layer.masksToBounds = YES;

    
    self.couponTableView.tableHeaderView = self.tblHeaderView;
    
    [self refreshTblHeader];
}
- (void)registerCellsForTableView {
    
    [self.couponTableView registerNib:[UINib nibWithNibName:@"GMCouponCell" bundle:nil] forCellReuseIdentifier:kCouponIdentifier];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Server handling Method

- (void)fetchCouponListFromServer {
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *userId = @"";
    if(userModal != nil) {
        userId = userModal.userId;
    }
    
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionary];
    [requestParam setObject:userId forKey:@"user_id"];
    
    [self showProgress];
    
    [[GMOperationalHandler handler] couponcode:requestParam withSuccessBlock:^(id responceData) {
        
        
        self.couponListArray = responceData;
        [self removeProgress];
        [self.couponTableView reloadData];
        
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
        
    }];
    
    
}


#pragma mark - UITableView Delegates/Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.couponListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    GMCouponModal *couponModal = [self.couponListArray objectAtIndex:indexPath.row];

    return [GMCouponCell cellHeightFor:couponModal];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMCouponModal *couponModal = [self.couponListArray objectAtIndex:indexPath.row];
    GMCouponCell *couponCell = [tableView dequeueReusableCellWithIdentifier:kCouponIdentifier];
    [couponCell.couponCodeBtn addTarget:self action:@selector(applyCouponCode:) forControlEvents:UIControlEventTouchUpInside];
    [couponCell.viewTermsAndConditionBtn addTarget:self action:@selector(viewTermsCondition:) forControlEvents:UIControlEventTouchUpInside];
    
    if([[couponModal.couponCode lowercaseString] isEqualToString:[self.applyedCouponCode lowercaseString]]){
        couponModal.isApply = TRUE;
    }else {
        couponModal.isApply = FALSE;
    }
    
    [couponCell configerUI:couponModal];
    return couponCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}

#pragma mark - refresh UI

-(void)refreshTblHeader {
    
    if (self.applyedCouponCode != nil) {
        [self.txt_couponCode setEnabled:NO];
        [self.txt_couponCode setText:self.applyedCouponCode];
        [self.btn_apply setSelected:YES];
        [self.btn_apply setBackgroundColor:[UIColor blackColor]];
        [self.applyedCouponCodeLbl setText:[NSString stringWithFormat:@"Applied Coupon - %@",self.applyedCouponCode]];
        self.topViewHeightConstraint.constant = 50;
    }else {
        [self.txt_couponCode setEnabled:YES];
        [self.txt_couponCode setText:@""];
        [self.btn_apply setSelected:NO];
        [self.btn_apply setBackgroundColor:[UIColor lightGrayColor]];
        [self.applyedCouponCodeLbl setText:@"Applied Coupon"];
        self.topViewHeightConstraint.constant = 0;
    }
}

#pragma mark - IBAction Methods

- (IBAction)applyCancelBtnAction:(UIButton *)sender {
    
    if (sender.selected)// cancel
    {
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        GMUserModal *userModal = [GMUserModal loggedInUser];
        if(NSSTRING_HAS_DATA(userModal.userId)) {
            [userDic setObject:userModal.userId forKey:kEY_userid];
        }
        if(NSSTRING_HAS_DATA(userModal.quoteId)) {
            [userDic setObject:userModal.quoteId forKey:kEY_quote_id];
        }
        if(NSSTRING_HAS_DATA(self.txt_couponCode.text)) {
            [userDic setObject:self.txt_couponCode.text forKey:kEY_couponcode];
        }
        
        [self showProgress];
        [[GMOperationalHandler handler] removeCoupon:userDic  withSuccessBlock:^(NSDictionary *responceData) {
            sender.selected = !sender.selected;
            [self refreshTblHeader];
            if (NSSTRING_HAS_DATA(responceData[@"CartDetails"][@"coupon_code"])) {
                self.applyedCouponCode = responceData[@"CartDetails"][@"coupon_code"];
            }else{
                self.applyedCouponCode = nil;
            }
            [self.couponTableView reloadData];
            [self removeProgress];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is not valid."];
            [self removeProgress];
        }];

    }else {
       
        if(!NSSTRING_HAS_DATA(self.txt_couponCode.text)) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Please enter coupon code."];
            return;
        }
        
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        GMUserModal *userModal = [GMUserModal loggedInUser];
        if(NSSTRING_HAS_DATA(userModal.userId)) {
            [userDic setObject:userModal.userId forKey:kEY_userid];
        }
        if(NSSTRING_HAS_DATA(userModal.quoteId)) {
            [userDic setObject:userModal.quoteId forKey:kEY_quote_id];
        }
        
        [userDic setObject:self.txt_couponCode.text forKey:kEY_couponcode];
        
        [self showProgress];
        [[GMOperationalHandler handler] addCoupon:userDic  withSuccessBlock:^(GMCoupanCartDetail *responceData) {
            
            sender.selected = !sender.selected;
            self.applyedCouponCode = responceData.coupon_code;
            [self.couponTableView reloadData];
            [self removeProgress];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is not valid."];
            [self removeProgress];
        }];
    }
}

- (void)applyCouponCode:(GMButton *)sender {
    
    [self.view endEditing:YES];
    
    if(sender.couponModal.isApply){
        
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        GMUserModal *userModal = [GMUserModal loggedInUser];
        if(NSSTRING_HAS_DATA(userModal.userId)) {
            [userDic setObject:userModal.userId forKey:kEY_userid];
        }
        if(NSSTRING_HAS_DATA(userModal.quoteId)) {
            [userDic setObject:userModal.quoteId forKey:kEY_quote_id];
        }
        if(NSSTRING_HAS_DATA(sender.couponModal.couponCode)) {
            [userDic setObject:sender.couponModal.couponCode forKey:kEY_couponcode];
        }
        
        [self showProgress];
        [[GMOperationalHandler handler] removeCoupon:userDic  withSuccessBlock:^(NSDictionary *responceData) {
            [self removeProgress];
            [self refreshTblHeader];
            self.applyedCouponCode = sender.couponModal.couponCode;
            [self.couponTableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is not valid."];
            [self removeProgress];
        }];
        
    }else {
    
        if(!NSSTRING_HAS_DATA(sender.couponModal.couponCode)) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Please enter coupon code."];
            return;
        }
        
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        GMUserModal *userModal = [GMUserModal loggedInUser];
        if(NSSTRING_HAS_DATA(userModal.userId)) {
            [userDic setObject:userModal.userId forKey:kEY_userid];
        }
        if(NSSTRING_HAS_DATA(userModal.quoteId)) {
            [userDic setObject:userModal.quoteId forKey:kEY_quote_id];
        }
        if(NSSTRING_HAS_DATA(sender.couponModal.couponCode)) {
            [userDic setObject:sender.couponModal.couponCode forKey:kEY_couponcode];
        }
        
        [self showProgress];
        [[GMOperationalHandler handler] addCoupon:userDic  withSuccessBlock:^(GMCoupanCartDetail *responceData) {
            
            [self refreshTblHeader];
            self.applyedCouponCode = sender.couponModal.couponCode;
            [self.couponTableView reloadData];
            [self removeProgress];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is not valid."];
            [self removeProgress];
        }];
    }

}

- (void)viewTermsCondition:(GMButton *)sender {
    
    if(sender.couponModal.isViewTermAndCondition) {
        sender.couponModal.isViewTermAndCondition = FALSE;
    }else {
        sender.couponModal.isViewTermAndCondition = TRUE;
    }
    sender.selected = sender.couponModal.isViewTermAndCondition;
    
    [self.couponTableView reloadData];
    
}


@end
