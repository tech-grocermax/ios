//
//  GMLocalityBaseModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMLocalityBaseModal.h"

@interface GMLocalityBaseModal()

@property (nonatomic, readwrite, strong) NSArray *localityArray;
@end

@implementation GMLocalityBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"localityArray"                  : @"locality"
             };
}

+ (NSValueTransformer *)localityArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMLocalityModal class]];
}
@end

@interface GMLocalityModal()

@property (nonatomic, readwrite, strong) NSString *localityId;

@property (nonatomic, readwrite, strong) NSString *localityName;

@property (nonatomic, readwrite, strong) NSString *cityId;
@end

@implementation GMLocalityModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"localityId"             : @"id",
             @"localityName"           : @"area_name",
             @"cityId"                 : @"city_id"
             };
}
@end