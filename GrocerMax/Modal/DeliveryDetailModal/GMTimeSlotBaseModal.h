//
//  GMDeliveryTimeSlotModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMTimeSlotBaseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSArray *timeSlotArray;

@property (nonatomic, readonly, strong) NSMutableArray *addressesArray;
@end

@interface GMDeliveryTimeSlotModal : MTLModel <MTLJSONSerializing>

@property(strong, nonatomic) NSString *deliveryDate;
@property(strong, nonatomic) NSNumber *isAvailable;
@property (strong, nonatomic) NSString *timeSlot;
@end
