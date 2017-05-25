//
//  GMOrderSuccessVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 28/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderSuccessVC.h"
#import "GMCartModal.h"
#import "GMProfileVC.h"
#import "MGSocialMedia.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import "GMStateBaseModal.h"

@interface GMOrderSuccessVC ()

@property (weak, nonatomic) IBOutlet UILabel *orderIdlabel;
@end

@implementation GMOrderSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(NSSTRING_HAS_DATA(self.orderId)) {
        [self.orderIdlabel setText:[NSString stringWithFormat:@"order Id is  %@", self.orderId]];
    } else {
        [self.orderIdlabel setText:[NSString stringWithFormat:@"Order details send by email and sms."]];
        self.orderIdlabel.textColor = [UIColor blackColor];
    }
    NSDictionary* style1 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmRedColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName : FONT_BOLD(18),
                             NSForegroundColorAttributeName : [UIColor gmBlackColor],
                             };
    
    if(NSSTRING_HAS_DATA(self.orderId)){
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"Order ID is " attributes:style1];
        [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:self.orderId attributes:style2]];
        [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\nPlease check your mail for details" attributes:style1]];
        
        [self.orderIdlabel setAttributedText:attString];
    }else {
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"Please check your mail for details" attributes:style1];
//            [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\nPlease check your mail for details" attributes:style1]];
            [self.orderIdlabel setAttributedText:attString];
    }
    [self onPurchaseCompleted];
    
    [[GMSharedClass sharedClass] clearCart];
    [self.tabBarController updateBadgeValueOnCartTab];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_OrderSuccess withCategory:@"" label:nil value:nil];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Order Successful" label:@""];
    
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.userId)){
        [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    if(NSSTRING_HAS_DATA(self.paymentOption)){
        [qaGrapEventDic setObject:self.paymentOption forKey:kEY_QA_EventParmeter_PaymentOption];
    }
    if(NSSTRING_HAS_DATA(self.totalPrice)){
        [qaGrapEventDic setObject:self.totalPrice forKey:kEY_QA_EventParmeter_Subtotal];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_CheckOutOrderSuccessFul withExtraParameter:qaGrapEventDic];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_CartPaymentSucess_Screen];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)continueShoppingButtonTapped:(id)sender {
    
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
    [self.tabBarController setSelectedIndex:0];
    
    [self.navigationController popToRootViewControllerAnimated:NO];
//    [self.tabBarController setSelectedIndex:0];
}
- (IBAction)actionOrderHistory:(id)sender {
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
}

- (IBAction)shareBtnAction:(UIButton *)sender {

    MGSocialMedia *socalMedia = [MGSocialMedia sharedSocialMedia];
    [socalMedia showActivityView:@"Hey, Checkout this product!!!"];
}


- (void)onPurchaseCompleted {
    
    // Assumes a tracker has already been initialized with a property ID, otherwise
    // this call returns null.
    if(self.orderId == nil) {
        self.orderId = [NSString stringWithFormat:@"Grocer_WithoutOrderId_RandomOrderID_%d",arc4random()];
    }
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    float productsRevenue = 0.0f;
    float productsTax = 0.0f;
    float productsShippingCharge = 0.0f;
    NSString *productsCurrencyCode = @"RS";
    
    if(NSSTRING_HAS_DATA(self.totalPrice)) {
        productsRevenue = [self.totalPrice floatValue];
    }
    if(NSSTRING_HAS_DATA(self.tax)) {
        productsTax = [self.tax floatValue];
    }
    if(NSSTRING_HAS_DATA(self.shippingCharge)) {
        productsShippingCharge = [self.shippingCharge floatValue];
    }
        [tracker send:[[GAIDictionaryBuilder createTransactionWithId:self.orderId  affiliation:@"In-app Grocer" revenue:[NSNumber numberWithFloat:productsRevenue]    tax:[NSNumber numberWithFloat:productsTax]  shipping:[NSNumber numberWithFloat:productsShippingCharge]  currencyCode:productsCurrencyCode] build]];
    
    
    int totalItems = 0;
    GMCartModal *cartModal = [GMCartModal loadCart];
    
    for (GMProductModal *productModal in cartModal.cartItems) {
        
        totalItems += productModal.productQuantity.intValue;
        
        NSString *productName = @"Grocer";
        NSString *productSKU = @"";
        NSString *productCategory = @"";
        NSString *currencyCode = @"RS";
        float productPrice = 0.0f;
        int quantity = 0;
        
        if(NSSTRING_HAS_DATA(productModal.name)) {
            productName = productModal.name;
        }
        
        if(NSSTRING_HAS_DATA(productModal.sku)) {
            productSKU = productModal.sku;
        } else {
            productSKU = [NSString stringWithFormat:@"GrocercerSKU_%@",self.orderId];
        }
        
        if(NSSTRING_HAS_DATA(productModal.sale_price)) {
            productPrice = [productModal.sale_price floatValue];
        }
        
        if(NSSTRING_HAS_DATA(productModal.productQuantity)) {
            quantity = [productModal.sale_price intValue];
        }
        
        if(NSSTRING_HAS_DATA(productModal.p_brand)) {
            productCategory = productModal.p_brand;
        } else {
            productCategory = @"Grocer expansions";
        }
        
        if(NSSTRING_HAS_DATA(productModal.currencycode)) {
            currencyCode = productModal.currencycode;
        }
        
         [tracker send:[[GAIDictionaryBuilder createItemWithTransactionId:self.orderId  name:productName  sku:productSKU category:productCategory price:[NSNumber numberWithFloat:productPrice]   quantity:[NSNumber numberWithInt:quantity]  currencyCode:currencyCode] build]];
    
        
        
    }
    
}

@end
