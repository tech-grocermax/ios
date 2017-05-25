//
//  GMMaxCoinBaseModal.h
//  GrocerMax
//
//  Created by Rahul on 7/6/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMMaxCoinBaseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSMutableArray *maxcoinsListArray;
@property (nonatomic, readonly, strong) NSString *totalPoints;

@end


//{
//    "id": "53",
//    "wallet_id": "0",
//    "order_id": "0",
//    "customer_id": "26860",
//    "type_action": "8",
//    "coupon_code": "New4",
//    "redeem_point": "100",
//    "coupon_exp_date": "2016-06-30",
//    "comment": "Adding 100 credits to current customer's balance",
//    "created_date": "2016-07-01 11:40:01",
//    "flag": "0"
//}

@interface GMMaxCoinModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *_id;

@property (nonatomic, strong) NSString *order_id;

@property (nonatomic, strong) NSString *coupon_code;

@property (nonatomic, strong) NSString *redeem_point;

@property (nonatomic, strong) NSString *comment;

@property (nonatomic, strong) NSString *created_date;

@property (nonatomic, strong) NSString *coupon_exp_date;

@property (nonatomic, strong) NSString *type_action;



@end