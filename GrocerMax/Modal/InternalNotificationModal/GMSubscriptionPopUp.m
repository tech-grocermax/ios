//
//  GMSubscriptionPopUp.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/06/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMSubscriptionPopUp.h"

@implementation GMSubscriptionPopUp

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"cancel_button_text"             : @"cancel_button_text",
             @"expTime"           : @"expTime",
             @"message"             : @"message",
             @"ok_button_text"             : @"ok_button_text"
             };
}
- (instancetype)initWithSubscriptionPopUpDict:(NSDictionary *)subscriptionDict {
    
    
    if(self = [super init]) {
        
        if(HAS_KEY(subscriptionDict, @"cancel_button_text")){
            _cancel_button_text = [NSString stringWithFormat:@"%@",[subscriptionDict objectForKey:@"cancel_button_text"]];
        }
        if(HAS_KEY(subscriptionDict, @"expTime")){
            _expTime = [NSString stringWithFormat:@"%@",[subscriptionDict objectForKey:@"expTime"]];
        }
        if(HAS_KEY(subscriptionDict, @"message")){
            _message = [NSString stringWithFormat:@"%@",[subscriptionDict objectForKey:@"message"]];
        }if(HAS_KEY(subscriptionDict, @"ok_button_text")){
            _ok_button_text = [NSString stringWithFormat:@"%@",[subscriptionDict objectForKey:@"ok_button_text"]];
        }
        
    }
    return self;
    
}

@end
