//
//  GMRegistrationResponseModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRegistrationResponseModal.h"

@implementation GMRegistrationResponseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"result"             : @"Result",
             @"userId"             : @"UserID",
             @"otp"                : @"otp",
             @"flag"               : @"flag"
             };
}
@end
