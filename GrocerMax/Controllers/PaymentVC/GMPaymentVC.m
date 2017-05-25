//
//  GMPaymentVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentVC.h"
#import "GMStateBaseModal.h"
#import "GMOrderDetailHeaderView.h"
#import "GMPaymentCell.h"
#import "GMPaymentOrderSummryCell.h"
#import "GMCartDetailModal.h"
#import "GMOrderSuccessVC.h"
#import "GMCartRequestParam.h"
#import "GMCoupanCodeCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "GMGenralModal.h"
#import "GMCoupanCartDetail.h"
#import "GMApiPathGenerator.h"
#import "GMOrderFailVC.h"
#import "PayU_iOS_SDK.h"

#import "PGMerchantConfiguration.h"
#import "PGOrder.h"
#import "PGTransactionViewController.h"

#import "GMPaymentWayModal.h"
#import "InitialViewController.h"
#import "SignUpViewController.h"
#import "GMProfileVC.h"

//#define PayU_Cridentail   @"yPnUG6:test"
//
//#define PayU_Key   @"yPnUG6"
//#define PayU_Salt   @"jJ0mWFKl"
//
//
//#define PayU_Product_Info @"GrocerMax Product Info"


static NSString *kIdentifierPaymentCell = @"paymentIdentifierCell";
static NSString *kIdentifierPaymentSummuryCell = @"paymentSummeryIdentifierCell";
static NSString *kIdentifierCoupanCodeCell = @"coupanCodeIdentifierCell";
static NSString *kIdentifierPaymentHeader = @"paymentIdentifierHeader";

@interface GMPaymentVC ()<UITextFieldDelegate,PGTransactionDelegate>
{
    NSInteger selectedIndex;
    float totalAmount;
    NSString *coupanCode;
    NSString *orderID;
//    BOOL isPaymentFail;
    BOOL isMyWalletSelected;
    float paymentAmount;
}
@property (nonatomic,retain) PGMerchantConfiguration *merchant ;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *paymentTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITextField *couponCodeTextField;
@property (strong, nonatomic) NSMutableArray *paymentOptionArray;
@property (strong, nonatomic) GMButton *checkedBtn;
@property (strong, nonatomic) GMPaymentWayModal *selectedPaymentWayModal;

@property (strong, nonatomic) GMGenralModal *genralModal;
@property (strong, nonatomic) GMCoupanCartDetail *coupanCartDetail;

@property (weak, nonatomic) IBOutlet UILabel *youShavedLbl;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;

///
@property (nonatomic, strong) NSString *txnID;
@property (nonatomic, strong) NSDictionary *hashDict;
@property(nonatomic,strong) NSString *myKey;
@property(nonatomic,strong) NSString *offerKey;
typedef void (^urlRequestCompletionBlock)(NSURLResponse *response, NSData *data, NSError *connectionError);
///

@end

@implementation GMPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.paymentOptionArray = [[NSMutableArray alloc]initWithObjects:@"Cash on delivery",@"Credit / Debit card",@"Sodexho coupons",@"payU",@"mobikwik", nil];
//    self.paymentOptionArray = [[NSMutableArray alloc]initWithObjects:@"My Wallet",@"Cash on delivery",@"Online Payment (Credit/Debit card, Net Banking)",@"PayTM",@"Citrus Wallet", nil];
    self.paymentOptionArray = [[NSMutableArray alloc]init];
    [self setDefaultMethod];
    coupanCode = @"";
    [self getWalletDataFromServer];
    [self registerCellsForTableView];
    [self getPaymentWayFromServer];
    selectedIndex = -1;
    [self configerView];
    [self initilizedpayUdata];
    
    [self initializedPayTM];
    [self configureAmountView];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Payment Method";
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_CartPaymentMethod_Screen];
    
//    if(isPaymentFail) {
//        [self goToFailOrderScreen];
//    }
    
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
////    self.title = @"Payment Method";
//    self.navigationController.navigationBarHidden = NO;
//    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Register Cells
- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMPaymentCell" bundle:[NSBundle mainBundle]];
    [self.paymentTableView registerNib:nib forCellReuseIdentifier:kIdentifierPaymentCell];
    nib = [UINib nibWithNibName:@"GMPaymentOrderSummryCell" bundle:[NSBundle mainBundle]];
    [self.paymentTableView registerNib:nib forCellReuseIdentifier:kIdentifierPaymentSummuryCell];
    
    nib = [UINib nibWithNibName:@"GMCoupanCodeCell" bundle:[NSBundle mainBundle]];
    [self.paymentTableView registerNib:nib forCellReuseIdentifier:kIdentifierCoupanCodeCell];
    
    
    nib = [UINib nibWithNibName:@"GMOrderDetailHeaderView" bundle:[NSBundle mainBundle]];
    [self.paymentTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierPaymentHeader];
    
    
    
    //
}
-(void) configerView {
    if(self.checkOutModal.cartDetailModal.couponCode) {
        self.couponCodeTextField.text = self.checkOutModal.cartDetailModal.couponCode;
    }
    self.bottomView.layer.borderWidth = 1.0;
    self.bottomView.layer.borderColor = [UIColor colorWithRGBValue:236 green:236 blue:236].CGColor;
    self.bottomView.layer.cornerRadius = 2.0;
}

#pragma mark - Action Methods
- (IBAction)actionPaymentCash:(id)sender {
    
    
  
    
//    self.txnID = [self randomStringWithLength:17];
//    [self createHeashKey];
//    return ;
    if(![[GMSharedClass sharedClass] isInternetAvailable]) {
        [[GMSharedClass sharedClass] showErrorMessage:@"No internet connection. Please try again."];
        return;
    }
    GMUserModal *userModal = [GMUserModal loggedInUser];
    [self setAmoutDetuction];
    if(selectedIndex == -1 && !isMyWalletSelected) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please select mode of payment."];
        return;
    } else if(selectedIndex == -1 && isMyWalletSelected) {
        
        if(!NSSTRING_HAS_DATA(userModal.balenceInWallet) || [userModal.balenceInWallet floatValue]<totalAmount) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Wallet balance insufficient. Please select another payment option to place order."];
            return;
        }
    } else if(selectedIndex != -1 && isMyWalletSelected) {
        
        
        if(NSSTRING_HAS_DATA(userModal.balenceInWallet) && [userModal.balenceInWallet floatValue]>totalAmount) {
            [[GMSharedClass sharedClass] showErrorMessage:@"Sufficient balance in the wallet. Please select only wallet as payment mode."];
            return;
        }
    }
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_PlaceOrder withCategory:@"" label:nil value:nil];
    
    NSDictionary *checkOutDic = [[GMCartRequestParam sharedCartRequest] finalCheckoutParameterDictionaryFromCheckoutModal:self.checkOutModal];
    if(selectedIndex == 2) {
        if(NSSTRING_HAS_DATA(self.checkedBtn.paymentWayModal.paymentMethodNameCode)){
            [checkOutDic setValue:self.checkedBtn.paymentWayModal.paymentMethodNameCode forKey:kEY_payment_method];
        } else {
            [checkOutDic setValue:@"payucheckout_shared" forKey:kEY_payment_method];
        }
        if(self.genralModal) {
            [self createHeashKey];
            return;
        }
    }else if(selectedIndex == 3) {
        if(NSSTRING_HAS_DATA(self.checkedBtn.paymentWayModal.paymentMethodNameCode)){
            [checkOutDic setValue:self.checkedBtn.paymentWayModal.paymentMethodNameCode forKey:kEY_payment_method];
        } else {
            [checkOutDic setValue:@"paytm_cc" forKey:kEY_payment_method];
        }
        
        if(self.genralModal) {
            [self initializedPayTM];
            return;
        }

    }
    else if(selectedIndex == 1) {
        if(NSSTRING_HAS_DATA(self.checkedBtn.paymentWayModal.paymentMethodNameCode)){
            [checkOutDic setValue:self.checkedBtn.paymentWayModal.paymentMethodNameCode forKey:kEY_payment_method];
        } else {
            [checkOutDic setValue:@"cashondelivery" forKey:kEY_payment_method];
        }
//        [checkOutDic setValue:@"cashondelivery" forKey:kEY_payment_method];
    }else if(selectedIndex == 4) {
        if(NSSTRING_HAS_DATA(self.checkedBtn.paymentWayModal.paymentMethodNameCode)){
            [checkOutDic setValue:self.checkedBtn.paymentWayModal.paymentMethodNameCode forKey:kEY_payment_method];
        } else {
            [checkOutDic setValue:@"moto" forKey:kEY_payment_method];
        }
//        [checkOutDic setValue:@"moto" forKey:kEY_payment_method];
        
    }
    
    if(isMyWalletSelected) {
        
        NSString *paymentCodeForWallet = @"";
        for(int i = 0;i< [self.paymentOptionArray count]; i++){
            GMPaymentWayModal *paymentWayModal = [self.paymentOptionArray objectAtIndex:i];
            if([paymentWayModal.paymentMethodId isEqualToString:@"1"]){
                paymentCodeForWallet = paymentWayModal.paymentMethodNameCode;
                break;
            }
        }
        if(NSSTRING_HAS_DATA(paymentCodeForWallet)) {
            [checkOutDic setValue:paymentCodeForWallet forKey:kEY_payment_method_ByWallet];
        } else {
            [checkOutDic setValue:@"customercredit" forKey:kEY_payment_method_ByWallet];
        }
        
        [checkOutDic setValue:@"1" forKey:kEY_IS_PaymentFrom_Wallet];
        [checkOutDic setValue:[NSString stringWithFormat:@"%.2f",[userModal.balenceInWallet floatValue]] forKey:kEY_IS_InterNalWallet_Amount];
        [checkOutDic setValue:[NSString stringWithFormat:@"%.2f",totalAmount] forKey:kEY_IS_Total_paid_Amount];
    }
    
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Review and Place order" label:@""];
    
    
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.userId)){
        [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
        [qaGrapEventDic setObject:[self paymentOptions] forKey:kEY_QA_EventParmeter_PaymentOption];
    
    if(totalAmount){
        [qaGrapEventDic setObject:[NSString stringWithFormat:@"%.2f",totalAmount] forKey:kEY_QA_EventParmeter_Subtotal];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_CheckOutPlaceOrder withExtraParameter:qaGrapEventDic];
    
    
    [self showProgress];
    [[GMOperationalHandler handler] checkout:checkOutDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        self.genralModal = responceData;
        [self removeProgress];
        
        switch (responceData.flag) {
            case 1: {
                
                NSString *userName = @"";
                GMUserModal *userModal = [GMUserModal loggedInUser];
                if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName) && NSSTRING_HAS_DATA(userModal.userId)){
                    userName = [NSString stringWithFormat:@"%@/%@",userModal.firstName,userModal.userId];
                    
                }else if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName)){
                    userName = [NSString stringWithFormat:@"%@",userModal.firstName];
                }else if(userModal != nil && NSSTRING_HAS_DATA(userModal.userId)){
                    userName = [NSString stringWithFormat:@"%@",userModal.userId];
                }
                
                
                [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Payment_Method withCategory:kEY_GA_Category_Checkout_Funnel label:userName];
                
                if(NSSTRING_HAS_DATA(responceData.orderAmount)){
                    [[GMSharedClass sharedClass] clearCart];
                    [self.tabBarController updateBadgeValueOnCartTab];
                    if(selectedIndex == 1 || (selectedIndex == -1 && isMyWalletSelected)) {
                        [self paymentSuceessWithOrderId:responceData.orderID];
                        
                    } else if(selectedIndex == 2) {
                        //[self initilizedpayUdata];
                        if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
                            self.txnID = self.genralModal.orderID;
                        } else {
                            self.txnID = [self randomStringWithLength:17];
                        }
                        [self createHeashKey];
                    } else if(selectedIndex == 3) {
                        if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
                            [self customerOrder];
                        }
                    } else if(selectedIndex == 4) {
                        if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
                            [self payByCitrusWallet];
                            
                        }
                    }
                }
            }
                break;
                
            case 2:
                
                //Order History Page
            {
                
                NSString *titleString = @"";
                 NSString *buttonTitle = @"";
                if(NSSTRING_HAS_DATA(responceData.result)){
                    titleString = responceData.result;
                }else{
                    titleString = @"Order already placed same item show please check order history.";
                }
                
                if(NSSTRING_HAS_DATA(responceData.buttonTitle)){
                    buttonTitle = responceData.buttonTitle;
                }else{
                    buttonTitle = @"Ok";
                }
                
                UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:titleString preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [[GMSharedClass sharedClass] clearCart];
                    [self.tabBarController updateBadgeValueOnCartTab];
                    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
                    [self.tabBarController setSelectedIndex:1];
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    GMProfileVC *profileVC = [APP_DELEGATE rootProfileVCFromSecondTab];
                    
                    
                    if([profileVC respondsToSelector:@selector(goOrderHistoryList)]){
                        [profileVC goOrderHistoryList];
                    } else {
                        GMProfileVC *profileVC = [[GMProfileVC alloc] initWithNibName:@"GMProfileVC" bundle:nil];
                        UIImage *profileVCTabImg = [[UIImage imageNamed:@"profile_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
                        UIImage *profileVCTabSelectedImg = [[UIImage imageNamed:@"profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
                        profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:profileVCTabImg selectedImage:profileVCTabSelectedImg];
                        [self adjustShareInsets:profileVC.tabBarItem];
                        [[self.tabBarController.viewControllers objectAtIndex:1] setViewControllers:@[profileVC] animated:YES];
                        [profileVC goOrderHistoryList];
                    }
                }];
                
                [alertController addAction:actionOK];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                
                break;
            case 3:
            {
                NSString *titleString = @"";
                NSString *buttonTitle = @"";
                if(NSSTRING_HAS_DATA(responceData.result)){
                    titleString = responceData.result;
                }else{
                    titleString = @"Session is Exprie.";
                }
                
                
                if(NSSTRING_HAS_DATA(responceData.buttonTitle)){
                    buttonTitle = responceData.buttonTitle;
                }else{
                    buttonTitle = @"Ok";
                }
                UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:titleString preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
                [alertController addAction:actionOK];
                [self presentViewController:alertController animated:YES completion:nil];
        }
                break;
            default:
                [[GMSharedClass sharedClass] showErrorMessage:responceData.result];
                break;
        }
        
//        if(responceData.flag == 1) {
//            [[GMSharedClass sharedClass] clearCart];
//            [self.tabBarController updateBadgeValueOnCartTab];
//            if(selectedIndex == 1 || (selectedIndex == -1 && isMyWalletSelected)) {
//                [self paymentSuceessWithOrderId:responceData.orderID];
//                
//            } else if(selectedIndex == 2) {
//                //[self initilizedpayUdata];
//                if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
//                   self.txnID = self.genralModal.orderID;
//                } else {
//                self.txnID = [self randomStringWithLength:17];
//                }
//                [self createHeashKey];
//            } else if(selectedIndex == 3) {
//                if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
//                    [self customerOrder];
//                }
//            } else if(selectedIndex == 4) {
//                if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
//                    [self payByCitrusWallet];
//                    
//                }
//            }
//        } else {
//            [[GMSharedClass sharedClass] showErrorMessage:responceData.result];
//        }
        
    } failureBlock:^(NSError *error) {
        
        if(selectedIndex == 1 || (selectedIndex == -1 && isMyWalletSelected)) {
            [self paymentSuceessWithOrderId:nil];
        } else {
            [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        }
        
        [self removeProgress];
    }];
    
    
}

- (void)actionApplyCoponCode:(id)sender {
    
    if( NSSTRING_HAS_DATA(self.checkOutModal.cartDetailModal.couponCode) && !NSSTRING_HAS_DATA(coupanCode))  {
        coupanCode = self.checkOutModal.cartDetailModal.couponCode;
    }
    
    if(self.coupanCartDetail || NSSTRING_HAS_DATA(self.checkOutModal.cartDetailModal.couponCode)) {
        
        [self removeCouponCode];
        return;
    }
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CodeApplied withCategory:@"" label:coupanCode value:nil];
    
    [self.view endEditing:YES];
//    self.txnID = [self randomStringWithLength:17];
//    [self createHeashKey];
//    return;
    if(!NSSTRING_HAS_DATA(coupanCode)) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please enter coupon code."];
        return;
    }
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    GMUserModal *userModal = [GMUserModal loggedInUser];
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [userDic setObject:userModal.userId forKey:kEY_userid];
    }
    if(NSSTRING_HAS_DATA(userModal.quoteId)) {
        [userDic setObject:userModal.quoteId forKey:kEY_quote_id];
    }
    if(NSSTRING_HAS_DATA(coupanCode)) {
        [userDic setObject:coupanCode forKey:kEY_couponcode];
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] addCoupon:userDic  withSuccessBlock:^(GMCoupanCartDetail *responceData) {
        self.coupanCartDetail = responceData;
//        [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is appyed."];
        [self.paymentTableView reloadData];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is not valid."];
        [self removeProgress];
    }];
    
}

- (void)removeCouponCode {
    
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    GMUserModal *userModal = [GMUserModal loggedInUser];
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [userDic setObject:userModal.userId forKey:kEY_userid];
    }
    if(NSSTRING_HAS_DATA(userModal.quoteId)) {
        [userDic setObject:userModal.quoteId forKey:kEY_quote_id];
    }
    if(NSSTRING_HAS_DATA(coupanCode)) {
        [userDic setObject:coupanCode forKey:kEY_couponcode];
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] removeCoupon:userDic  withSuccessBlock:^(NSDictionary *responceData) {
        
        
        NSString *message = @"";
        if([responceData objectForKey:@"Result"]) {
            message = [responceData objectForKey:@"Result"];
        }
        if([[responceData objectForKey:@"flag"] intValue] == 1) {
            if(!NSSTRING_HAS_DATA(message)) {
                message = @"Coupon remove sucessfully.";
            }
            [[GMSharedClass sharedClass] showErrorMessage:message];
            self.coupanCartDetail = nil;
            self.checkOutModal.cartDetailModal.couponCode = @"";
            self.checkOutModal.cartDetailModal.discountAmount = @"0.0";
            [self.paymentTableView reloadData];
        }else {
            if(!NSSTRING_HAS_DATA(message)) {
                message = @"Coupon is not valid.";
            }
            [[GMSharedClass sharedClass] showErrorMessage:message];
        }
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Coupon is not valid."];
        [self removeProgress];
    }];
}

- (void)actionCheckedBtnClicked:(GMButton *)sender {
    
    if(sender.selected) {
        sender.selected = FALSE;
        if(sender.tag != 0) {
            selectedIndex = -1;
        } else {
            isMyWalletSelected = FALSE;
            [self.paymentTableView reloadData];
            return;
        }
        
    }
    else {
        
        
        if(sender.tag == 0) {
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_PaymentModeSelect withCategory:@"" label:kEY_GA_Event_Wallet value:nil];
            sender.selected = YES;
            isMyWalletSelected = YES;
            [self.paymentTableView reloadData];
            return;
        }
        
        if(self.checkedBtn) {
            self.checkedBtn.selected = NO;
        }
        selectedIndex = sender.tag;
        sender.selected = YES;
        
        if(selectedIndex == 1) {
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_PaymentModeSelect withCategory:@"" label:kEY_GA_Event_CashOnDelivery value:nil];
        } else if(selectedIndex == 2){
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_PaymentModeSelect withCategory:@"" label:kEY_GA_Event_PayU value:nil];
        } else if(selectedIndex == 3){
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_PaymentModeSelect withCategory:@"" label:kEY_GA_Event_PayTM value:nil];
        } else if(selectedIndex == 4){
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_PaymentModeSelect withCategory:@"" label:kEY_GA_Event_Citrus value:nil];
        }
    }
    self.checkedBtn = sender;
    
}

-(void)paymentSuceessWithOrderId:(NSString*)orderId {
    GMOrderSuccessVC *successVC = [[GMOrderSuccessVC alloc] initWithNibName:@"GMOrderSuccessVC" bundle:nil];
    if(NSSTRING_HAS_DATA(orderId)) {
        successVC.orderId = orderId;
    }
    NSString *shippingPrice = @"0.00";
    NSString *totalPrice = @"0.00";
    
    if(self.coupanCartDetail) {
        if(NSSTRING_HAS_DATA(self.coupanCartDetail.ShippingCharge)) {
            shippingPrice = [NSString stringWithFormat:@"%.2f",self.coupanCartDetail.ShippingCharge.doubleValue];
        }
        if(NSSTRING_HAS_DATA(self.coupanCartDetail.grand_total)) {
            totalPrice = [NSString stringWithFormat:@"%.2f",self.coupanCartDetail.grand_total.doubleValue];
        }
    }
    else {
        shippingPrice = [NSString stringWithFormat:@"%.2f",self.checkOutModal.cartDetailModal.shippingAmount.doubleValue];
        
        double saving = 0;
        double subtotal = 0;
        double couponDiscount = 0;
        for (GMProductModal *productModal in self.checkOutModal.cartDetailModal.productItemsArray) {
            
            saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
            subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
        }
        if(NSSTRING_HAS_DATA(self.checkOutModal.cartDetailModal.discountAmount)) {
            saving = saving - self.checkOutModal.cartDetailModal.discountAmount.doubleValue;
            couponDiscount = self.checkOutModal.cartDetailModal.discountAmount.doubleValue;;
        }
        double grandTotal = subtotal + self.checkOutModal.cartDetailModal.shippingAmount.doubleValue;
        if(couponDiscount>0.01) {
            grandTotal = grandTotal - couponDiscount;
        } else {
            grandTotal = grandTotal + couponDiscount;
        }
        totalPrice = [NSString stringWithFormat:@"%.2f", grandTotal];
    }
    successVC.totalPrice = totalPrice;
    successVC.shippingCharge = shippingPrice;
    successVC.paymentOption = [self paymentOptions];
    
    [self.navigationController pushViewController:successVC animated:YES];
}


- (void)configureAmountView {
    
    if(self.checkOutModal.cartDetailModal.shippingAmount.doubleValue <= 0) {
        [self.totalPriceLbl setText:[NSString stringWithFormat:@""]];
    }else{
        [self.totalPriceLbl setText:[NSString stringWithFormat:@"Shipping: ₹%.2f\n", self.self.checkOutModal.cartDetailModal.shippingAmount.doubleValue]];
    }
    [self.totalPriceLbl setText:[NSString stringWithFormat:@"%@Total: ₹%.2f", self.totalPriceLbl.text,self.checkOutModal.cartDetailModal.grandTotal.doubleValue]];
    
    double savingAmount = [self getSavedAmount];
    [self.youShavedLbl setText:[NSString stringWithFormat:@"₹%.2f", savingAmount]];
    
}

- (double)getSavedAmount {
    
    double saving = 0;
    for (GMProductModal *productModal in self.checkOutModal.cartDetailModal.productItemsArray) {
        
        saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
    }
    if(NSSTRING_HAS_DATA(self.checkOutModal.cartDetailModal.discountAmount))
        saving = saving - self.checkOutModal.cartDetailModal.discountAmount.doubleValue;
    return saving;
}


- (void) configerViewData:(GMCartDetailModal *)cartDetailModal coupanCartDetail:(GMCoupanCartDetail *)coupanCartDetail {
    
    
    
}

#pragma mark - keyword hide

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField {
    coupanCode = textField.text;
}
#pragma mark - TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        return self.paymentOptionArray.count;
    }
    else if(section == 1) {
        return 1;
    } else if(section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        GMPaymentCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierPaymentCell];
        
        [paymentCell configerViewData:[self.paymentOptionArray objectAtIndex:indexPath.row]];
        if(self.paymentOptionArray.count== indexPath.row+1) {
            paymentCell.bottomHorizentalSepretorLbl.hidden = FALSE;
        }
        [paymentCell.checkBoxBtn addTarget:self action:@selector(actionCheckedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return paymentCell;
    }
    else if(indexPath.section == 1) {
        GMPaymentOrderSummryCell *paymentOrderSummryCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierPaymentSummuryCell];
        
        paymentOrderSummryCell.tag = indexPath.row;
        [paymentOrderSummryCell configerViewData:self.checkOutModal.cartDetailModal coupanCartDetail:self.coupanCartDetail isWalet:isMyWalletSelected];
        return paymentOrderSummryCell;
    }
    else if(indexPath.section == 2) {
        GMCoupanCodeCell *coupanCodeCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierCoupanCodeCell];
        coupanCodeCell.tag = indexPath.row;
        coupanCodeCell.coupanCodeTextField.delegate = self;
        [coupanCodeCell.applyCodeBtn addTarget:self action:@selector(actionApplyCoponCode:) forControlEvents:UIControlEventTouchUpInside];
        [coupanCodeCell.applyCodeBtn setExclusiveTouch:YES];
        [coupanCodeCell configerView:self.coupanCartDetail carDetail:self.checkOutModal.cartDetailModal];
        return coupanCodeCell;
    }
    return nil;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return 45.0;
        //        [GMPaymentCell cellHeight];
    } else if(indexPath.section == 1) {
        return [GMPaymentOrderSummryCell cellHeightWithCartDetail:self.checkOutModal.cartDetailModal andCouponCartDetail:self.coupanCartDetail isWalet:isMyWalletSelected];
    }
    else if(indexPath.section == 2) {
//        [GMCoupanCodeCell cellHeight];
        return 48;
    }
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 42.0f;
    } else if(section == 1) {
        return 42.0f;
    } else  {
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0 || section == 1) {
        UIView *headerView;
        GMOrderDetailHeaderView *header  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierPaymentHeader];
        if (!header) {
            header = [[GMOrderDetailHeaderView alloc] initWithReuseIdentifier:kIdentifierPaymentHeader];
        }
        [header.headerBgView setBackgroundColor:[UIColor clearColor]];
        if(section == 0 ) {
            [header congigerHeaderData:@"SELECT MODE OF PAYMENT"];
        } else if(section == 1 ) {
            [header congigerHeaderData:@"ORDER SUMMARY"];
        } else {
            [header congigerHeaderData:@""];
        }
        headerView = header;
        
        return headerView;
    }
    else {
        
        return nil;
    }
}

- (void) goToFailOrderScreen {
    [self removeNotification];
//    if(isPaymentFail) {
//        isPaymentFail = FALSE;
    GMOrderFailVC *orderFailVC = [GMOrderFailVC new];
    orderFailVC.orderId = self.genralModal.orderID;
    orderFailVC.orderDBID = self.genralModal.orderDBID;
    orderFailVC.totalAmount = totalAmount;
    orderFailVC.paymentOption = [self paymentOptions];
    [self.navigationController pushViewController:orderFailVC animated:NO];
//    }
}


-(NSString *)paymentOptions{
    NSString *paymentName = @"";
    
    if(selectedIndex == 1) {
        paymentName = kEY_GA_Event_CashOnDelivery;
    } else if(selectedIndex == 2){
        paymentName = kEY_GA_Event_PayU;
    } else if(selectedIndex == 3){
        paymentName = kEY_GA_Event_PayTM;
    } else if(selectedIndex == 4){
        paymentName = kEY_GA_Event_Citrus;
    }
    
    if(isMyWalletSelected) {
        paymentName = [NSString stringWithFormat:@"My Wallet and %@",paymentName];
    }
    return paymentName;
}

-(void)payByCitrusWallet {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success:) name:payment_success_notifications_ByCitrus object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failure:) name:payment_failure_notifications_ByCitrus object:nil];
    
    SignUpViewController *signUpViewController = [[SignUpViewController alloc]init];
    
    [self setAmoutDetuction];
    signUpViewController.orderId = self.genralModal.orderID;
    signUpViewController.totalPrice = [NSString stringWithFormat:@"%.2f", paymentAmount];
    signUpViewController.shippingAddressModal = self.checkOutModal.shippingAddressModal;
    [self.navigationController pushViewController:signUpViewController animated:YES];
//    isPaymentFail = TRUE;
    
    
//    InitialViewController *initialViewController = [[InitialViewController alloc]init];
//    [self setAmoutDetuction];
//    initialViewController.orderId = self.genralModal.orderID;
//    initialViewController.totalPrice = [NSString stringWithFormat:@"%.2f", paymentAmount];
//    initialViewController.shippingAddressModal = self.checkOutModal.shippingAddressModal;
//    [self.navigationController pushViewController:initialViewController animated:YES];
//    isPaymentFail = TRUE;
}
- (void)removeNotificationByCitrus {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payment_success_notifications_ByCitrus" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payment_failure_notifications_ByCitrus" object:nil];
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
//    [self.navigationController popToViewController:self animated:YES];
    
   
}

- (void) success:(NSDictionary *)info{
    
//    isPaymentFail = FALSE;
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
        [orderDic setObject:self.genralModal.orderID forKey:kEY_orderid];
    }
    [self showProgress];
    [[GMOperationalHandler handler] success:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        //[self.navigationController popToRootViewControllerAnimated:NO];
        [self paymentSuceessWithOrderId:self.genralModal.orderID];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
//        [self.navigationController popToRootViewControllerAnimated:NO];
        [self paymentSuceessWithOrderId:self.genralModal.orderID];
        [self removeProgress];
    }];
    
}
- (void) failure:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
    [self failOrCancelPaymentByPayTm];
//    isPaymentFail = TRUE;
//    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
//    if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
//        [orderDic setObject:self.genralModal.orderID forKey:kEY_orderid];
//    }
//    [self showProgress];
//    [[GMOperationalHandler handler] fail:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
//        
//        [self removeProgress];
//        
//    } failureBlock:^(NSError *error) {
//        
//        [self removeProgress];
//    }];
//    [self goToFailOrderScreen];
    
}
- (void) cancel:(NSDictionary *)info{
    NSLog(@"failure Dict: %@",info);
//    [self.navigationController popToRootViewControllerAnimated:NO];
    [self failOrCancelPaymentByPayTm];
    
//    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
//    if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
//        [orderDic setObject:self.genralModal.orderID forKey:kEY_orderid];
//    }
//    [self showProgress];
//    [[GMOperationalHandler handler] fail:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
//        
//        
//        [self removeProgress];
//        
//        
//    } failureBlock:^(NSError *error) {
//        
//        [self removeProgress];
//    }];
//    [self goToFailOrderScreen];
    
}
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength:(int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
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
//        NSLog(@"-->>Hash has been created = %@",_hashDict);
    }];
}
- (void) generateHashFromServer:(NSDictionary *) paramDict withCompletionBlock:(urlRequestCompletionBlock)completionBlock{
    void(^serverResponseForHashGenerationCallback)(NSURLResponse *response, NSData *data, NSError *error) = completionBlock;
    _hashDict=nil;

//    PayUPaymentOptionsViewController *paymentOptionsVC = nil;
    
    
    [[GMOperationalHandler handler] getMobileHash:[self getPayUHashParameterDictionary] withSuccessBlock:^(id responceData) {
        if(responceData != nil) {
            
//                paymentOptionsVC.allHashDict = responceData;
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
    
    [self setAmoutDetuction];
    
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
                                      [NSString stringWithFormat:@"%.2f",paymentAmount],@"amount",
                                      emailId,@"email",
                                      mobileNo, @"phone",
                                      sucessString,@"surl",
                                      failString,@"furl",
                                      self.txnID,@"txnid",PayU_Cridentail
                                    ,@"user_credentials",
//                                      @"u1",@"udf1",
//                                      @"u2",@"udf2",
//                                      @"u3",@"udf3",
//                                      @"u4",@"udf4",
//                                      @"u5",@"udf5",
                                      PayU_Key,kEY_PayU_Key,
                                      nil];
    
//    yPnUG6:test
    paymentOptionsVC.parameterDict = paramDict;
    paymentOptionsVC.callBackDelegate = self;
    paymentOptionsVC.totalAmount  = paymentAmount;//[totalAmount floatValue];
    paymentOptionsVC.appTitle     = @"GrocerMax Payment";
    if(_hashDict)
        paymentOptionsVC.allHashDict = _hashDict;
    [self.navigationController pushViewController:paymentOptionsVC animated:YES];
//    isPaymentFail = TRUE;
}


#pragma mark - PayU Hash Paramter

- (NSDictionary *)payUHashParameterDictionary{
    
    NSMutableDictionary *payUParameterDic = [[NSMutableDictionary alloc]init];
    
    [self setAmoutDetuction];
    
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
    [payUParameterDic setObject:[NSString stringWithFormat:@"%.2f",paymentAmount] forKey:kEY_PayU_Amount];
    
    
    return payUParameterDic;
}

- (NSDictionary *)getPayUHashParameterDictionary{
    
    NSMutableDictionary *payUParameterDic = [[NSMutableDictionary alloc]init];
    
    [self setAmoutDetuction];
    
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
//    NSString *sucessString = [NSString stringWithFormat:@"%@?orderid=%@",[GMApiPathGenerator successPath],self.txnID];
//    NSString *failString = [NSString stringWithFormat:@"%@?orderid=%@",[GMApiPathGenerator failPath],self.txnID];
    
//    [payUParameterDic setObject:PayU_Key forKey:kEY_PayU_Key];
    [payUParameterDic setObject:emailId forKey:kEY_PayU_Email];
    [payUParameterDic setObject:emailId forKey:kEY_PayU_Fname];
//    [payUParameterDic setObject:mobileNo forKey:kEY_PayU_Phone];
    [payUParameterDic setObject:self.txnID forKey:kEY_PayU_Txnid];
//    [payUParameterDic setObject:PayU_Product_Info forKey:kEY_PayU_Productinfo];
//    [payUParameterDic setObject:PayU_Cridentail forKey:kEY_PayU_User_Credentials];
//    [payUParameterDic setObject:failString forKey:kEY_PayU_Furl];
//    [payUParameterDic setObject:sucessString forKey:kEY_PayU_Surl];
    [payUParameterDic setObject:[NSString stringWithFormat:@"%.2f",paymentAmount] forKey:kEY_PayU_Amount];
//    [payUParameterDic setObject:PayU_Salt forKey:@"salt"];
    
    
    return payUParameterDic;
}





- (void)initializedPayTM {
    self.merchant = [PGMerchantConfiguration defaultConfiguration];
    
//    merchant.clientSSLCertPath = [[NSBundle mainBundle] pathForResource:@"Certificate" ofType:@"p12"];
//    merchant.clientSSLCertPassword = @"grocermax1234567";
    
    self.merchant.merchantID = PAYTM_MERCHANT_ID;
    self.merchant.website = PAYTM_WEBSITE;
    self.merchant.industryID = PAYTM_INDUSTRYID;
    self.merchant.channelID = PAYTM_CHANNELID;
    self.merchant.theme = @"merchant";
    
    self.merchant.checksumGenerationURL = PAYTM_CHECKSUMGENRATIONURL;
    self.merchant.checksumValidationURL = PAYTM_CHECKVALIDATIONURL;
    
//    [self customerOrder];
    
}

- (void)customerOrder {
//    isPaymentFail = TRUE;
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSString *userId = @"test";
    NSString *emailId = @"deepaksoni01@gmail.com";
    NSString *mobileNo = @"8585990093";
    
    [self setAmoutDetuction];
    
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        userId = userModal.userId;
    }
    if(NSSTRING_HAS_DATA(userModal.email)) {
        emailId = userModal.email;
    }
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        mobileNo = userModal.mobile;
    }
    
    PGOrder *order = [PGOrder orderForOrderID:self.genralModal.orderID customerID:userModal.userId amount:[NSString stringWithFormat:@"%.2f",paymentAmount] customerMail:emailId customerMobile:mobileNo];
    
    
    PGTransactionViewController *txtController = [[PGTransactionViewController alloc]initTransactionForOrder:order];
    
    txtController.serverType = eServerTypeProduction;
    txtController.merchant = self.merchant;//[PGMerchantConfiguration defaultConfiguration];
    
//    txtController.toolbarItems
//    txtController.cancelButton
    
    txtController.delegate = self;
//    txtController.view.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    [self.navigationController pushViewController:txtController animated:YES];
    
    
    
}

#pragma mark -PayTM PGTransactionDelegate Delegate Methods


- (void)didSucceedTransaction:(PGTransactionViewController *)controller
                     response:(NSDictionary *)response {
    
//    isPaymentFail = FALSE;
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
        [orderDic setObject:self.genralModal.orderID forKey:kEY_orderid];
    }
    [orderDic setObject:@"success" forKey:@"status"];
    if(NSSTRING_HAS_DATA(self.genralModal.orderDBID)) {
        [orderDic setObject:self.genralModal.orderDBID forKey:@"orderdbid"];
    }
    [self showProgress];
    [[GMOperationalHandler handler] successForPayTM:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        //[self.navigationController popToRootViewControllerAnimated:NO];
        [self paymentSuceessWithOrderId:self.genralModal.orderID];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        //        [self.navigationController popToRootViewControllerAnimated:NO];
        [self paymentSuceessWithOrderId:self.genralModal.orderID];
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
    if(NSSTRING_HAS_DATA(self.genralModal.orderID)) {
        [orderDic setObject:self.genralModal.orderID forKey:kEY_orderid];
    }
    [orderDic setObject:@"canceled" forKey:@"status"];
    if(NSSTRING_HAS_DATA(self.genralModal.orderDBID)) {
        [orderDic setObject:self.genralModal.orderDBID forKey:@"orderdbid"];
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] failForPayTM:orderDic  withSuccessBlock:^(GMGenralModal *responceData) {
        
        
        [self removeProgress];
        
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
    }];
    [self goToFailOrderScreen];
    
}


-(void)setAmoutDetuction {
    
    
    if(NSSTRING_HAS_DATA(self.genralModal.orderAmount)){
            if(isMyWalletSelected) {
                
                GMUserModal *userModal = [GMUserModal loggedInUser];
                float walletAmount = 0.0;
                if(NSSTRING_HAS_DATA(userModal.balenceInWallet)) {
                    walletAmount = [userModal.balenceInWallet floatValue];
                }
                
                paymentAmount = [self.genralModal.orderAmount doubleValue];//-walletAmount;
            } else {
                paymentAmount = [self.genralModal.orderAmount doubleValue];
            }
        }else {
            if(self.coupanCartDetail) {
                totalAmount = [self.coupanCartDetail.grand_total doubleValue];
            } else {
                double subtotal = 0;
                GMCartDetailModal *cartDetailModal = self.checkOutModal.cartDetailModal;
                for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
                    subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
                }
                
                double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
                totalAmount =  grandTotal;
            }
        
        if(isMyWalletSelected) {
            
            GMUserModal *userModal = [GMUserModal loggedInUser];
            float walletAmount = 0.0;
            if(NSSTRING_HAS_DATA(userModal.balenceInWallet)) {
                walletAmount = [userModal.balenceInWallet floatValue];
            }
                
            paymentAmount = totalAmount-walletAmount;
        } else {
            paymentAmount = totalAmount;
        }
    }
}

-(void)getWalletDataFromServer {
    [self showProgress];
    
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
        [self.paymentTableView reloadData];
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

-(void)getPaymentWayFromServer {
    [self showProgress];
    
    
    [[GMOperationalHandler handler] getpaymentWay:nil withSuccessBlock:^(id responceData) {
        if([responceData objectForKey:@"Payment"] && [[responceData objectForKey:@"Payment"] isKindOfClass:[NSArray class]]) {
            
        NSMutableArray *paymentArray = [responceData objectForKey:@"Payment"];
            [self.paymentOptionArray removeAllObjects];
            
            NSMutableArray *storePymentModal = [[NSMutableArray alloc]init];
            
            for(int i = 0; i<paymentArray.count; i++) {
                
                GMPaymentWayModal *paymetWayModal = [[GMPaymentWayModal alloc]initWithPaymentWayDictionary:[paymentArray objectAtIndex:i]];
                
                if(NSSTRING_HAS_DATA(paymetWayModal.paymentMethodId)){
                    [storePymentModal addObject:paymetWayModal];
                }
            }
            
            NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
            [self.paymentOptionArray addObjectsFromArray:[storePymentModal sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
            
            if(self.paymentOptionArray.count==0) {
                [self setDefaultMethod];
            }
            
        } else {
            [self setDefaultMethod];
        }
        
        [self removeProgress];
        [self.paymentTableView reloadData];
    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [self setDefaultMethod];
        [self.paymentTableView reloadData];
        
    }];
}

-(void)setDefaultMethod {
    [self.paymentOptionArray removeAllObjects];
    GMPaymentWayModal *paymetWayModal = [[GMPaymentWayModal alloc] init];
    paymetWayModal.paymentMethodDefaultName = @"Cash on delivery";
    paymetWayModal.paymentMethodDisplayName = @"";
    paymetWayModal.paymentMethodNameCode = @"cashondelivery";
    paymetWayModal.paymentMethodId = @"1";
    paymetWayModal.displayOrder = @"1";
    [self.paymentOptionArray addObject:paymetWayModal];
//    if(HAS_DATA(responseDict, @"paymentKey"))
//        _paymentMethodId = responseDict[@"paymentKey"];
//    
//    if(HAS_DATA(responseDict, @"mobile_label"))
//        _paymentMethodDisplayName = responseDict[@"mobile_label"];
//    
//    if(HAS_DATA(responseDict, @"value"))
//        _paymentMethodNameCode = responseDict[@"value"];
//    
//    if(HAS_DATA(responseDict, @"default"))
//        _paymentMethodDefaultName = responseDict[@"default"];
//    
//    if(HAS_DATA(responseDict, @"displayOrder"))
//        _displayOrder = responseDict[@"displayOrder"];
    
}

@end
