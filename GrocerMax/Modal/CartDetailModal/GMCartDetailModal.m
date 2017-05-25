//
//  GMCartDetailModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCartDetailModal.h"
#import "GMProductModal.h"

@implementation GMCartDetailModal

- (instancetype)initWithCartDetailDictionary:(NSDictionary *)responseDict {
    
    if(self = [super init]) {
        
        if(HAS_KEY(responseDict, @"items")) {
            
            NSMutableArray *productItemsArr = [NSMutableArray array];
            NSArray *items = responseDict[@"items"];
            for (NSDictionary *productDict in items) {
                
                GMProductModal *productModal = [[GMProductModal alloc] initWithProductItemDict:productDict];
                [productItemsArr addObject:productModal];
            }
            _productItemsArray = productItemsArr;
        }
        _deletedProductItemsArray = [NSMutableArray array];
        
        if(HAS_DATA(responseDict, @"coupon_code"))
            _couponCode = responseDict[@"coupon_code"];
        
        if(HAS_DATA(responseDict, @"coupon_description"))
            _couponCodeDescription = responseDict[@"coupon_description"];
        
        NSDictionary *shippingDict = responseDict[@"shipping_address"];
        
        if(HAS_DATA(shippingDict, @"tax_amount"))
            _taxAmount = shippingDict[@"tax_amount"];
        
        if(HAS_DATA(shippingDict, @"shipping_amount"))
            _shippingAmount = shippingDict[@"shipping_amount"];
        
        if(HAS_DATA(shippingDict, @"discount_amount"))
            _discountAmount = shippingDict[@"discount_amount"];
        
        if(HAS_DATA(shippingDict, @"grand_total"))
            _grandTotal = shippingDict[@"grand_total"];
        
        if(HAS_DATA(shippingDict, @"subtotal"))
            _subTotal = shippingDict[@"subtotal"];
        
        if(HAS_DATA(responseDict, @"Bill_buster"))
            _billBuster = responseDict[@"Bill_buster"];
        
        
    }
    return self;
}

- (instancetype)initWithCartModal:(GMCartModal *)cartModal {
    
    if(self = [super init]) {
        
        _productItemsArray = [NSMutableArray arrayWithArray:cartModal.cartItems];
        _deletedProductItemsArray = [NSMutableArray array];
    }
    return self;
}
@end
