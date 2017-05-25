//
//  GMGenralModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 30/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMGenralModal : MTLModel <MTLJSONSerializing>


@property (nonatomic) int flag;

@property (nonatomic, strong) NSString *result;

@property (nonatomic, strong) NSString *orderDBID;

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSString *orderAmount;

@property (nonatomic, strong) NSString *buttonTitle;

@end
