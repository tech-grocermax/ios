//
//  GMProductModal.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMProductListingBaseModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSMutableArray *productsListArray;
@property (strong, nonatomic) NSArray *hotProductListArray;
@property (assign, nonatomic) NSInteger totalcount;
@property (assign, nonatomic) BOOL flag;

- (instancetype)initWithResponseDict:(NSDictionary *)responseDict;

@end

@interface GMProductModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *currencycode;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *Price;
@property (strong, nonatomic) NSString *productid;
@property (strong, nonatomic) NSString *promotion_level;
@property (strong, nonatomic) NSString *p_brand;
@property (strong, nonatomic) NSString *p_name;
@property (strong, nonatomic) NSString *p_pack;
@property (strong, nonatomic) NSString *sale_price;
@property (strong, nonatomic) NSString *Status;
@property (strong, nonatomic) NSString *productQuantity;
@property (strong, nonatomic) NSString *sku;
@property (strong, nonatomic) NSString *noDiscount;
@property (strong, nonatomic) NSString *noOfItemInStock;
@property (strong, nonatomic) NSArray *categoryIdArray;
@property (strong, nonatomic) NSString *addedQuantity;
@property (strong, nonatomic) NSString *row_total;
@property (strong, nonatomic) NSString *extraQuantityAddedOnCart;




@property  NSInteger product_count;
@property (strong, nonatomic) NSString *deal_type_id;
@property (strong, nonatomic) NSString *promo_id;
@property (strong, nonatomic) NSString *rank;


@property  BOOL isDeleted;




@property (nonatomic, assign) BOOL isProductUpdated;

- (instancetype)initWithProductItemDict:(NSDictionary *)productDict;

- (instancetype)initWithProductModal:(GMProductModal *)productModal;
@end
