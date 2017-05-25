//
//  GMInternalNotificationActionsModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/02/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMInternalNotificationActionsModal.h"

@implementation GMInternalNotificationActionsModal


- (instancetype)initWithInternalNotificationActionItemDict:(NSDictionary *)actionDict{
    if(self = [super init]) {
        
        if(HAS_KEY(actionDict, @"text")){
            _text = [NSString stringWithFormat:@"%@",[actionDict objectForKey:@"text"]];
        }
        if(HAS_KEY(actionDict, @"key")){
            _key = [NSString stringWithFormat:@"%@",[actionDict objectForKey:@"key"]];
        }
        if(HAS_KEY(actionDict, @"page")){
            _page = [NSString stringWithFormat:@"%@",[actionDict objectForKey:@"page"]];
        }if(HAS_KEY(actionDict, @"name")){
            _name = [NSString stringWithFormat:@"%@",[actionDict objectForKey:@"name"]];
        }
        
    }
    return self;
}
@end
