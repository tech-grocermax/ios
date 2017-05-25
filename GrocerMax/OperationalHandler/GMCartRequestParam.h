//
//  GMCartRequestParam.h
//  GrocerMax
//
//  Created by Deepak Soni on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMCartModal;
@class GMProductModal;
@class GMCheckOutModal;

@interface GMCartRequestParam : NSObject

+ (instancetype)sharedCartRequest;

- (NSDictionary *)addToCartParameterDictionaryFromCartModal:(GMCartModal *)cartModal;

- (NSDictionary *)addToCartParameterDictionaryFromProductModal:(GMProductModal *)productModal;

- (NSDictionary *)addToCartParameterDictionaryNEWFromProductModal:(GMProductModal *)productModal ;

- (NSDictionary *)updateDeleteRequestParameterFromCartModal:(GMCartModal *)cartModal;

- (NSDictionary *)updateDeleteRequestParameterFromCartDetailModal:(GMCartDetailModal *)cartModal;

- (NSDictionary *)cartDetailRequestParameter;

- (NSDictionary *)finalCheckoutParameterDictionaryFromCheckoutModal:(GMCheckOutModal *)checkoutModal;
@end
