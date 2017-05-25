//
//  GMInternalNotificationModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/02/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMInternalNotificationActionsModal.h"

@interface GMInternalNotificationModal : NSObject


@property (nonatomic, strong) NSString *notificationId;
@property (nonatomic, strong) NSString *notificationMessage;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *frequency;
@property (nonatomic, strong) NSMutableArray *actions;


- (instancetype)initWithInternalNotificationItemDict:(NSDictionary *)notificationDict;

@end
