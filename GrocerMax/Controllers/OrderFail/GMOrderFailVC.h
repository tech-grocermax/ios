//
//  GMOrderFailVC.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 15/10/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMOrderFailVC : UIViewController

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderDBID;
@property (nonatomic, strong) GMCheckOutModal *checkOutModal;
@property (nonatomic) float totalAmount;


@property (nonatomic, strong) NSString *paymentOption;

@end
