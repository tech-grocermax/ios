//
//  GMDealCategoryBaseModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 24/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMDealCategoryBaseModal.h"

@interface GMDealCategoryBaseModal()

@property (nonatomic, readwrite, strong) NSArray *dealCategories;

@property (nonatomic, readwrite, strong) NSArray *allDealCategory;
@end

@implementation GMDealCategoryBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"dealCategories"   : @"category",
             @"allDealCategory"  : @"all",
             @"dealNameArray"    : @"name"
             };
}

+ (NSValueTransformer *)dealCategoriesJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMDealCategoryModal class]];
}

+ (NSValueTransformer *)allDealCategoryJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMDealModal class]];
}
@end

@interface GMDealCategoryModal()

@property (nonatomic, readwrite, strong) NSString *categoryId;

@property (nonatomic, readwrite, strong) NSString *images;

@property (nonatomic, readwrite, strong) NSString *categoryName;

@property (nonatomic, readwrite, strong) NSString *isActive;

@property (nonatomic, readwrite, strong) NSArray *deals;
@end

@implementation GMDealCategoryModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"categoryId"          : @"category_id",
             @"images"              : @"images",
             @"categoryName"        : @"name",
             @"isActive"            : @"is_active",
             @"deals"               : @"deals"
             };
}

+ (NSValueTransformer *)dealsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMDealModal class]];
}

- (instancetype)initWithCategoryId:(NSString *)categoryId images:(NSString *)images categoryName:(NSString *)categoryName isActive:(NSString *)isActive andDeals:(NSArray *)deals {
    
    if(self = [super init]) {
        
        _categoryId = categoryId;
        _images = images;
        _categoryName = categoryName;
        _isActive = isActive;
        _deals = deals;
    }
    return self;
}
@end

@interface GMDealModal()

@property (nonatomic, readwrite, strong) NSString *dealId;

@property (nonatomic, readwrite, strong) NSString *categoryId;

@property (nonatomic, readwrite, strong) NSString *dealName;

@property (nonatomic, readwrite, strong) NSString *img;
@end

@implementation GMDealModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"dealId"          : @"id",
             @"categoryId"      : @"category_id",
             @"dealName"        : @"name",
             @"img"             : @"image"
             };
//    return @{@"dealId"          : @"promo_id",
//             @"categoryId"      : @"category_id",
//             @"dealName"        : @"title",
//             @"img"             : @"deal_image"
//             };
}

@end