//
//  SignInViewController.h
//  PaymentSdk_GUI
//
//  Created by Vikas Singh on 8/26/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SignInViewController : BaseViewController

@property (nonatomic , weak) IBOutlet UIButton *signinButton;
@property (nonatomic , weak) IBOutlet UITextField *userNameTextField;
@property (nonatomic , weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic , weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic , strong)  NSString *userName;


@property (nonatomic,strong) NSString *totalPrice;
@property (nonatomic,strong) NSString *orderId;

@end

