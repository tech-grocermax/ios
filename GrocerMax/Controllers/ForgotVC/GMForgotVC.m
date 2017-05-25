//
//  GMForgotVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMForgotVC.h"

@interface GMForgotVC ()

@property (weak, nonatomic) IBOutlet UIView *emailBgView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@end

@implementation GMForgotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Recover Password";
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_ForgotPassword_Screen];
}

#pragma mark - GETTER/SETTER Methods

//- (void)setEmailBgView:(UIView *)emailBgView {
//    
//    _emailBgView = emailBgView;
//    [_emailBgView.layer setCornerRadius:5.0];
//    [_emailBgView.layer setBorderWidth:1.0];
//    [_emailBgView.layer setBorderColor:[UIColor inputTextFieldColor].CGColor];
//}

#pragma mark - IBAction Methods

- (IBAction)submitButtonTapped:(id)sender {
    
    [self.view endEditing:YES];
    
    if([GMSharedClass validateEmail:self.emailTextField.text]) {
        
        NSDictionary *dic = @{kEY_uemail : self.emailTextField.text};
        [self showProgress];
        [[GMOperationalHandler handler] forgotPassword:dic withSuccessBlock:^(NSDictionary *responceData) {
            NSString *message = @"";
            if([responceData objectForKey:@"Result"]) {
                message = [responceData objectForKey:@"Result"];
            }
            if([[responceData objectForKey:@"flag"] intValue] == 1) {
                if(!NSSTRING_HAS_DATA(message)) {
                    message = @"Password send to your mail, please check your mail.";
                }
                [[GMSharedClass sharedClass] showErrorMessage:message];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                if(!NSSTRING_HAS_DATA(message)) {
                    message = @"Invalid Email Id.";
                }
                [[GMSharedClass sharedClass] showErrorMessage:message];
            }
            [self removeProgress];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Please check your internet."];
            [self removeProgress];
        }];
        
        
    }
    else {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please provide your valid email address."];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
