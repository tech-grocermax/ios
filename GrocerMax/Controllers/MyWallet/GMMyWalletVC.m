//
//  GMMyWalletVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 06/12/15.
//  Copyright © 2015 Deepak Soni. All rights reserved.
//

#import "GMMyWalletVC.h"
#import "MGSocialMedia.h"
#import "GMWalletHistoryVC.h"

@interface GMMyWalletVC ()
@property (weak, nonatomic) IBOutlet UILabel *walletBalenceLbl;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *transactionBtn;

@end

@implementation GMMyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.topView setBackgroundColor:[UIColor colorFromHexString:@"#EE2D09"]];
    self.shareBtn.layer.borderWidth = BORDER_WIDTH;
    self.shareBtn.layer.cornerRadius = CORNER_RADIUS;
    [self.shareBtn setClipsToBounds:YES];
    
    
//    self.transactionBtn.layer.borderWidth = BORDER_WIDTH;
    self.transactionBtn.layer.cornerRadius = 10.0;
    [self.transactionBtn setClipsToBounds:YES];
    
    [self.shareBtn setBackgroundColor:[UIColor colorFromHexString:@"#EE2D09"]];
    self.shareBtn.layer.borderColor = [UIColor colorFromHexString:@"#EE2D09"].CGColor;
    [self getWalletDataFromServer];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init]; if(NSSTRING_HAS_DATA(userModal.userId)){
        [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Profile_ViewRefundBalance withExtraParameter:qaGrapEventDic];
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Refund Wallet";
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Wallet_Screen];
//    [self configrationUI];
    [self updateUI];
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

-(void)getWalletDataFromServer {
    [self showProgress];
    
    //staging.grocermax.com/api/getwalletbalance?CustId=
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.email))
        [userDic setObject:userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [userDic setObject:userModal.userId forKey:kEY_userid];
        [userDic setObject:userModal.userId forKey:@"CustId"];
    }
    
    [[GMOperationalHandler handler] getUserWalletItem:userDic withSuccessBlock:^(id responceData) {
        [self removeProgress];
        if(HAS_KEY(responceData, @"Balance")) {
            userModal.balenceInWallet = [NSString stringWithFormat:@"%@",[responceData objectForKey:@"Balance"]];
        } else {
            userModal.balenceInWallet = @"0.0";
        }
        [userModal persistUser];
        [self updateUI];
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}
-(void) configrationUI {
    
    UIImage *image = [UIImage imageNamed:@"walletIcone"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.navigationController.navigationBar.topItem setTitleView:imageView];
    [self.navigationController.navigationBar.topItem setTitle:@"Refund Balance"];
}
- (IBAction)shareButtonPressed:(id)sender {
    
    MGSocialMedia *socalMedia = [MGSocialMedia sharedSocialMedia];
    [socalMedia showActivityView:@"Hey, Checkout this product!!!"];
}

-(void)updateUI {
    GMUserModal *userModal = [GMUserModal loggedInUser];
    float balence = 0.00;
    if(NSSTRING_HAS_DATA(userModal.balenceInWallet)) {
        balence = [userModal.balenceInWallet floatValue];
    }
    NSString *balenceStr = [NSString stringWithFormat:@"₹%.2f",balence];
//    self.walletBalenceLbl.text = [NSString stringWithFormat:@"₹%.2f",balence];// @"₹";
    
    NSMutableAttributedString *balenceAttString = [[NSMutableAttributedString alloc] initWithString:balenceStr];
    [balenceAttString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]} range:[balenceStr rangeOfString:@"₹"]];
    self.walletBalenceLbl.attributedText = balenceAttString;
}
- (IBAction)actionTransactionButtonPressed:(id)sender {
    
    GMWalletHistoryVC *walletHistoryVC = [GMWalletHistoryVC new];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    float balence = 0.00;
    if(NSSTRING_HAS_DATA(userModal.balenceInWallet)) {
        balence = [userModal.balenceInWallet floatValue];
    }
    NSString *balenceStr = [NSString stringWithFormat:@"%.2f",balence];
    walletHistoryVC.walletTotalPrice = balenceStr;
    [self.navigationController pushViewController:walletHistoryVC animated:YES];
}

@end
