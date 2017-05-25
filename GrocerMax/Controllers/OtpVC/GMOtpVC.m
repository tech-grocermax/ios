//
//  GMOtpVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOtpVC.h"
#import "GMRegistrationResponseModal.h"
#import "GMProfileVC.h"

@interface GMOtpVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *otpBgView;

@property (weak, nonatomic) IBOutlet UITextField *oneTimePasswordTF;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@end

@implementation GMOtpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *mobileNumber = @"+918800141374";
    
    if(self.userModal.mobile) {
        mobileNumber = self.userModal.mobile;
    }
    
    NSString *title = [NSString stringWithFormat:@"Please enter the one time password (OTP) send to %@",mobileNumber];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    
    [titleString addAttributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor]} range:[title rangeOfString:mobileNumber]];
    
    [titleString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]} range:[title rangeOfString:mobileNumber]];
    
    self.titleLbl.attributedText = titleString;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"One Time Password";
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_OTP_Screen];
}

#pragma mark - GETTER/SETTER Methods

//- (void)setOtpBgView:(UIView *)otpBgView {
//    
//    _otpBgView = otpBgView;
//    [_otpBgView.layer setCornerRadius:5.0];
//    [_otpBgView.layer setBorderWidth:1.0];
//    [_otpBgView.layer setBorderColor:[UIColor inputTextFieldColor].CGColor];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
#pragma mark - IBAction Methods

- (IBAction)resendButtonTapped:(id)sender{
    [self.view endEditing:YES];
    if(self.isEditProfile){
        
        
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        if(NSSTRING_HAS_DATA(self.userModal.firstName))
            [userDic setObject:self.userModal.firstName forKey:kEY_fname];
        if(NSSTRING_HAS_DATA(self.userModal.lastName))
            [userDic setObject:self.userModal.lastName forKey:kEY_lname];
        if(NSSTRING_HAS_DATA(self.userModal.email))
            [userDic setObject:self.userModal.email forKey:kEY_uemail];
        if(NSSTRING_HAS_DATA(self.userModal.mobile))
            [userDic setObject:self.userModal.mobile forKey:kEY_number];
        if(NSSTRING_HAS_DATA(self.userModal.userId))
            [userDic setObject:self.userModal.userId forKey:kEY_userid];
        [userDic setObject:@"0" forKey:kEY_otp];
        
        [self showProgress];
        [[GMOperationalHandler handler] editProfile:userDic   withSuccessBlock:^(GMRegistrationResponseModal *registrationResponse) {
            
            if([registrationResponse.flag isEqualToString:@"2"]) {
                
                if (registrationResponse.otp) {
                    NSString *optString = [NSString stringWithFormat:@"%@", registrationResponse.otp];
                    
                    if(NSSTRING_HAS_DATA(optString)) {
                        [self.userModal setOtp:optString];
                    }
                }
            }
            else
                [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
            
            [self removeProgress];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
            [self removeProgress];
        }];

        
        
        
    } else {
            [self.view endEditing:YES];
            NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
            if(NSSTRING_HAS_DATA(self.userModal.firstName))
                [userDic setObject:self.userModal.firstName forKey:kEY_fname];
            if(NSSTRING_HAS_DATA(self.userModal.lastName))
                [userDic setObject:self.userModal.lastName forKey:kEY_lname];
            else {
                [userDic setObject:@"" forKey:kEY_lname];
            }
            if(NSSTRING_HAS_DATA(self.userModal.email))
                [userDic setObject:self.userModal.email forKey:kEY_uemail];
            if(NSSTRING_HAS_DATA(self.userModal.mobile))
                [userDic setObject:self.userModal.mobile forKey:kEY_number];
            if(NSSTRING_HAS_DATA(self.userModal.password))
                [userDic setObject:self.userModal.password forKey:kEY_password];
            [userDic setObject:@"0" forKey:kEY_otp];
            [self showProgress];
            [[GMOperationalHandler handler] createUser:userDic withSuccessBlock:^(GMRegistrationResponseModal *registrationResponse) {
                
                if([registrationResponse.flag isEqualToString:@"1"]) {
                    
                    if (registrationResponse.otp) {
                        NSString *optString = [NSString stringWithFormat:@"%@", registrationResponse.otp];
                        
                        if(NSSTRING_HAS_DATA(optString)) {
                            [self.userModal setOtp:optString];
                        }
                    }
                }
                else
                    [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
                
                [self removeProgress];
                
            } failureBlock:^(NSError *error) {
                [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
                [self removeProgress];
            }];
        
    }
}

- (IBAction)submitButtonTapped:(id)sender {
    
    [self.view endEditing:YES];
    if(self.oneTimePasswordTF.text.length == 0) {
        
        [[GMSharedClass sharedClass] showErrorMessage:@"Please enter OTP."];
        return;
        
    }
    if(self.isEditProfile){
        
        if(NSSTRING_HAS_DATA(self.oneTimePasswordTF.text) && [self.oneTimePasswordTF.text isEqualToString:self.userModal.otp]) {
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        if(NSSTRING_HAS_DATA(self.userModal.firstName))
            [userDic setObject:self.userModal.firstName forKey:kEY_fname];
        if(NSSTRING_HAS_DATA(self.userModal.lastName)) {
            [userDic setObject:self.userModal.lastName forKey:kEY_lname];
        }
        else {
            [userDic setObject:@"" forKey:kEY_lname];
        }
        if(NSSTRING_HAS_DATA(self.userModal.email))
            [userDic setObject:self.userModal.email forKey:kEY_uemail];
        if(NSSTRING_HAS_DATA(self.userModal.mobile))
            [userDic setObject:self.userModal.mobile forKey:kEY_number];
        if(NSSTRING_HAS_DATA(self.userModal.userId))
            [userDic setObject:self.userModal.userId forKey:kEY_userid];
        [userDic setObject:@"1" forKey:kEY_otp];
        
        [self showProgress];
        [[GMOperationalHandler handler] editProfile:userDic   withSuccessBlock:^(GMRegistrationResponseModal *registrationResponse) {
            
            if([registrationResponse.flag isEqualToString:@"1"]) {
                
                [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
                
                [self.userModal persistUser];
                
                for (UIViewController *vc in [self.navigationController viewControllers]) {
                    
                    if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMProfileVC class])]) {
                        [self.navigationController popToViewController:vc animated:NO];
                        break;
                    }
                }
            }
            else
                [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
            
            [self removeProgress];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
            [self removeProgress];
        }];
        } else {
            [[GMSharedClass sharedClass] showErrorMessage:@"Please enter valid OTP."];
        }
        
    } else {
        if(NSSTRING_HAS_DATA(self.oneTimePasswordTF.text) && [self.oneTimePasswordTF.text isEqualToString:self.userModal.otp]) {
            [self.view endEditing:YES];
            NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
            if(NSSTRING_HAS_DATA(self.userModal.firstName))
                [userDic setObject:self.userModal.firstName forKey:kEY_fname];
            if(NSSTRING_HAS_DATA(self.userModal.lastName))
                [userDic setObject:self.userModal.lastName forKey:kEY_lname];
            else {
                [userDic setObject:@"" forKey:kEY_lname];
            }
            if(NSSTRING_HAS_DATA(self.userModal.email))
                [userDic setObject:self.userModal.email forKey:kEY_uemail];
            if(NSSTRING_HAS_DATA(self.userModal.mobile))
                [userDic setObject:self.userModal.mobile forKey:kEY_number];
            if(NSSTRING_HAS_DATA(self.userModal.password))
                [userDic setObject:self.userModal.password forKey:kEY_password];
            [userDic setObject:@"1" forKey:kEY_otp];
            [self showProgress];
            [[GMOperationalHandler handler] createUser:userDic withSuccessBlock:^(GMRegistrationResponseModal *registrationResponse) {
                
                if([registrationResponse.flag isEqualToString:@"1"]) {
                    
                    [[GMSharedClass sharedClass] makeLastNameFromUserModal:self.userModal];
                    [self.userModal setUserId:registrationResponse.userId];
                    [self.userModal persistUser];
                    [[GMSharedClass sharedClass] setUserLoggedStatus:YES];
                    if(self.userModal.firstName && self.userModal.userId && self.userModal.email){
                        [rocqAnalytics identity:self.userModal.firstName properties:@{kEY_RocqAnalytics_User_Email:self.userModal.email,kEY_RocqAnalytics_User_FirstName:self.userModal.firstName,kEY_RocqAnalytics_User_Id:self.userModal.userId}];
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                    [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
                
                [self removeProgress];
                
            } failureBlock:^(NSError *error) {
                [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
                [self removeProgress];
            }];
        }
        else
            [[GMSharedClass sharedClass] showErrorMessage:@"Please enter valid OTP."];
    }
}
@end
