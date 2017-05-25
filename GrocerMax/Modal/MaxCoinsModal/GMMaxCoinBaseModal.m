//
//  GMMaxCoinBaseModal.m
//  GrocerMax
//
//  Created by Rahul on 7/6/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMMaxCoinBaseModal.h"


@interface GMMaxCoinBaseModal()

@property (nonatomic, readwrite, strong) NSMutableArray *maxcoinsListArray;
@property (nonatomic, readwrite, strong) NSString *totalPoints;

@end

@implementation GMMaxCoinBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"maxcoinsListArray"                      : @"redeemLog",
             @"totalPoints"                             : @"totalPoint"
             };
}

+ (NSValueTransformer *)maxcoinsListArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMMaxCoinModal class]];
}

@end

@implementation GMMaxCoinModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"_id"                     : @"id",
             @"order_id"                : @"order_id",
             @"coupon_code"             : @"coupon_code",
             @"redeem_point"            : @"redeem_point",
             @"comment"                 : @"comment",
             @"created_date"            : @"created_date",
             @"coupon_exp_date"         : @"coupon_exp_date",
             @"type_action"             : @"type_action"
             };
}

@end

