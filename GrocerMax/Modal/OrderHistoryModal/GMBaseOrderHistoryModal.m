//
//  GMBaseOrderHistoryModal.m
//  GrocerMax
//
//  Created by arvind gupta on 22/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMBaseOrderHistoryModal.h"

@interface GMBaseOrderHistoryModal()

@property (nonatomic, readwrite, strong) NSArray *orderHistoryArray;
@end

@implementation GMBaseOrderHistoryModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"orderHistoryArray"                  : @"orderhistory"
             };
}

+ (NSValueTransformer *)orderHistoryArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMOrderHistoryModal class]];
}

@end

@implementation GMOrderHistoryModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"orderId"                     : @"order_id",
             @"orderDate"                   : @"created_at",
             @"status"                      : @"status",
             @"paidAmount"                  : @"grand_total",
             @"totalItem"                   : @"total_item_count",
             @"incrimentId"                 : @"increment_id",
             @"storeId"                     : @"store_id",
             };
}

@end
