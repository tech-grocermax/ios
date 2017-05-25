//
//  GMOrderSuccessVC.h
//  GrocerMax
//
//  Created by Deepak Soni on 28/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMOrderSuccessVC : UIViewController

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSString *shippingCharge;
@property (nonatomic, strong) NSString *tax;

@property (nonatomic, strong) NSString *paymentOption;

@end
