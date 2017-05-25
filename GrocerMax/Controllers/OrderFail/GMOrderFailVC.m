//
//  GMOrderFailVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 15/10/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderFailVC.h"
#import "GMOrderSuccessVC.h"
#import "GMApiPathGenerator.h"
#import "PayU_iOS_SDK.h"

#import "PGMerchantConfiguration.h"
#import "PGOrder.h"
#import "PGTransactionViewController.h"
#import "GMCheckOutModal.h"
#import "GMCartDetailModal.h"
#import "GMStateBaseModal.h"

//#define PayU_Product_Info @"GrocerMax Product Info"

@interface GMOrderFailVC ()<PGTransactionDelegate>

@property (nonatomic, strong) NSString *txnID;
@property (nonatomic, strong) NSDictionary *hashDict;
@property(nonatomic,strong) NSString *myKey;
@property(nonatomic,strong) NSString *offerKey;
typedef void (^urlRequestCompletionBlock)(NSURLResponse *response, NSData *data, NSError *connectionError);

@end

@implementation GMOrderFailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txnID = self.orderId;
    // Do any additional setup after loading the view from its nib.
    [self initilizedpayUdata];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Order Failed" label:@""];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.userId)){
        [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    if(NSSTRING_HAS_DATA(self.paymentOption)){
        [qaGrapEventDic setObject:self.paymentOption forKey:kEY_QA_EventParmeter_PaymentOption];
    }
    if(self.totalAmount>0){
        [qaGrapEventDic setObject:[NSString stringWithFormat:@"%.2f",self.totalAmount] forKey:kEY_QA_EventParmeter_Subtotal];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_CheckOutOrderFailure withExtraParameter:qaGrapEventDic];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_CartPaymentFail_Screen];
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
- (IBAction)actionRetryPayment:(id)sender {
    
//    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Payment By" message:@"Payment" preferredStyle:UIAlertControllerStyleAlert];
//    
//    
//    UIAlertAction *actionPayU = [UIAlertAction actionWithTitle:@"Online Payment (Credit/Debit card, Net Banking)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [self createHeashKey];
//        
//    }];
//    UIAlertAction *actionPayTM = [UIAlertAction actionWithTitle:@"PayTM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [self initializedPayTM];
//    }];
//    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }];
//    
//    [alertController addAction:actionPayU];
//    [alertController addAction:actionPayTM];
//    [alertController addAction:actionCancel];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
    
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSLog(@"oderHistoryModal.orderId = %@",self.orderId);
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc]init];
    
    if(NSSTRING_HAS_DATA(self.orderId)) {
        [dicData setValue:self.orderId forKey:kEY_orderid];
        [dicData setValue:self.orderId forKey:@"orderId"];
    }
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [dicData setValue:userModal.userId forKey:kEY_userid];
        [dicData setObject:userModal.userId forKey:@"CustId"];
    }
    
    
    [self showProgress];
    [[GMOperationalHandler handler] reorderItem:dicData withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
        
        
        if([responceData isKindOfClass:[NSDictionary class]]) {
            
            NSString *quoteId;
            if(HAS_KEY(responceData, @"QuoteId")) {
                [[GMSharedClass sharedClass] clearCart];
                quoteId = responceData[@"QuoteId"];
                GMUserModal *userModal = [GMUserModal loggedInUser];
                
                if(userModal) {
                    [userModal setQuoteId:quoteId];
                    [userModal persistUser];
                }
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
        }
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:@"Problem to reorder your order, Try again!"];
    }];
    
}


- (IBAction)actionPayByCashOnDelivery:(id)sender {
}
- (IBAction)actionContinueShopping:(id)sender {
    
     [self removeNotification];
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    [self.tabBarController setSelectedIndex:0];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}


-(void)paymentSuceessWithOrderId:(NSString*)orderId {
    GMOrderSuccessVC *successVC = [[GMOrderSuccessVC alloc] initWithNibName:@"GMOrderSuccessVC" bundle:nil];
    if(NSSTRING_HAS_DATA(orderId)) {
        successVC.orderId = orderId;
    }
    NSString *shippingPrice = @"0.00";
    NSString *totalPrice = @"0.00";
    
    if(NSSTRING_HAS_DATA(self.checkOutModal.cartDetailModal.shippingAmount)) {
    shippingPrice = [NSString stringWithFormat:@"%.2f",self.checkOutModal.cartDetailModal.shippingAmount.doubleValue];
    }
    totalPrice = [NSString stringWithFormat:@"%.2f", self.totalAmount];
    
    successVC.totalPrice = totalPrice;
    successVC.shippingCharge = shippingPrice;
    [self.navigationController pushViewController:successVC animated:YES];
}

/**
 PayU Implementation
 **/

- (void)initilizedpayUdata {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.myKey=[dict valueForKey:@"key"];
    self.offerKey = @"test123@6622";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success:) name:@"payment_success_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failure:) name:@"payment_failure_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel:) name:@"payu_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReceived:) name:@"passData" object:nil];
    //    [self.activity setHidesWhenStopped:YES];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payment_success_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payment_failure_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payu_notifications" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"passData" object:nil];
}
-(void)dataReceived:(NSNotification *)noti
{
    NSLog(@"dataReceived from surl/furl:%@", noti.object);
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:self animated:YES];
    
    
}

- (void) success:(NSDictionary *)info{
    
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.orderId)) {
        [orderDic setObject:self.orderId forKey:kEY_orderid];
    }
     [self removeNotification];
    [self showProgress];
    [[GMOperationalHandler handler] success:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self paymentSuceessWithOrderId:self.orderId];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self paymentSuceessWithOrderId:self.orderId];
        [self removeProgress];
    }];
    
}
- (void) failure:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
    
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.orderId)) {
        [orderDic setObject:self.orderId forKey:kEY_orderid];
    }
    [self showProgress];
    [[GMOperationalHandler handler] fail:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
    }];
    
}
- (void) cancel:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.orderId)) {
        [orderDic setObject:self.orderId forKey:kEY_orderid];
    }
    [self showProgress];
    [[GMOperationalHandler handler] fail:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
    }];
    [self.navigationController popToViewController:self animated:YES];
}


- (void) createHeashKey{
    
    [self showProgress];
    [self generateHashFromServer:nil withCompletionBlock:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(connectionError == nil && data != nil) {
                [self withoutUserDefinedModeBtnClick];
            } else {
                [[GMSharedClass sharedClass] showErrorMessage:@"Problem to genrate hash for payU."];
            }
            [self removeProgress];
        });
        NSLog(@"-->>Hash has been created = %@",_hashDict);
    }];
}
- (void) generateHashFromServer:(NSDictionary *) paramDict withCompletionBlock:(urlRequestCompletionBlock)completionBlock{
    void(^serverResponseForHashGenerationCallback)(NSURLResponse *response, NSData *data, NSError *error) = completionBlock;
    _hashDict=nil;
    
    //    PayUPaymentOptionsViewController *paymentOptionsVC = nil;
    
    
    [[GMOperationalHandler handler] getMobileHash:[self getPayUHashParameterDictionary] withSuccessBlock:^(id responceData) {
        if(responceData != nil) {
            
            _hashDict = responceData;
            serverResponseForHashGenerationCallback(responceData, responceData,nil);
            
        } else {
            serverResponseForHashGenerationCallback(nil, nil,nil);
        }
        
    } failureBlock:^(NSError *error) {
        serverResponseForHashGenerationCallback(nil, nil,error);
    }];
    
    
}


-(void) withoutUserDefinedModeBtnClick{
    
    PayUPaymentOptionsViewController *paymentOptionsVC = [[PayUPaymentOptionsViewController alloc] initWithNibName:@"PayUPaymentOptionsViewController" bundle:nil];
    
    //    [self.totalPriceLbl setText:[NSString stringWithFormat:@"$%.2f", grandTotal]];
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *userId = @"test";
    NSString *emailId = @"deepaksoni01@gmail.com";
    NSString *mobileNo = @"9999999999";
    NSString *name = @"deepaksoni";
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        userId = userModal.userId;
    }
    if(NSSTRING_HAS_DATA(userModal.email)) {
        emailId = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        mobileNo = userModal.mobile;
    }
    if(NSSTRING_HAS_DATA(userModal.firstName)) {
        name = userModal.firstName;
    }
    NSString *sucessString = [NSString stringWithFormat:@"%@.php?orderid=%@",[GMApiPathGenerator successPath],self.txnID];
    NSString *failString = [NSString stringWithFormat:@"%@.php?orderid=%@",[GMApiPathGenerator failPath],self.txnID];
    
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: PayU_Product_Info,@"productinfo",
                                      emailId,@"firstname",
                                      [NSString stringWithFormat:@"%.2f",self.totalAmount],@"amount",
                                      emailId,@"email",
                                      mobileNo, @"phone",
                                      sucessString,@"surl",
                                      failString,@"furl",
                                      self.txnID,@"txnid",PayU_Cridentail
                                      ,@"user_credentials",
                                      PayU_Key,kEY_PayU_Key,
                                      nil];
    
    //    yPnUG6:test
    paymentOptionsVC.parameterDict = paramDict;
    paymentOptionsVC.callBackDelegate = self;
    paymentOptionsVC.totalAmount  = self.totalAmount;//[totalAmount floatValue];
    paymentOptionsVC.appTitle     = @"GrocerMax Payment";
    if(_hashDict)
        paymentOptionsVC.allHashDict = _hashDict;
    [self.navigationController pushViewController:paymentOptionsVC animated:YES];
    self.navigationController.navigationBarHidden = FALSE;
}


#pragma mark - PayU Hash Paramter

- (NSDictionary *)payUHashParameterDictionary{
    
    NSMutableDictionary *payUParameterDic = [[NSMutableDictionary alloc]init];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *userId = @"test";
    NSString *emailId = @"deepaksoni01@gmail.com";
    NSString *mobileNo = @"9999999999";
    NSString *name = @"deepaksoni";
    
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        userId = userModal.userId;
    }
    if(NSSTRING_HAS_DATA(userModal.email)) {
        emailId = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        mobileNo = userModal.mobile;
    }
    if(NSSTRING_HAS_DATA(userModal.firstName)) {
        name = userModal.firstName;
    }
    NSString *sucessString = [NSString stringWithFormat:@"%@.php?orderid=%@",[GMApiPathGenerator successPath],self.txnID];
    NSString *failString = [NSString stringWithFormat:@"%@.php?orderid=%@",[GMApiPathGenerator failPath],self.txnID];
    
    [payUParameterDic setObject:PayU_Key forKey:kEY_PayU_Key];
    [payUParameterDic setObject:emailId forKey:kEY_PayU_Email];
    [payUParameterDic setObject:name forKey:kEY_PayU_Fname];
    [payUParameterDic setObject:mobileNo forKey:kEY_PayU_Phone];
    [payUParameterDic setObject:self.txnID forKey:kEY_PayU_Txnid];
    [payUParameterDic setObject:PayU_Product_Info forKey:kEY_PayU_Productinfo];
    [payUParameterDic setObject:PayU_Cridentail forKey:kEY_PayU_User_Credentials];
    [payUParameterDic setObject:failString forKey:kEY_PayU_Furl];
    [payUParameterDic setObject:sucessString forKey:kEY_PayU_Surl];
    [payUParameterDic setObject:[NSString stringWithFormat:@"%.2f",self.totalAmount] forKey:kEY_PayU_Amount];
    
    
    return payUParameterDic;
}

- (NSDictionary *)getPayUHashParameterDictionary{
    
    NSMutableDictionary *payUParameterDic = [[NSMutableDictionary alloc]init];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *userId = @"test";
    NSString *emailId = @"deepaksoni01@gmail.com";
    NSString *mobileNo = @"8585990093";
    NSString *name = @"deepaksoni";
    
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        userId = userModal.userId;
    }
    if(NSSTRING_HAS_DATA(userModal.email)) {
        emailId = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        mobileNo = userModal.mobile;
    }
    if(NSSTRING_HAS_DATA(userModal.firstName)) {
        name = userModal.firstName;
    }
    
    [payUParameterDic setObject:emailId forKey:kEY_PayU_Email];
    [payUParameterDic setObject:emailId forKey:kEY_PayU_Fname];
    [payUParameterDic setObject:self.txnID forKey:kEY_PayU_Txnid];
    
    [payUParameterDic setObject:[NSString stringWithFormat:@"%.2f",self.totalAmount] forKey:kEY_PayU_Amount];
    
    
    return payUParameterDic;
}


- (void)initializedPayTM {
    PGMerchantConfiguration *merchant = [PGMerchantConfiguration defaultConfiguration];
    
//    merchant.clientSSLCertPath = [[NSBundle mainBundle] pathForResource:@"Certificate" ofType:@"p12"];
//    merchant.clientSSLCertPassword = @"grocermax1234567";
    
    merchant.merchantID = PAYTM_MERCHANT_ID;
    merchant.website = PAYTM_WEBSITE;
    merchant.industryID = PAYTM_INDUSTRYID;
    merchant.channelID = PAYTM_CHANNELID;
    
    merchant.checksumGenerationURL = PAYTM_CHECKSUMGENRATIONURL;
    merchant.checksumValidationURL = PAYTM_CHECKVALIDATIONURL;
    
    [self customerOrder];
    
}

- (void)customerOrder {
    self.navigationController.navigationBarHidden = NO;
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *userId = @"test";
    NSString *emailId = @"deepaksoni01@gmail.com";
    NSString *mobileNo = @"8585990093";
    
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        userId = userModal.userId;
    }
    if(NSSTRING_HAS_DATA(userModal.email)) {
        emailId = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        mobileNo = userModal.mobile;
    }
    
    PGOrder *order = [PGOrder orderForOrderID:self.txnID customerID:[NSString stringWithFormat:@"CUST_%@",userModal.userId] amount:[NSString stringWithFormat:@"%.2f",self.totalAmount] customerMail:emailId customerMobile:mobileNo];
    
    
    PGTransactionViewController *txtController = [[PGTransactionViewController alloc]initTransactionForOrder:order];
    
    txtController.serverType = eServerTypeProduction;
    txtController.merchant = [PGMerchantConfiguration defaultConfiguration];
    
    //    txtController.toolbarItems
    //    txtController.cancelButton
    
    txtController.delegate = self;
    [self.navigationController pushViewController:txtController animated:YES];
    
    
    
}

#pragma mark -PayTM PGTransactionDelegate Delegate Methods


- (void)didSucceedTransaction:(PGTransactionViewController *)controller
                     response:(NSDictionary *)response {
    
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.orderId)) {
        [orderDic setObject:self.orderId forKey:kEY_orderid];
    }
    [orderDic setObject:@"success" forKey:@"status"];
    if(NSSTRING_HAS_DATA(self.orderDBID)) {
        [orderDic setObject:self.orderDBID forKey:@"orderdbid"];
    }
    
    [self removeNotification];
    [self showProgress];
    
    [[GMOperationalHandler handler] successForPayTM:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self paymentSuceessWithOrderId:self.orderId];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self paymentSuceessWithOrderId:self.orderId];
        [self removeProgress];
    }];

    
}

//Called when a transaction is failed with any reason. response dictionary will be having details about failed Transaction.
- (void)didFailTransaction:(PGTransactionViewController *)controller
                     error:(NSError *)error
                  response:(NSDictionary *)response {
    
    [self failOrCancelPaymentByPayTm];
}

//Called when a transaction is Canceled by User. response dictionary will be having details about Canceled Transaction.
- (void)didCancelTransaction:(PGTransactionViewController *)controller
                       error:(NSError *)error
                    response:(NSDictionary *)response {
    [self failOrCancelPaymentByPayTm];
}

-(void)failOrCancelPaymentByPayTm {
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.orderId)) {
        [orderDic setObject:self.orderId forKey:kEY_orderid];
    }
    [orderDic setObject:@"canceled" forKey:@"status"];
    if(NSSTRING_HAS_DATA(self.orderDBID)) {
        [orderDic setObject:self.orderDBID forKey:@"orderdbid"];
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] failForPayTM:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
            [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        
            [self removeProgress];
    }];
    [self.navigationController popToViewController:self animated:YES];
    
}
@end
