//
//  GMPaymentWayModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 06/02/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMPaymentWayModal.h"

@implementation GMPaymentWayModal

- (instancetype)initWithPaymentWayDictionary:(NSDictionary *)responseDict {
    
    if(self = [super init]) {
        
        if(HAS_DATA(responseDict, @"paymentKey"))
            _paymentMethodId = responseDict[@"paymentKey"];
        
        if(HAS_DATA(responseDict, @"mobile_label"))
            _paymentMethodDisplayName = responseDict[@"mobile_label"];
        
        if(HAS_DATA(responseDict, @"value"))
            _paymentMethodNameCode = responseDict[@"value"];
        
        if(HAS_DATA(responseDict, @"default"))
            _paymentMethodDefaultName = responseDict[@"default"];
        
        if(HAS_DATA(responseDict, @"displayOrder"))
            _displayOrder = responseDict[@"displayOrder"];
        
}
    return self;
}


@end
