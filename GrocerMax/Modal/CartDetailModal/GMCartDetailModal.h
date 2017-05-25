//
//  GMCartDetailModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "MTLModel.h"
#import "GMCartModal.h"

@interface GMCartDetailModal : NSObject

@property (nonatomic, strong) NSMutableArray *productItemsArray;

@property (nonatomic, strong) NSMutableArray *deletedProductItemsArray;

@property (nonatomic, strong) NSString *grandTotal;

@property (nonatomic, strong) NSString *taxAmount;

@property (nonatomic, strong) NSString *shippingAmount;

@property (nonatomic, strong) NSString *subTotal;

@property (nonatomic, strong) NSString *couponCode;

@property (nonatomic, strong) NSString *couponCodeDescription;

@property (nonatomic, strong) NSString *discountAmount;

@property (nonatomic, strong) NSString *billBuster;

- (instancetype)initWithCartDetailDictionary:(NSDictionary *)responseDict;

- (instancetype)initWithCartModal:(GMCartModal *)cartModal;
@end
