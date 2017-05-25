//
//  GMCoupanCartDetail.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 30/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMCoupanCartDetail : NSObject

@property (nonatomic, strong) NSString *subtotal;

@property (nonatomic, strong) NSString *ShippingCharge;

@property (nonatomic, strong) NSString *subtotal_with_discount;


@property (nonatomic, strong) NSString *coupon_code;

@property (nonatomic, strong) NSString *you_save;

@property (nonatomic, strong) NSString *grand_total;

- (instancetype)initWithCartDetailDictionary:(NSDictionary *)responseDict;

@end
