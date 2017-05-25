//
//  GMTrendingBaseModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 4/10/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMTrendingBaseModal.h"

@interface GMTrendingBaseModal()

@property (nonatomic, readwrite, strong) NSMutableArray *trendingArray;
@end

@implementation GMTrendingBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"trendingArray"  : @"data"
             };
}

+ (NSValueTransformer *)trendingArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMTrendingModal class]];
}
@end

@interface GMTrendingModal()

//@property (nonatomic, readwrite, strong) NSString *trendingId;
//
//@property (nonatomic, readwrite, strong) NSString *trendingName;
//
//@property (nonatomic, readwrite, strong) NSNumber *popularity;
//
//@property (nonatomic, readwrite, strong) NSNumber *numResults;
//
//@property (nonatomic, readwrite, strong) NSString *dataType;
@end

@implementation GMTrendingModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"trendingId"             : @"id",
             @"trendingName"           : @"name1",
             @"popularity"             : @"popularity",
             @"numResults"             : @"num_results",
             @"dataType"               : @"data_type"
             };
}

@end
