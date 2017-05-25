//
//  GMInternalNotificationModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/02/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMInternalNotificationModal.h"


@implementation GMInternalNotificationModal


- (instancetype)initWithInternalNotificationItemDict:(NSDictionary *)notificationDict{
    if(self = [super init]) {
        
        
            if(HAS_KEY(notificationDict, @"id")){
                _notificationId = [NSString stringWithFormat:@"%@",[notificationDict objectForKey:@"id"]];
            }
            if(HAS_KEY(notificationDict, @"message")){
                _notificationMessage = [NSString stringWithFormat:@"%@",[notificationDict objectForKey:@"message"]];
            }
            if(HAS_KEY(notificationDict, @"type")){
                _type = [NSString stringWithFormat:@"%@",[notificationDict objectForKey:@"type"]];
            }
            if(HAS_KEY(notificationDict, @"frequency")){
                _frequency = [NSString stringWithFormat:@"%@",[notificationDict objectForKey:@"frequency"]];
            }
            
            if(HAS_KEY(notificationDict, @"action") && [[notificationDict objectForKey:@"action"] isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *actionItemsArr = [NSMutableArray array];
                NSArray *items = notificationDict[@"action"];
                
                for (NSDictionary *actionDict in items) {
                    GMInternalNotificationActionsModal *actionModal = [[GMInternalNotificationActionsModal alloc] initWithInternalNotificationActionItemDict:actionDict];
                    [actionItemsArr addObject:actionModal];
                }
                _actions = actionItemsArr;
            }
        
       
        
    }
    
    return self;
}
@end
