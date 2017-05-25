//
//  GMGenralModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 30/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMGenralModal.h"

@implementation GMGenralModal


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"flag"                        : @"flag",
             @"result"                      : @"Result",
             @"orderDBID"                   : @"OrderDBID",
             @"orderID"                     : @"OrderID",
             @"orderAmount"                 : @"SubTotal",
             @"buttonTitle"                 : @"Button"
             };
}

@end
