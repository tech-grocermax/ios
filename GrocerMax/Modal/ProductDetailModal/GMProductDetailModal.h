//
//  GMProductDetailModal.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 23/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMProductDetailBaseModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *productDetailArray;
@property (assign, nonatomic) BOOL flag;

@end

@interface GMProductDetailModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *Status;
@property (strong, nonatomic) NSString *currencycode;
@property (strong, nonatomic) NSString *p_brand;
@property (strong, nonatomic) NSString *p_name;
@property (strong, nonatomic) NSString *p_pack;
@property (strong, nonatomic) NSString *product_description;
@property (strong, nonatomic) NSString *product_id;
@property (strong, nonatomic) NSString *product_name;
@property (strong, nonatomic) NSString *product_price;
@property (strong, nonatomic) NSString *product_qty;
@property (strong, nonatomic) NSString *product_thumbnail;
@property (strong, nonatomic) NSString *sale_price;
@property (strong, nonatomic) NSString *promotion_level;


@end
