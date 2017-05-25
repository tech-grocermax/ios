//
//  GMCartModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCartModal.h"

static NSString * const kCartItemsKey                      = @"cartItems";
static NSString * const kParentIdKey                        = @"parentId";

static GMCartModal *cartModal;

@implementation GMCartModal

+ (instancetype)loadCart {
    
    cartModal = [self unarchiveRootCategory];
    return cartModal;
}

+ (GMCartModal *)unarchiveRootCategory {
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"cartModal"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        GMCartModal *cartModal  = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        return cartModal;
    }
    return nil;
}

- (instancetype)initWithCartItems:(NSMutableArray *)cartItems {
    
    if(self = [super init]) {
        _cartItems = cartItems;
    }
    return self;
}

- (instancetype)initWithCartDetailModal:(GMCartDetailModal *)cartDetailModal {
    
    if(self = [super init]) {
        
        NSMutableArray *productArray = [[NSMutableArray alloc]init];
        for (int i =0; i<cartDetailModal.productItemsArray.count; i++) {
            GMProductModal *productModal = [cartDetailModal.productItemsArray objectAtIndex:i];
            
            GMProductModal *addedProductModal = [productModal copy];
            [productArray addObject:addedProductModal];
        }
        _cartItems = productArray;
        
//        [NSMutableArray arrayWithArray:cartDetailModal.productItemsArray];
    }
    return self;
}

- (void)archiveCart {
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"cartModal"];
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:archivePath];
    cartModal = nil;
    DLOG(@"archived : %d",success);
}

#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.cartItems forKey:kCartItemsKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.cartItems = [aDecoder decodeObjectForKey:kCartItemsKey];
    }
    return self;
}

@end
