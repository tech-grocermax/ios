//
//  GMHomeModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 09/11/15.
//  Copyright © 2015 Deepak Soni. All rights reserved.
//

#import "GMHomeModal.h"

@interface GMHomeModal()

@property (nonatomic, readwrite, strong) GMCategoryModal *rootCategoryModal;

@property (nonatomic, readwrite, strong) NSArray *hotDealArray;

@property (nonatomic, readwrite, strong) NSArray *bannerListArray;

@property (nonatomic, readwrite, strong) NSArray *categoryArray;

@property (nonatomic, readwrite, strong) NSArray *specialDealArray;

@property (nonatomic, readwrite, strong) NSString *imageUrl;

@property (nonatomic, readwrite, strong) GMTrendingBaseModal *trendingBaseModal;

@property (nonatomic, readwrite, strong) GMSubscriptionPopUp *subscriptionPopUp;
@end

@implementation GMHomeModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"hotDealArray"       : @"deal_type",
             @"rootCategoryModal"  : @"Category",
             @"bannerListArray"    : @"banner",
             @"categoryArray"      : @"category",
             @"specialDealArray"   : @"specialdeal",
             @"trendingBaseModal"  : @"trending.Result",
             @"imageUrl"           : @"urlImg",
             @"subscriptionPopUp"  : @"subscriptionPopUp"
             };
}

+ (NSValueTransformer *)hotDealArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMHotDealModal class]];
}

+ (NSValueTransformer *)rootCategoryModalJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[GMCategoryModal class]];
}

+ (NSValueTransformer *)bannerListArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMHomeBannerModal class]];
}

+ (NSValueTransformer *)specialDealArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMBannerModal class]];
}

+ (NSValueTransformer *)trendingBaseModalJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[GMTrendingBaseModal class]];
}

+ (NSValueTransformer *)subscriptionPopUpJSONTransformer {
    
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[GMSubscriptionPopUp class]];
}
@end
