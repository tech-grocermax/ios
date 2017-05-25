//
//  GMLoginVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMLoginVC.h"
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GMRegisterVC.h"
#import "GMForgotVC.h"
#import "GMProfileVC.h"
#import "GMProvideMobileInfoVC.h"
#import "GMStateBaseModal.h"

@interface GMLoginVC ()<UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txt_email;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@end

@implementation GMLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //    [self configureView];
    self.navigationItem.rightBarButtonItem = nil;
    if(self.isPresent) {
        UIBarButtonItem *signoutButton = [[UIBarButtonItem alloc]
                                          initWithTitle:@"Cancel"
                                          style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(closeBtnPressed:)];
        self.navigationItem.rightBarButtonItem = signoutButton;
        //        self.closeBtn.hidden = NO;
    }
    else {
       //        self.closeBtn.hidden = YES;
    }

    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_TabProfile withCategory:@"" label:nil value:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"LOGIN";
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    if(self.isPresent) {
        
        if([[GMSharedClass sharedClass] getUserLoggedStatus] == YES){
            [self dismissViewControllerAnimated:YES completion:nil];
            
            GMUserModal *userModal = [[GMSharedClass sharedClass] getLoggedInUser];
            
                NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
                if(NSSTRING_HAS_DATA(userModal.userId)){
                    [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
                }
                
                if(NSSTRING_HAS_DATA(userModal.email)){
                    [qaGrapEventDic setObject:userModal.email forKey:kEY_QA_EventParmeter_EmailId];
                }
            
            if(NSSTRING_HAS_DATA(userModal.mobile)){
                [qaGrapEventDic setObject:userModal.mobile forKey:kEY_QA_EventParmeter_PhoneNumber];
            }
                [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_CheckOutSignUp withExtraParameter:qaGrapEventDic];
                
            
        }
    } else {
        
        if([[GMSharedClass sharedClass] getUserLoggedStatus] == YES) {
            [self setSecondTabAsProfile];
        } else {
            [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_LogIn_Screen];
        }
    }
    // google login
    [self configureView];
}

- (void)configureView{
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].scopes = @[@"https://www.googleapis.com/auth/userinfo.email", @"https://www.googleapis.com/auth/userinfo.profile"];
    [GIDSignIn sharedInstance].allowsSignInWithBrowser = FALSE;
}

- (void)setTxt_email:(UITextField *)txt_email {
    
    _txt_email = txt_email;
    _txt_email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email ID" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
}

- (void)setTxt_password:(UITextField *)txt_password {
    
    _txt_password = txt_password;
    _txt_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
}

#pragma mark - Button Action
- (IBAction)closeBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)fbLoginButtonPressed:(UIButton *)sender {
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email",@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
//    }]
//    [login logInWithReadPermissions:@[@"email",@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                
                if ([FBSDKAccessToken currentAccessToken])
                {
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,first_name,last_name,email,gender"}]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             
                             NSDictionary *resultDic = result;
                             
                             if(resultDic != nil) {
                                 if ([result objectForKey:@"email"]) {
                                     [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_FacebookLogin withCategory:@"" label:nil value:nil];
                                     
                                     GMCityModal *cityModal = [GMCityModal selectedLocation];
                                     [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Login" label:@"Social"];
                                     
                                     
                                     GMUserModal *userModal = [[GMUserModal alloc] init];
                                     [userModal setFbId:[result objectForKey:@"id"]];
                                     [userModal setEmail:[result objectForKey:@"email"]];
                                     [userModal setFirstName:[result objectForKey:@"first_name"]];
                                     [userModal setGender:[[result objectForKey:@"gender"] isEqualToString:@"male"]?GMGenderTypeMale:GMGenderTypeFemale];
                                     
//                                     if([[result objectForKey:kEY_flag] isEqualToString:@"1"])
                                         [self fbRegisterOnServerWithUserModal:userModal];
//                                     else {
//                                         GMProvideMobileInfoVC *vc = [[GMProvideMobileInfoVC alloc] initWithNibName:@"GMProvideMobileInfoVC" bundle:nil];
//                                         vc.userModal = userModal;
//                                         [self.navigationController pushViewController:vc animated:YES];
//                                     }
                                 }
                             }
                             
                         }
                     }];
                }
            }
        }
    }];
}

- (IBAction)googleLoginButtonPressed:(UIButton *)sender {
    
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)forgotButtonPressed:(UIButton *)sender {
    
    GMForgotVC *forgotVC = [[GMForgotVC alloc] initWithNibName:@"GMForgotVC" bundle:nil];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    if(self.isPresent) {
        [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Login withCategory:kEY_GA_Category_Checkout_Funnel label:@"Existing User"];
    }
    [self.view endEditing:YES];
    
    if([self performValidations]) {
        
        NSDictionary *param = [[GMRequestParams sharedClass] getUserLoginRequestParamsWith:self.txt_email.text password:self.txt_password.text] ;
        
        [self showProgress];
        [[GMOperationalHandler handler] login:param withSuccessBlock:^(GMUserModal *userModal) {
            
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_EmailLogin withCategory:@"" label:nil value:nil];
            
            GMCityModal *cityModal = [GMCityModal selectedLocation];
            [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Login" label:@"Regular"];
            
            [self removeProgress];
            
            GMUserModal *saveUserModal = [GMUserModal loggedInUser];
            if(!NSSTRING_HAS_DATA(userModal.quoteId) && NSSTRING_HAS_DATA(saveUserModal.quoteId)) {
                userModal.quoteId = saveUserModal.quoteId;
            }
            
            [userModal setEmail:self.txt_email.text];
            [userModal persistUser];
            [rocqAnalytics identity:userModal.firstName properties:@{kEY_RocqAnalytics_User_Email:userModal.email,kEY_RocqAnalytics_User_FirstName:userModal.firstName,kEY_RocqAnalytics_User_Id:userModal.userId}];
            [[GMSharedClass sharedClass] setUserLoggedStatus:YES];
            if(self.isPresent) {
                [self dismissViewControllerAnimated:YES completion:nil];
                NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
                if(NSSTRING_HAS_DATA(userModal.userId)){
                    [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
                }
                
                if(NSSTRING_HAS_DATA(userModal.email)){
                    [qaGrapEventDic setObject:userModal.email forKey:kEY_QA_EventParmeter_EmailId];
                }
                [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_CheckOutSignIn withExtraParameter:qaGrapEventDic];
            } else {
                
                [self setSecondTabAsProfile];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
        } failureBlock:^(NSError *error) {
            
            [self removeProgress];
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        }];
    }
}

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    
    GMRegisterVC *registerVC = [[GMRegisterVC alloc] initWithNibName:@"GMRegisterVC" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
    if(self.isPresent) {
        [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Login withCategory:kEY_GA_Category_Checkout_Funnel label:@"New Registration"];
    }
    //    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
}

#pragma mark - Validations...

- (BOOL)performValidations{
    
    if (!NSSTRING_HAS_DATA(self.txt_email.text)){
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterEmail")];
        return NO;
    }
    else if (![GMSharedClass validateEmail:self.txt_email.text])
    {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterValidEmail")];
        return NO;
        
    }else if (!NSSTRING_HAS_DATA(self.txt_password.text))
    {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterPassword")];
        return NO;
    }
    else
        return YES;
}

#pragma mark - Google Login Delegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    // ...
    if(error == nil) {
        if (user.profile.email) {
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_GoogleLogin withCategory:@"" label:nil value:nil];
            
            GMCityModal *cityModal = [GMCityModal selectedLocation];
            [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Login" label:@"Social"];
            
            GMUserModal *userModal = [GMUserModal new];
            [userModal setGoogleId:user.userID];
            [userModal setEmail:user.profile.email];
            [userModal setFirstName:user.profile.name];
            [userModal setLastName:@""];
            [userModal setGender:GMGenderTypeMale];// suppose it defaul
            [[GIDSignIn sharedInstance] signOut];
            
            if(NSSTRING_HAS_DATA(userModal.email))
                [self fbRegisterOnServerWithUserModal:userModal];
//            else {
//                GMProvideMobileInfoVC *vc = [[GMProvideMobileInfoVC alloc] initWithNibName:@"GMProvideMobileInfoVC" bundle:nil];
//                vc.userModal = userModal;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
        }
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma mark - Flip Animation methods

- (void)flipVC:(UIViewController*) controller to:(UIViewAnimationTransition) trasition {
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:trasition
                           forView:self.navigationController.view cache:NO];
    
    if (controller)
        [self.navigationController pushViewController:controller animated:YES];
    
    [UIView commitAnimations];
}

#pragma mark - Send data on server

- (void)fbRegisterOnServerWithUserModal:(GMUserModal *)userModal {
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [paramDict setObject:userModal.email forKey:kEY_uemail];
    [paramDict setObject:@"" forKey:kEY_quote_id];
    [paramDict setObject:userModal.firstName ? userModal.firstName : @"" forKey:kEY_fname];
    [paramDict setObject:userModal.lastName ? userModal.lastName : @"" forKey:kEY_lname];
    [paramDict setObject:userModal.mobile ? userModal.mobile : @"" forKey:kEY_number];
    
    GMUserModal *savedUserModal = [GMUserModal loggedInUser];
    if(NSSTRING_HAS_DATA(savedUserModal.quoteId)) {
    [paramDict setObject:savedUserModal.quoteId forKey:kEY_quote_id];
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] fgLoginRequestParamsWith:paramDict withSuccessBlock:^(id data) {
        
        [self removeProgress];
        NSDictionary *resDic = data;
        
        if ([resDic objectForKey:kEY_UserID]) {
                [userModal setQuoteId:resDic[kEY_QuoteId]];
                [userModal setUserId:resDic[kEY_UserID]];
                
                if ([resDic objectForKey:kEY_Mobile]) {
                    [userModal setMobile:[resDic objectForKey:kEY_Mobile]];
                }
                [userModal setTotalItem:[NSNumber numberWithInteger:[resDic[kEY_TotalItem] integerValue]]];
             }
            
            if([[resDic objectForKey:kEY_flag] isEqualToString:@"1"]) {
                [[GMSharedClass sharedClass] makeLastNameFromUserModal:userModal];
                [userModal persistUser];// save user modal in memory
                [[GMSharedClass sharedClass] setUserLoggedStatus:YES];// save logged in status
                if(userModal.firstName && userModal.userId && userModal.email){
                [rocqAnalytics identity:userModal.firstName properties:@{kEY_RocqAnalytics_User_Email:userModal.email,kEY_RocqAnalytics_User_FirstName:userModal.firstName,kEY_RocqAnalytics_User_Id:userModal.userId}];
                }
                
                if(self.isPresent) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
                    if(NSSTRING_HAS_DATA(userModal.userId)){
                        [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
                    }
                    
                    if(NSSTRING_HAS_DATA(userModal.email)){
                        [qaGrapEventDic setObject:userModal.email forKey:kEY_QA_EventParmeter_EmailId];
                    }
                    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_CheckOutSignIn withExtraParameter:qaGrapEventDic];
                    
                } else {
                    [self setSecondTabAsProfile];//So user is registered, now set 2nd tab as profile
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            } else {
                    GMProvideMobileInfoVC *vc = [[GMProvideMobileInfoVC alloc] initWithNibName:@"GMProvideMobileInfoVC" bundle:nil];
                    vc.userModal = userModal;
                    [self.navigationController pushViewController:vc animated:YES];
            }
            
            
       
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}
@end
