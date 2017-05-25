//
//  SignInViewController.m
//  PaymentSdk_GUI
//
//  Created by Vikas Singh on 8/26/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import "SignInViewController.h"
#import "UIUtility.h"
#import "HomeViewController.h"
#import "UIViewController+MGTopNavigationBarViewController.h"

@interface SignInViewController (){
    
    NSString *currentUser;

}

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationItem setHidesBackButton:YES];
    // Added right Bar button
    
    GMCommonNavBarView *commonNavBarView = [self addBarViewWithTitle:@"Sign in" isRightButton:NO];
    [commonNavBarView.backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.signinButton.layer.cornerRadius = 4;
    self.indicatorView.hidden = TRUE;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    [self.view addGestureRecognizer:tapRecognizer];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.userNameTextField.text = @"";
    self.passwordTextField.text = @"";
    if (self.userName!=nil) {
        self.userNameTextField.text = self.userName;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

#pragma mark - Action Methods
-(void)backButtonPressed{
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(IBAction)signin:(id)sender{
    
    [self.view endEditing:YES];
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    [self showProgress];
    [authLayer requestSigninWithUsername:self.userNameTextField.text password:self.passwordTextField.text completionHandler:^(NSString *userName, NSString *token, NSError *error) {
        LogTrace(@"userName %@",userName);
        LogTrace(@"error %@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = TRUE;
            [self removeProgress];
        });
        if (error) {
            [UIUtility toastMessageOnScreen:[error localizedDescription]];
        }
        else{
//            [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"%@ is now logged in",userName]];
            currentUser = userName;
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [self performSegueWithIdentifier:@"HomeScreenIdentifier" sender:self];
                 HomeViewController *homeViewController = [[HomeViewController alloc]init];
                 homeViewController.totalPrice = self.totalPrice;
                 homeViewController.orderId = self.orderId;
                 homeViewController.userName = currentUser;
                 [self.navigationController pushViewController:homeViewController animated:YES];
             }];
            
        }
        
    }];
}

-(IBAction)forgotPassword:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password?" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok" , nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeEmailAddress;
        alertTextField.placeholder = @"Email Address";
        [alert show];
    });
}

- (void)resignKeyboard:(UITapGestureRecognizer *)sender{
    
     [self.view endEditing:YES];
}

#pragma mark - StoryBoard Delegate Methods
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"HomeScreenIdentifier"]) {
        HomeViewController *viewController = (HomeViewController *)segue.destinationViewController;
        viewController.userName = currentUser;
    }
    
}

#pragma mark - AlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
    
        
            [authLayer requestResetPassword:alertTextField.text completionHandler:^(NSError *error) {
                if (error) {
                    [UIUtility toastMessageOnScreen:[error localizedDescription]];
                }
                else{
                    [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Reset link sent to email address"]];
                }
            }];
    }
    
}

#pragma mark - TextView Delegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.userNameTextField) {
        if (textField.text.length==0) {
            [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Email Id field should not be empty."]];
        }
        else if (![CTSUtility validateEmail:textField.text]) {
            [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Email Id is not valid."]];
        }
    }
}

#pragma mark - Dealloc Methods
- (void) dealloc{
    
    self.userNameTextField = nil;
    self.passwordTextField = nil;
    self.signinButton = nil;
    self.indicatorView = nil;
}

@end
