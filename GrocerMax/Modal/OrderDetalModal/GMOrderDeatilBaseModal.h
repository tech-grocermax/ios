//
//  GMOrderDeatilBaseModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMOrderDeatilBaseModal : NSObject


@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) NSString *orderDate;

@property (nonatomic, strong) NSString *shippingCharge;

@property (nonatomic, strong) NSString *paymentMethod;

@property (nonatomic, strong) NSString *deliveryDate;

@property (nonatomic, strong) NSString *deliveryTime;

@property (nonatomic, strong) NSString *shippingAddress;

@property (nonatomic, strong) NSString *subTotal;

@property (nonatomic, strong) NSString *deliveryCharge;

@property (nonatomic, strong) NSString *totalPrice;

@property (nonatomic, strong) NSString *couponDiscount;



@property (nonatomic, strong) NSMutableArray *itemModalArray;

- (GMOrderDeatilBaseModal *) initWithDictionary:(NSMutableDictionary *)dataDic;


//- (void) setOrderId:(NSString *)orderId;
//
//- (void) setOrderDate:(NSString *)orderDate;
//
//- (void) setShippingCharge:(NSString *)shippingCharge;
//
//- (void) setPaymentMethod:(NSString *)paymentMethod;
//
//- (void) setDeliveryDate:(NSString *)deliveryDate;
//
//- (void) setDeliveryTime:(NSString *)deliveryTime;
//
//- (void) setShippingAddress:(NSString *)shippingAddress;


@end

@interface GMOrderItemDeatilModal : NSObject

@property (nonatomic, strong) NSString *itemName;

@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, strong) NSString *itemOrderId;

@property (nonatomic, strong) NSString *itemPrice;

@property (nonatomic, strong) NSString *quantity;

@end