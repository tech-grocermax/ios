//
//  InitialViewController.m
//  CTS iOS Sdk
//
//  Created by Vikas Singh on 1/13/16.
//  Copyright © 2016 Citrus. All rights reserved.
//

#import "InitialViewController.h"
#import "SignUpViewController.h"
#import "HomeViewController.h"
#import "UIViewController+MGTopNavigationBarViewController.h"

@interface InitialViewController (){
    
    int selectionType;

}

@end

@implementation InitialViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeLayers:self.shippingAddressModal];
//    -(GMCommonNavBarView*)addBarViewWithTitle:(NSString*)titleString isRightButton:(BOOL)isRightButton;
    GMCommonNavBarView *commonNavBarView = [self addBarViewWithTitle:@"Sign up option" isRightButton:NO];
    [commonNavBarView.backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBarHidden = YES;
//     self.signupOptionOneButton.layer.cornerRadius = 4;
     self.signupOptionTwoButton.layer.cornerRadius = 4;
//     self.signupOptionThreeButton.layer.cornerRadius = 4;
    
//    if (authLayer.requestSignInOauthToken.length != 0) {
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            //[self performSegueWithIdentifier:@"HomeScreenIdentifier" sender:nil];
//            HomeViewController *homeViewController = [[HomeViewController alloc]init];
//            
//            [self.navigationController pushViewController:homeViewController animated:YES];
//
//            
//            return;
//        }];
//    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    if (authLayer.requestSignInOauthToken.length != 0) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //[self performSegueWithIdentifier:@"HomeScreenIdentifier" sender:nil];
            HomeViewController *homeViewController = [[HomeViewController alloc]init];
            homeViewController.totalPrice = self.totalPrice;
            homeViewController.orderId = self.orderId;
            [self.navigationController pushViewController:homeViewController animated:NO];
            
            
            return;
        }];
    }
}
-(void)backButtonPressed{
    
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:@"Realy Want to cancel the payment?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:payment_failure_notifications_ByCitrus object:nil];
        
            }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:actionOk];
    [alertController addAction:actionCancel];
        [self presentViewController:alertController animated:YES completion:nil];
        
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectLoginTypeAction:(UIButton *)sender{

    if (sender.tag == 1000) {
        selectionType = 0;
    }
    else if (sender.tag == 1001) {
//        selectionType = 1;
        selectionType = 2;
    }
    else if (sender.tag == 1002) {
        selectionType = 2;
    }

    
    SignUpViewController *signUpViewController = [[SignUpViewController alloc]init];
    
    // loginType = 0 -> by using Email Id & Mobile
    // loginType = 1 -> by using Mobile only
    // loginType = 2 -> by using either Email Id or Mobile
    
//    signUpViewController.loginType = selectionType;
    signUpViewController.totalPrice = self.totalPrice;
    signUpViewController.orderId = self.orderId;
    [self.navigationController pushViewController:signUpViewController animated:YES];
    
//    [self performSegueWithIdentifier:@"InitialViewIdentifier" sender:self];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"InitialViewIdentifier"]) {
        SignUpViewController *signUpViewController = (SignUpViewController *)[segue destinationViewController];
        
        // loginType = 0 -> by using Email Id & Mobile
        // loginType = 1 -> by using Mobile only
        // loginType = 2 -> by using either Email Id or Mobile
        
//        signUpViewController.loginType = selectionType;
    }
    
}


@end
