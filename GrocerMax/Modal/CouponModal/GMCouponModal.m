//
//  GMCouponModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 02/07/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMCouponModal.h"

@implementation GMCouponModal



- (instancetype)initWithCouponListDictionary:(NSDictionary *)responseDict{
    
    if(self = [super init]) {
     
        if(HAS_DATA(responseDict, @"name"))
            _couponName = responseDict[@"name"];
        
        if(HAS_DATA(responseDict, @"description"))
            _couponDescription = responseDict[@"description"];
        
        if(HAS_DATA(responseDict, @"coupon_code"))
            _couponCode = responseDict[@"coupon_code"];
        
        if(HAS_DATA(responseDict, @"validDate"))
            _couponValidDate = responseDict[@"validDate"];
        
    }
    return self;

}
@end
