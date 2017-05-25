//
//  GMCartModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMProductModal.h"
#import "GMAddressModal.h"
#import "GMCartDetailModal.h"

@interface GMCartModal : NSObject

@property (nonatomic, strong) NSMutableArray *cartItems;

@property (nonatomic, strong) GMAddressModal *userShippingAddress;

@property (nonatomic, strong) GMAddressModal *userBillingAddress;

@property (nonatomic, strong) NSMutableArray *deletedProductItems;

- (instancetype)initWithCartItems:(NSMutableArray *)cartItems;

- (instancetype)initWithCartDetailModal:(GMCartDetailModal *)cartDetailModal;

+ (instancetype)loadCart;

- (void)archiveCart;
@end
