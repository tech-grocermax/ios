//
//  GMBaseOrderHistoryModal.h
//  GrocerMax
//
//  Created by arvind gupta on 22/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMBaseOrderHistoryModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSArray *orderHistoryArray;

@end


@interface GMOrderHistoryModal : MTLModel <MTLJSONSerializing>

@property(strong, nonatomic)  NSString * orderId;
@property(strong, nonatomic)  NSString * orderDate;
@property (strong, nonatomic) NSString * status;
@property(strong, nonatomic)  NSString * paidAmount;
@property(strong, nonatomic)  NSString * totalItem;
@property (strong, nonatomic) NSString * incrimentId; //increment_id
@property (strong, nonatomic) NSString * storeId; 

@end