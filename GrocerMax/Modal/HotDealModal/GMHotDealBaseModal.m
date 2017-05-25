//
//  GMHotDealModal.m
//  GrocerMax
//
//  Created by arvind gupta on 23/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHotDealBaseModal.h"

@interface GMHotDealBaseModal()

@property (nonatomic, readwrite, strong) NSArray *hotDealArray;

@end

static NSString * const kHotDealsKey                       = @"hotDeals";

static GMHotDealBaseModal *hotDealArrayModal;

@implementation GMHotDealBaseModal


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"hotDealArray"  : @"deal_type"
             };
}

+ (NSValueTransformer *)hotDealArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMHotDealModal class]];
}

+ (instancetype)loadHotDeals {
    
    hotDealArrayModal = [self unarchiveHotDeals];
    return hotDealArrayModal;
}

+ (GMHotDealBaseModal *)unarchiveHotDeals {
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"hotDeals"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        GMHotDealBaseModal *hotDealsModal  = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        return hotDealsModal;
    }
    return nil;
}

- (void)archiveHotDeals {
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"hotDeals"];
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:archivePath];
    DLOG(@"archived : %d",success);
}

#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.hotDealArray forKey:kHotDealsKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.hotDealArray = [aDecoder decodeObjectForKey:kHotDealsKey];
    }
    return self;
}

@end

@interface GMHotDealModal()

@property (nonatomic, readwrite, strong) NSString *dealTypeId;

@property (nonatomic, readwrite, strong) NSString *dealType;

@property (nonatomic, readwrite, strong) NSString *imageName;

@property (nonatomic, readwrite, strong) NSString *imageURL;

@property (nonatomic, readwrite, strong) NSString *bigImageURL;
@end

static NSString * const kDealIdKey                       = @"dealId";
static NSString * const kDealTypeKey                     = @"dealType";
static NSString * const kImageNameKey                    = @"imageName";
static NSString * const kImageUrlKey                     = @"imageURL";
static NSString * const kBigImageUrlKey                  = @"bigImageURL";

@implementation GMHotDealModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"dealTypeId"                : @"id",
             @"dealType"                  : @"dealType",
             @"imageName"                 : @"img_url",
             @"imageURL"                  : @"img",
             @"bigImageURL"               : @"big_img"
             };
}

#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.dealTypeId forKey:kDealIdKey];
    [aCoder encodeObject:self.dealType forKey:kDealTypeKey];
    [aCoder encodeObject:self.imageName forKey:kImageNameKey];
    [aCoder encodeObject:self.imageURL forKey:kImageUrlKey];
    [aCoder encodeObject:self.bigImageURL forKey:kBigImageUrlKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.dealTypeId = [aDecoder decodeObjectForKey:kDealIdKey];
        self.dealType = [aDecoder decodeObjectForKey:kDealTypeKey];
        self.imageName = [aDecoder decodeObjectForKey:kImageNameKey];
        self.imageURL = [aDecoder decodeObjectForKey:kImageUrlKey];
        self.bigImageURL = [aDecoder decodeObjectForKey:kBigImageUrlKey];
    }
    return self;
}

@end
