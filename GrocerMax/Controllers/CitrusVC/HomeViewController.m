//
//  HomeViewController.m
//  PaymentSdk_GUI
//
//  Created by Vikas Singh on 8/26/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import "HomeViewController.h"
#import "UIUtility.h"
#import "CardsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MerchantConstants.h"
#import "SignUpViewController.h"
#import "GMPaymentVC.h"
#import "UIViewController+MGTopNavigationBarViewController.h"


@interface HomeViewController (){

    int option;
    UIAlertView *alert;
    CGRect frame;
    NSArray *array;
    int selectedRule;
}
@property(nonatomic,strong) IBOutlet UITableView *cardTableView;
@property (nonatomic , weak) IBOutlet UILabel *priceLbl;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.priceLbl.text = [NSString stringWithFormat:@"Pay Rs. %@",self.totalPrice];
    GMCommonNavBarView *commonNavBarView = [self addBarViewWithTitle:@"Citrus wallet" isRightButton:YES];
    [commonNavBarView.backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [commonNavBarView.rightButton addTarget:self action:@selector(signout:) forControlEvents:UIControlEventTouchUpInside];
    [self initialSetting];
    
}
-(void)backButtonPressed{
    
    
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:PAYMENT_CANCEL_ALERT_MESSAGE preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        for (UIViewController *vc in [self.navigationController viewControllers]) {// pop to dashboard
            
            if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMPaymentVC class])]) {
                
                [self.navigationController popToViewController:vc animated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:payment_failure_notifications_ByCitrus object:nil];
                
                
                break;
            }
        }
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionOk];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self resetUI];
//    self.transparentViewView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
//    frame = self.transparentViewView.frame;
    [self getBalance:nil];
}

- (void) viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
//    self.transparentViewView.hidden = TRUE;
}

#pragma mark - Initial Setting Methods
- (void) initialSetting{

    [self.navigationItem setHidesBackButton:NO];
    
//    UINib *nib = [UINib nibWithNibName:@"UITableViewCell" bundle:[NSBundle mainBundle]];
//    [self.cardTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    self.title = @"Home";
    array =[NSArray arrayWithObjects:@"Search and Apply Rule",@"Apply Coupon or Rule",@"Validate Rule", nil];

    self.indicatorView.hidden = TRUE;
//    self.cancelButton.layer.cornerRadius = 4;
//    self.applyButton.layer.cornerRadius = 4;

//    self.dpContainerView.layer.cornerRadius = 4;
//    [self.pickerView setHidden:TRUE];
//    self.couponCodeTextField.hidden = TRUE;
//    self.alteredAmountTextField.hidden = TRUE;
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
//    [self.transparentViewView addGestureRecognizer:tapRecognizer];
    
    // Added right Bar button
    UIBarButtonItem *signoutButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Signout"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(signout:)];
    self.navigationItem.rightBarButtonItem = signoutButton;
    
    
    //    UIPickerView *pickerView = [[UIPickerView alloc] init];
    UIToolbar *accessoryToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    accessoryToolbar.barTintColor = [UIColor orangeColor];
    // Configure toolbar .....
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePickerView)];
    
    [accessoryToolbar setItems:[NSArray arrayWithObjects:doneButton, nil] animated:YES];
    
    // note: myFirstResponderTableViewCell is an IBOutlet to a static cell in storyboard of type FirstResponderTableViewCell
//    self.dynamicPricingTextField.inputView = self.pickerView;
//    self.dynamicPricingTextField.inputAccessoryView = accessoryToolbar;
    
    
//        CALayer *lowerBorder = [CALayer layer];
//        lowerBorder.backgroundColor = [[UIColor darkGrayColor] CGColor];
//        lowerBorder.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame)-1.0f, CGRectGetWidth(self.containerView.frame), 1.0f);
//        [self.containerView.layer addSublayer:lowerBorder];
    
    
}

#pragma mark - Bar Button Methods
- (void) signout:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to signout." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alertView.tag = 1005;
        [alertView show];
        
    });
}

#pragma mark - Action Methods

// You can get user’s citrus cash balance after you have done Link User.
-(IBAction)getBalance:(id)sender{
    
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    [self showProgress];
    
    [proifleLayer requestGetBalance:^(CTSAmount *amount, NSError *error) {
        LogTrace(@" value %@ ",amount.value);
        LogTrace(@" currency %@ ",amount.currency);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = TRUE;
            [self removeProgress];
        });
        
        if (error) {
            [UIUtility toastMessageOnScreen:[error localizedDescription]];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
            self.amountLabel.text = [NSString stringWithFormat:@"%@ %@",amount.currency,amount.value];
            });
//            [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Balance is %@ %@",amount.value,amount.currency]];
        }
    }];
}

// make payment using Citrus cash account
-(IBAction)payUsingCitrusCash:(id)sender{
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//       UIAlertView *citrusPayAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter amount." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok" , nil];
//        citrusPayAlert.tag = 1007;
//        citrusPayAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        UITextField * alertTextField = [citrusPayAlert textFieldAtIndex:0];
//        alertTextField.keyboardType = UIKeyboardTypeDecimalPad;
//        alertTextField.placeholder = @"Amount";
//        [citrusPayAlert show];
//    });
    
    
    
            [self.indicatorView startAnimating];
            self.indicatorView.hidden = FALSE;
        [self showProgress];
    
            
            [proifleLayer requestGetBalance:^(CTSAmount *amount, NSError *error) {
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.indicatorView stopAnimating];
                        self.indicatorView.hidden = TRUE;
                        [self removeProgress];
                    });
                    [UIUtility toastMessageOnScreen:[error localizedDescription]];
                }
                else{
                    if(!NSSTRING_HAS_DATA(self.totalPrice)){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.indicatorView stopAnimating];
                            self.indicatorView.hidden = TRUE;
                            [self removeProgress];
                        });
                        [UIUtility toastMessageOnScreen:@"Amount should not be blank."];
                        
                    }
                    
                    else if ([self.totalPrice isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.indicatorView stopAnimating];
                            self.indicatorView.hidden = TRUE;
                            [self removeProgress];
                        });
                        [UIUtility toastMessageOnScreen:@"Amount should be greater than 0"];
                    }
                    else if([self.totalPrice doubleValue] > [amount.value doubleValue]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.indicatorView stopAnimating];
                            self.indicatorView.hidden = TRUE;
                            [self removeProgress];
                        });
                        [UIUtility toastMessageOnScreen:@"The balance in your Citrus Cash account is insufficient. Please load money."];
                    }
                    else{
                        
                        NSString *mailBillUrl = [NSString stringWithFormat:@"%@%@",BillUrl,self.orderId];
                        [CTSUtility requestBillAmount:self.totalPrice billURL:mailBillUrl callback:^(CTSBill *bill , NSError *error){
                            
                            if (error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.indicatorView stopAnimating];
                                    self.indicatorView.hidden = TRUE;
                                    [self removeProgress];
                                });
                                [UIUtility toastMessageOnScreen:[error localizedDescription]];
                            }
                            else{
                                [paymentLayer requestChargeCitrusWalletWithContact:contactInfo address:addressInfo bill:bill returnViewController:self withCompletionHandler:^(CTSCitrusCashRes *paymentInfo, NSError *error) {
                                    
                                    LogTrace(@"paymentInfo %@",paymentInfo);
                                    LogTrace(@"error %@",error);
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.indicatorView stopAnimating];
                                        self.indicatorView.hidden = TRUE;
                                        [self removeProgress];
                                        //Arvind
                                    });
                                    if(error){
                                        [UIUtility toastMessageOnScreen:[error localizedDescription]];
                                    }
                                    else{
                                        LogTrace(@" isAnyoneSignedIn %d",[authLayer isLoggedIn]);
//                                        [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"TxnStatus: %@",[paymentInfo.responseDict valueForKey:@"TxStatus"]]];
//                                        [self getBalance:nil];
                                        
                                        for (UIViewController *vc in [self.navigationController viewControllers]) {// pop to dashboard
                                            
                                            if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMPaymentVC class])]) {
                                                [self.navigationController popToViewController:vc animated:NO];
                                                [[NSNotificationCenter defaultCenter] postNotificationName:payment_success_notifications_ByCitrus object:nil];
                                                break;
                                            }
                                        }
                                    }
                                }];
                            }
                        }];
                    }
                }
            }];
            
    
}

//Pay money from Cards
-(IBAction)payMoney:(id)sender{

    option = 1;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter amount." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok" , nil];
        alert.tag = 1006;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeDecimalPad;
        alertTextField.placeholder = @"Amount";
        [alert show];
    });
    

}

//Load money to Wallet
-(IBAction)loadMoney:(id)sender{

    option = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter amount." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok" , nil];
        alert.tag = 1006;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeDecimalPad;
        alertTextField.placeholder = @"Amount";
        [alert show];
    });

}

//Send money to particular user
-(IBAction)sendMoney:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *sendMoneyAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter details." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok" , nil];
        sendMoneyAlert.tag = 1008;
        sendMoneyAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField * alertTextField1 = [sendMoneyAlert textFieldAtIndex:0];
        alertTextField1.keyboardType = UIKeyboardTypePhonePad;
        alertTextField1.placeholder = @"User's Phone Number";
        UITextField * alertTextField2 = [sendMoneyAlert textFieldAtIndex:1];
        alertTextField2.keyboardType = UIKeyboardTypeDecimalPad;
        [alertTextField2  setSecureTextEntry:FALSE];
        alertTextField2.placeholder = @"Amount";
        [sendMoneyAlert show];
    });
    
}


-(void)performDynamicPricing:(id)sender{
    
//    self.transparentViewView.frame = frame;
    [UIView animateWithDuration:0.7 animations:^{
//        self.transparentViewView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//        self.couponCodeTextField.hidden = TRUE;
//        self.alteredAmountTextField.hidden = TRUE;
    }
     completion:^(BOOL finished){
         
     }];

}

-(void)hideKeyboard:(id)sender{

    [self.view endEditing:YES];

}

-(IBAction)hideDynamicPricingView:(id)sender{
//    frame = self.transparentViewView.frame;
    [UIView animateWithDuration:0.7 animations:^{
//        self.transparentViewView.frame =  CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);

    }
    completion:^(BOOL finished){
        [self resetUI];
        [self.view endEditing:YES];
//        self.transparentViewView.hidden = TRUE;
    }];
    
   
    
}

-(IBAction)applyCodeAction:(id)sender{
//    self.transparentViewView.hidden = TRUE;
    
    option = 2;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self performSegueWithIdentifier:@"CardViewIdentifier" sender:self];
    });
    
}

- (void)hidePickerView{
    
//    [self.dynamicPricingTextField resignFirstResponder];
    
}

#pragma mark - Class Level Methods
+ (CTSBill*)getBillFromServer:(NSString *)amount{
    // Configure your request here.

     NSString *billURL = [NSString stringWithFormat:@"%@?amount=%@",BillUrl,amount];
   
    
    NSMutableURLRequest* urlReq = [[NSMutableURLRequest alloc] initWithURL:
                                   [NSURL URLWithString:billURL]];
    [urlReq setHTTPMethod:@"POST"];
    NSError* error = nil;

    NSData* signatureData = [NSURLConnection sendSynchronousRequest:urlReq
                                                  returningResponse:nil
                                                              error:&error];
    
    NSString* billJson = [[NSString alloc] initWithData:signatureData
                                               encoding:NSUTF8StringEncoding];
    JSONModelError *jsonError;
    CTSBill* sampleBill = [[CTSBill alloc] initWithString:billJson
                                                    error:&jsonError];
    LogTrace(@"billJson %@",billJson);
    LogTrace(@"signature %@ ", sampleBill);
    return sampleBill;
}

#pragma mark - AlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.view endEditing:YES];
    
    if (alertView.tag ==1005){
        if (buttonIndex==0) {
            if ([authLayer signOut]) {
                sleep(.5);
//                [self.navigationController popToRootViewControllerAnimated:YES];
                
              
                for (UIViewController *vc in [self.navigationController viewControllers]) {// pop to dashboard
                    
                    if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([SignUpViewController class])]) {
                        [self.navigationController popToViewController:vc animated:NO];
                        break;
                    }
                }

            }
        }
    }
    else if (alertView.tag==1006) {
        
        if (buttonIndex==1) {

            dispatch_async(dispatch_get_main_queue(), ^{
//                [self performSegueWithIdentifier:@"CardViewIdentifier" sender:self];
                
                CardsViewController *viewController = [[CardsViewController alloc]init];
                
                //set the Value
                //option = 0 -> Load Money
                //option = 1 -> Pay Money
                
                UITextField * alertTextField = [alert textFieldAtIndex:0];
                
                viewController.landingScreen=option;
                viewController.amount = alertTextField.text;
                [self.navigationController pushViewController:viewController animated:YES];
            });
        }
    }
    else if (alertView.tag==1007){
        
        if (buttonIndex==1) {
            
            [self.indicatorView startAnimating];
            self.indicatorView.hidden = FALSE;
            [self showProgress];
            
            
            [proifleLayer requestGetBalance:^(CTSAmount *amount, NSError *error) {
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.indicatorView stopAnimating];
                        self.indicatorView.hidden = TRUE;
                        [self removeProgress];
                    });
                    [UIUtility toastMessageOnScreen:[error localizedDescription]];
                }
                else{
                    UITextField * alertTextField = [alertView textFieldAtIndex:0];
                    if(alertTextField.text.length==0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.indicatorView stopAnimating];
                            self.indicatorView.hidden = TRUE;
                            [self removeProgress];
                        });
                        [UIUtility toastMessageOnScreen:@"Amount should not be blank."];
                        
                    }
                
                    else if ([alertTextField.text isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.indicatorView stopAnimating];
                            self.indicatorView.hidden = TRUE;
                            [self removeProgress];
                        });
                        [UIUtility toastMessageOnScreen:@"Amount should be greater than 0"];
                    }
                    else if([alertTextField.text doubleValue] > [amount.value doubleValue]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.indicatorView stopAnimating];
                            self.indicatorView.hidden = TRUE;
                            [self removeProgress];
                        });
                        [UIUtility toastMessageOnScreen:@"The balance in your Citrus Cash account is insufficient. Please load money."];
                    }
                    else{
                        
                        NSString *mailBillUrl = [NSString stringWithFormat:@"%@%@",BillUrl,self.orderId];
                        
                        [CTSUtility requestBillAmount:alertTextField.text billURL:mailBillUrl callback:^(CTSBill *bill , NSError *error){
                        
                            if (error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.indicatorView stopAnimating];
                                    self.indicatorView.hidden = TRUE;
                                    [self removeProgress];
                                });
                                [UIUtility toastMessageOnScreen:[error localizedDescription]];
                            }
                            else{
                                [paymentLayer requestChargeCitrusWalletWithContact:contactInfo address:addressInfo bill:bill returnViewController:self withCompletionHandler:^(CTSCitrusCashRes *paymentInfo, NSError *error) {
                                    
                                    LogTrace(@"paymentInfo %@",paymentInfo);
                                    LogTrace(@"error %@",error);
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.indicatorView stopAnimating];
                                        self.indicatorView.hidden = TRUE;
                                        [self removeProgress];
                                        //Arvind
                                    });
                                    if(error){
                                        [UIUtility toastMessageOnScreen:[error localizedDescription]];
                                    }
                                    else{
                                        LogTrace(@" isAnyoneSignedIn %d",[authLayer isLoggedIn]);
//                                        [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"TxnStatus: %@",[paymentInfo.responseDict valueForKey:@"TxStatus"]]];
//                                        [self getBalance:nil];
                                        
                                        for (UIViewController *vc in [self.navigationController viewControllers]) {// pop to dashboard
                                            
                                            if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMPaymentVC class])]) {
                                                [self.navigationController popToViewController:vc animated:NO];
                                                [[NSNotificationCenter defaultCenter] postNotificationName:payment_success_notifications_ByCitrus object:nil];
                                                break;
                                            }
                                        }
                                    }
                                }];
                            }
                        }];
                    }
                }
            }];
            
        }
    }
    else if (alertView.tag==1008) {
        
        if (buttonIndex==1) {
            
            [self.indicatorView startAnimating];
            self.indicatorView.hidden = FALSE;
            
            [paymentLayer requestTransferMoneyTo:[alertView textFieldAtIndex:0].text amount:[alertView textFieldAtIndex:1].text message:@"Here is Some Money for you" completionHandler:^(CTSTransferMoneyResponse*transferMoneyRes,  NSError *error) {
                LogTrace(@" transferMoneyRes %@ ",transferMoneyRes);
                
                LogTrace(@" error %@ ",[error localizedDescription]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.indicatorView stopAnimating];
                    self.indicatorView.hidden = TRUE;
                });
                
                if (error) {
                    
                    [UIUtility toastMessageOnScreen:[error localizedDescription]];
                }
                else{
                    [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Transfer Status %@",transferMoneyRes.status]];
                    [self getBalance:nil];
                }
            }];

        }
    }
    
}


//#pragma mark - PickerView Delegate Methods
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return [array count];
//}
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    
//    return 1;
//    
//}
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    self.couponCodeTextField.hidden = TRUE;
//    self.alteredAmountTextField.hidden = TRUE;
//    self.dynamicPricingTextField.text = [array objectAtIndex:row];
//    if ([self.dynamicPricingTextField.text isEqualToString:[array objectAtIndex:1]]) {
//        self.couponCodeTextField.hidden = FALSE;
//    }
//    else if ([self.dynamicPricingTextField.text isEqualToString:[array objectAtIndex:2]]) {
//        self.couponCodeTextField.hidden = FALSE;
//        self.alteredAmountTextField.hidden = FALSE;
//    }
//    
//    selectedRule =(int) row;
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
//    return [array objectAtIndex:row];
//    
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel* pickerLabel = (UILabel*)view;
//    
//    if (!pickerLabel)
//    {
//        pickerLabel = [[UILabel alloc] init];
//        
//        pickerLabel.font = [UIFont fontWithName:@"Verdana-Semibold" size:16]; //Verdana-Semibold
//        
//        pickerLabel.textAlignment=NSTextAlignmentCenter;
//        
//        pickerLabel.textColor = [UIColor darkGrayColor];
//    }
//    [pickerLabel setText:[array objectAtIndex:row]];
//    
//    return pickerLabel;
//}


#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    cell.layer.cornerRadius = 3;
//    [[UITableViewCell appearance] setTintColor:[UIColor orangeColor]];
    static NSString *MyIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: MyIdentifier];
    }
    
    if (indexPath.row==0) {
//        ((UILabel *) [cell.contentView viewWithTag:500]).text = @"Get Balance";
        ((UILabel *) [cell.contentView viewWithTag:500]).text = @"Pay Using Citrus Cash";
        cell.textLabel.text = @"Pay Using Citrus Cash";
    }
    else if (indexPath.row==1) {
        ((UILabel *) [cell.contentView viewWithTag:500]).text = @"Load Money";
        cell.textLabel.text = @"Load Money";
    }
    else if (indexPath.row==2) {
        ((UILabel *) [cell.contentView viewWithTag:500]).text = @"Pay Using Citrus Cash";
    }
    else if (indexPath.row==3) {
        ((UILabel *) [cell.contentView viewWithTag:500]).text = @"Send Money";
    }
    else if (indexPath.row==4) {
        ((UILabel *) [cell.contentView viewWithTag:500]).text = @"PG Payment";
    }
    else if (indexPath.row==5) {
        ((UILabel *) [cell.contentView viewWithTag:500]).text = @"Pay using Dynamic Pricing";
    }
    else if (indexPath.row==6) {
        ((UILabel *) [cell.contentView viewWithTag:500]).text = @"Manage Cards";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==10) {
        self.indicatorView.hidden = FALSE;
        [self.indicatorView startAnimating];
        
        [proifleLayer requestGetBalance:^(CTSAmount *amount, NSError *error) {
            LogTrace(@" value %@ ",amount.value);
            LogTrace(@" currency %@ ",amount.currency);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView stopAnimating];
                self.indicatorView.hidden = TRUE;
            });
            
            if (error) {
                [UIUtility toastMessageOnScreen:[error localizedDescription]];
            }
            else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.amountLabel.text = [NSString stringWithFormat:@"%@ %@",amount.currency,amount.value];
                });
                [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Balance is %@ %@",amount.value,amount.currency]];
            }
        }];
    }
    else if (indexPath.row==1) {
        [self loadMoney:nil];
    }
    else if (indexPath.row==0) {
        [self payUsingCitrusCash:nil];
    }
    else if (indexPath.row==3) {
        [self sendMoney:nil];
    }
    else if (indexPath.row==4) {
        [self payMoney:nil];
    }
    else if (indexPath.row==5) {
//        self.transparentViewView.hidden = FALSE;
        [self performDynamicPricing:nil];
    }
    else if (indexPath.row==6) {
        [self performSegueWithIdentifier:@"ManageCardIdentifier" sender:nil];
    }
    
}

#pragma mark - StoryBoard Delegate Methods
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"CardViewIdentifier"]) {
        
        CardsViewController *viewController = (CardsViewController *)segue.destinationViewController;
        
        //set the Value
        //option = 0 -> Load Money
        //option = 1 -> Pay Money
        //option = 2 -> Perform DP
        
         viewController.landingScreen=option;
        
        if (option==2) {
            
           // dynamicPricingTextField
            //couponCodeTextField;
           // alteredAmountTextField
//            CTSRuleInfo *ruleInfo = [[CTSRuleInfo alloc] init];
//            ruleInfo.ruleName = self.couponCodeTextField.text;
//            ruleInfo.alteredAmount = self.alteredAmountTextField.text;
//            ruleInfo.originalAmount = self.amountTextField.text;
//            if (selectedRule==0) {
//                ruleInfo.operationType = DPRequestTypeSearchAndApply;
//                ruleInfo.alteredAmount = nil;
//                ruleInfo.ruleName = nil;
//            }
//            else if (selectedRule==1) {
//                    ruleInfo.operationType = DPRequestTypeCalculate;
//                ruleInfo.alteredAmount = nil;
//            }
//            else if (selectedRule==2) {
//                ruleInfo.operationType = DPRequestTypeValidate;
//            }
//            
//            viewController.ruleInfo = ruleInfo;
            
        }
        else
            viewController.amount = ((UITextField *)[alert textFieldAtIndex:0]).text; //Passing the amount to Card payment screen
        
    }
    
}
- (void)resetUI{

//    self.dynamicPricingTextField.text = @"";
//    self.amountTextField.text = @"";
//    self.couponCodeTextField.text = @"";
//    self.alteredAmountTextField.text = @"";
//    self.transparentViewView.hidden = TRUE;

}


#pragma mark - Dealloc Methods
- (void) dealloc{
    
//    self.cancelButton = nil;
//    self.applyButton = nil;
    self.indicatorView = nil;
    self.amountLabel = nil;
//    self.pickerView = nil;
//    self.dynamicPricingTextField = nil;
//    self.amountTextField = nil;
//    self.couponCodeTextField = nil;
//    self.alteredAmountTextField = nil;
//    self.transparentViewView = nil;
    self.containerView = nil;
//    self.dynamicPricingTextField = nil;
//    self.amountTextField = nil;
//    self.couponCodeTextField = nil;
//    self.alteredAmountTextField = nil;
//    self.pickerView = nil;
//    self.transparentViewView = nil;
    self.userName = nil;

}

#pragma mark - TextView Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    if (textField==self.dynamicPricingTextField) {
//        [self.pickerView setHidden:FALSE];
//        [self.pickerView reloadAllComponents];
//         [self.pickerView selectRow:0 inComponent:0 animated:YES];
//        [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
//        [self.pickerView removeFromSuperview];
//        [self.dynamicPricingTextField becomeFirstResponder];
//    }
}



@end
