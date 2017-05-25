//
//  GMInternalNotificationActionsModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/02/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMInternalNotificationActionsModal : NSObject


@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSString *name;


- (instancetype)initWithInternalNotificationActionItemDict:(NSDictionary *)actionDict;
@end
