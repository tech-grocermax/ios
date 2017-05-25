//
//  GMBillingAddressVC.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMCheckOutModal.h"
@interface GMBillingAddressVC : UIViewController

@property (nonatomic, strong) GMCheckOutModal *checkOutModal;

@property (strong, nonatomic) NSMutableArray *billingAddressArray;

@property (strong, nonatomic) GMTimeSlotBaseModal *timeSlotBaseModal;

@end
