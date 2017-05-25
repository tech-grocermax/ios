//
//  GMSubscriptionPopUp.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/06/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMSubscriptionPopUp : MTLModel <MTLJSONSerializing>


@property (nonatomic, strong) NSString *cancel_button_text;
@property (nonatomic, strong) NSString *expTime;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *ok_button_text;




- (instancetype)initWithSubscriptionPopUpDict:(NSDictionary *)subscriptionDict;

@end
