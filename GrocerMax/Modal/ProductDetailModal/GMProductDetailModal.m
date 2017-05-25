//
//  GMProductDetailModal.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 23/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductDetailModal.h"

@implementation GMProductDetailBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"productDetailArray"  : @"Product_Detail",
             @"flag"                : @"flag"
             };
}

+ (NSValueTransformer *)productDetailArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMProductDetailModal class]];
}

@end

@implementation GMProductDetailModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"Status"                  : @"Status",
             @"currencycode"            : @"currencycode",
             @"p_brand"                 : @"p_brand",
             @"p_name"                  : @"p_name",
             @"p_pack"                  : @"p_pack",
             @"product_description"     : @"product_description",
             @"product_id"              : @"product_id",
             @"product_name"            : @"product_name",
             @"product_price"           : @"product_price",
             @"product_qty"             : @"product_qty",
             @"product_thumbnail"       : @"product_thumbnail",
             @"sale_price"              : @"sale_price",
             @"promotion_level"         : @"promotion_level"
             };
}

@end
