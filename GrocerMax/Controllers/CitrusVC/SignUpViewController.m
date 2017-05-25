//
//  SignUpViewController.m
//  PaymentSdk_GUI
//
//  Created by Vikas Singh on 8/26/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import "SignUpViewController.h"
#import "UIUtility.h"
#import "ResetPasswordViewController.h"
#import "SignInViewController.h"
#import "UIViewController+MGTopNavigationBarViewController.h"
#import "HomeViewController.h"

@interface SignUpViewController ()

@property (nonatomic , weak) IBOutlet UILabel *priceLbl;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self initializeLayers:self.shippingAddressModal];
    
    GMCommonNavBarView *commonNavBarView = [self addBarViewWithTitle:@"Sign up" isRightButton:NO];
    [commonNavBarView.backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.priceLbl.text = [NSString stringWithFormat:@"Rs. %@",self.totalPrice];
    
    self.indicatorView.hidden = TRUE;
    self.signupButton.layer.cornerRadius = 4;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    if(NSSTRING_HAS_DATA(userModal.email)) {
        self.userNameTextField.text = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        self.mobileTextField.text = userModal.mobile;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated{
//    if (authLayer.requestSignInOauthToken.length != 0) {
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            //[self performSegueWithIdentifier:@"HomeScreenIdentifier" sender:nil];
//            HomeViewController *homeViewController = [[HomeViewController alloc]init];
//            homeViewController.totalPrice = self.totalPrice;
//            homeViewController.orderId = self.orderId;
//            [self.navigationController pushViewController:homeViewController animated:NO];
//            
//            
//            return;
//        }];
//    }
//}

#pragma mark - Action Methods
-(void)backButtonPressed{
    
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:PAYMENT_CANCEL_ALERT_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:payment_failure_notifications_ByCitrus object:nil];
        
        
        
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionOk];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}



-(IBAction)linkUser:(id)sender{
    
    [self.view endEditing:YES];
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    [self showProgress];
    
    [authLayer requestLinkUser:self.userNameTextField.text mobile:self.mobileTextField.text completionHandler:^(CTSLinkUserRes *linkUserRes, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = TRUE;
            [self removeProgress];
        });
        if (error) {
            [UIUtility toastMessageOnScreen:[error localizedDescription]];
        }
        else{
            //            [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"User is now Linked, %@",linkUserRes.message]];
            if (linkUserRes.isPasswordAlreadySet) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    SignInViewController *signInViewController = [[SignInViewController alloc]init];
                    signInViewController.userName = self.userNameTextField.text;
                    signInViewController.totalPrice = self.totalPrice;
                    signInViewController.orderId = self.orderId;
                    [self.navigationController pushViewController:signInViewController animated:YES];
                                    }];
            }
            else{
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    ResetPasswordViewController *resetPasswordViewController = [[ResetPasswordViewController alloc]init];
                    resetPasswordViewController.userName = self.userNameTextField.text;
                    resetPasswordViewController.totalPrice = self.totalPrice;
                    resetPasswordViewController.orderId = self.orderId;
                    
                    [self.navigationController pushViewController:resetPasswordViewController animated:YES];
                    
                    
                }];
                
            }
            
        }
    }];
}

- (void)resignKeyboard:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
}

#pragma mark - StoryView Delegate Methods
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"ResetPasswordScreenIdentifier"]) {
        ResetPasswordViewController *viewController = (ResetPasswordViewController *)segue.destinationViewController;
        viewController.userName = self.userNameTextField.text;
    }
    else if ([segue.identifier isEqualToString:@"SignInScreenIdentifier"]){
        
        SignInViewController *viewController = (SignInViewController *)segue.destinationViewController;
        viewController.userName = self.userNameTextField.text;
    }
    
}

#pragma mark - Dealloc Methods
- (void) dealloc{
    self.userNameTextField = nil;
    self.mobileTextField = nil;
    self.signupButton = nil;
    self.indicatorView = nil;
}


@end
