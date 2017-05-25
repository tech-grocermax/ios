//
//  GMCheckOutModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMTimeSlotBaseModal.h"
#import "GMAddressModal.h"


@interface GMCheckOutModal : NSObject

@property(strong, nonatomic) GMAddressModalData *shippingAddressModal;

@property(strong, nonatomic) GMAddressModalData *billingAddressModal;

@property(strong, nonatomic) GMTimeSloteModal *timeSloteModal;

@property (nonatomic, strong) GMCartDetailModal *cartDetailModal;

@end
