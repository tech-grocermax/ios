//
//  UITabBarController+UpdateBagde.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 28/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "UITabBarController+UpdateBagde.h"
#import "GMCartModal.h"

@implementation UITabBarController (UpdateBagde)

- (void)updateBadgeValueOnCartTab {
    
    int totalItems = 0;
    GMCartModal *cartModal = [GMCartModal loadCart];
    
    for (GMProductModal *productModal in cartModal.cartItems) {
        
        totalItems += productModal.productQuantity.intValue;
    }
    
    if (cartModal.cartItems.count)
        [[[self viewControllers][4] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d",totalItems]];
    else
        [[[self viewControllers][4] tabBarItem] setBadgeValue:nil];
}

@end
