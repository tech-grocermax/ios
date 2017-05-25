//
//  GMStateBaseModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMStateBaseModal.h"

static NSString * const kCityIdKey                     = @"cityId";
static NSString * const kCityNameKey                   = @"cityName";
static NSString * const kStateIdKey                    = @"stateId";
static NSString * const kStateNameKey                  = @"stateName";
static NSString * const kStoreIdKey                    = @"storeId";

@interface GMStateBaseModal()

@property (nonatomic, readwrite, strong) NSArray *stateArray;
@property (nonatomic, readwrite, strong) NSArray *cityArray;
@end

@implementation GMStateBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"stateArray"                  : @"state",
             @"cityArray"                   : @"location"
             };
}

+ (NSValueTransformer *)stateArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMStateModal class]];
}

+ (NSValueTransformer *)cityArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMCityModal class]];
}

@end

@interface GMStateModal()

@property (nonatomic, readwrite, strong) NSString *regionId;

@property (nonatomic, readwrite, strong) NSString *stateName;

@property (nonatomic, readwrite, strong) NSArray *cityArray;
@end

@implementation GMStateModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"regionId"                  : @"region_id",
             @"stateName"                 : @"default_name",
             @"cityArray"                 : @"city"
             };
}

+ (NSValueTransformer *)cityArraySlotArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMCityModal class]];
}
@end

@interface GMCityModal()

@property (nonatomic, readwrite, strong) NSString *cityId;

@property (nonatomic, readwrite, strong) NSString *cityName;

@property (nonatomic, readwrite, strong) NSString *stateId;

@property (nonatomic, readwrite, strong) NSString *stateName;

@property (nonatomic, readwrite, strong) NSString *storeId;

@property (nonatomic, readwrite) BOOL isSelected;

@end

@implementation GMCityModal

static GMCityModal *cityModal;

+ (instancetype)selectedLocation {
    
    if(!cityModal) {
        
        cityModal = [GMCityModal loadCityModal];
    }
    return cityModal;
}

+ (GMCityModal *)loadCityModal {
    
    GMCityModal *archivedUser = [[GMSharedClass sharedClass] getSavedLocation];
    return archivedUser;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
//    return @{@"cityId"                  : @"region_id",
//             @"cityName"                : @"city_name",
//             @"stateId"                 : @"id",
//             @"stateName"               : @"default_name",
//             @"storeId"                 : @"id"
//             };
    return @{@"cityId"                  : @"id",
             @"cityName"                : @"city_name",
             @"stateId"                 : @"region_id",
             @"stateName"               : @"default_name",
             @"storeId"                 : @"storeid"
             };
}


#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.cityId forKey:kCityIdKey];
    [aCoder encodeObject:self.cityName forKey:kCityNameKey];
    [aCoder encodeObject:self.stateId forKey:kStateIdKey];
    [aCoder encodeObject:self.stateName forKey:kStateNameKey];
    [aCoder encodeObject:self.storeId forKey:kStoreIdKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super init])) {
        
        self.cityId = [aDecoder decodeObjectForKey:kCityIdKey];
        self.cityName = [aDecoder decodeObjectForKey:kCityNameKey];
        self.stateId = [aDecoder decodeObjectForKey:kStateIdKey];
        self.stateName = [aDecoder decodeObjectForKey:kStateNameKey];
        self.storeId = [aDecoder decodeObjectForKey:kStoreIdKey];
    }
    return self;
}

- (void)persistLocation {
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[GMSharedClass sharedClass] saveSelectedLocationData:encodedObject];
    cityModal = nil;
}

@end