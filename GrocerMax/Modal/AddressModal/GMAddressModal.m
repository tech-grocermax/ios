//
//  GMAddressModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMAddressModal.h"

@interface GMAddressModal()

@property (nonatomic, readwrite, strong) NSArray *addressArray;

@property (nonatomic, readwrite, strong) NSArray *billingAddressArray;

@property (nonatomic, readwrite, strong) NSArray *shippingAddressArray;
@end

@implementation GMAddressModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"addressArray"                  : @"Address",
             @"billingAddressArray"           : @"BillingAddress",
             @"shippingAddressArray"          : @"ShippingAddress"
             };
}

+ (NSValueTransformer *)addressArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMAddressModalData class]];
}

+ (NSValueTransformer *)billingAddressArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMAddressModalData class]];
}

+ (NSValueTransformer *)shippingAddressArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMAddressModalData class]];
}
@end


@implementation GMAddressModalData


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"customer_address_id"     : @"customer_address_id",
             @"created_at"              : @"created_at",
             @"update_at"               : @"updated_at",
             @"city"                    : @"city",
             @"contryId"                : @"country_id",
             @"firstName"               : @"firstname",
             @"lastName"                : @"lastname",
             @"latitude"                : @"latitude",
             @"logidutude"              : @"longitude",
             @"pincode"                 : @"postcode",
             @"region"                  : @"region",
             @"region_id"               : @"region_id",
             @"street"                  : @"street",
             @"telephone"               : @"telephone",
             @"userType"                : @"usertype",
             @"is_default_billing"      : @"is_default_billing",
             @"is_default_shipping"     : @"is_default_shipping",
             };
}

- (void)updateHouseNoLocalityAndLandmarkWithStreet:(NSString *)street {
    
    if(NSSTRING_HAS_DATA(street)) {
        
        NSArray *partitionArr = [street componentsSeparatedByString:@"\n"];
        if(partitionArr.count) {
            
            if(partitionArr.count > 0)
                self.houseNo = [partitionArr objectAtIndex:0];
            
            if(partitionArr.count > 1)
                self.locality = [partitionArr objectAtIndex:1];
            
            if(partitionArr.count > 2)
                self.closestLandmark = [partitionArr objectAtIndex:2];
        }
    }
}

- (instancetype)initWithUserModal:(GMUserModal *)userModal {
    
    if(self = [super init]) {
        
        _firstName = [self getValidString:userModal.firstName];
//        _lastName = [self getValidString:userModal.lastName];
        _telephone = [self getValidString:userModal.mobile];
    }
    return self;
}

- (NSString *)getValidString:(NSString *)str {
    
    if(NSSTRING_HAS_DATA(str))
        return str;
    else
        return @"";
}
@end
