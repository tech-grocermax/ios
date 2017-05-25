//
//  GMSearchResultModal.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 27/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSearchResultModal.h"

@implementation GMSearchResultModal


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"productsListArray"  : @"Product",
             @"categorysListArray" : @"Category",
             @"totalcount"         : @"Totalcount"
             };
}

+ (NSValueTransformer *)productsListArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMProductModal class]];
}

+ (NSValueTransformer *)categorysListArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMCategoryModal class]];
}

@end
