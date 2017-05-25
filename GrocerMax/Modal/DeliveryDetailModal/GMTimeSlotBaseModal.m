//
//  GMDeliveryTimeSlotModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMTimeSlotBaseModal.h"

@interface GMTimeSlotBaseModal()

@property (nonatomic, readwrite, strong) NSArray *timeSlotArray;

@property (nonatomic, readwrite, strong) NSMutableArray *addressesArray;
@end

@implementation GMTimeSlotBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"timeSlotArray"                  : @"Shipping",
             @"addressesArray"                 : @"Address"
             };
}

+ (NSValueTransformer *)timeSlotArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMDeliveryTimeSlotModal class]];
}

+ (NSValueTransformer *)addressesArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMAddressModalData class]];
}

@end

@implementation GMDeliveryTimeSlotModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"timeSlot"                  : @"TimeSlot",
             @"deliveryDate"              : @"Date",
             @"isAvailable"               : @"Available"
             };
}

@end
