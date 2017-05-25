//
//  GMCoupanCartDetail.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 30/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCoupanCartDetail.h"

@implementation GMCoupanCartDetail

- (instancetype)initWithCartDetailDictionary:(NSDictionary *)resultDict {
    
    if(self = [super init]) {
        
        
        NSDictionary *responseDict = resultDict[@"CartDetails"];
        
        if(HAS_DATA(responseDict, @"subtotal"))
            _subtotal = [NSString stringWithFormat:@"%@", responseDict[@"subtotal"]];
        
        if(HAS_DATA(responseDict, @"ShippingCharge"))
            _ShippingCharge = [NSString stringWithFormat:@"%@", responseDict[@"ShippingCharge"]];
        
        if(HAS_DATA(responseDict, @"subtotal_with_discount"))
            _subtotal_with_discount = [NSString stringWithFormat:@"%@", responseDict[@"subtotal_with_discount"]];
        
        if(HAS_DATA(responseDict, @"coupon_code"))
            _coupon_code = [NSString stringWithFormat:@"%@", responseDict[@"coupon_code"]];
        
        if(HAS_DATA(responseDict, @"you_save"))
            _you_save = [NSString stringWithFormat:@"%@", responseDict[@"you_save"]];
        
        if(HAS_DATA(responseDict, @"grand_total"))
            _grand_total = [NSString stringWithFormat:@"%@", responseDict[@"grand_total"]];
    
    }
    return self;
}

@end
