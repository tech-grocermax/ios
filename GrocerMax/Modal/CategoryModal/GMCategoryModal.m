 //
//  GMCategoryModal.m
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCategoryModal.h"

@interface GMCategoryModal()

@property (nonatomic, readwrite, strong) NSString *categoryId;

@property (nonatomic, readwrite, strong) NSString *parentId;

@property (nonatomic, readwrite, strong) NSString *categoryName;

@property (nonatomic, readwrite, strong) NSString *categoryImageURL;

@property (nonatomic, readwrite, strong) NSString *isActive;

@property (nonatomic, readwrite, strong) NSString *position;

@property (nonatomic, readwrite, strong) NSString *level;

@property (nonatomic, readwrite, strong) NSArray *subCategories;

@property (nonatomic, readwrite, assign) BOOL isExpand;

@property (nonatomic, readwrite, assign) NSUInteger indentationLevel;

@property (nonatomic, readwrite, assign) BOOL isSelected;

@property (nonatomic, readwrite, strong) NSArray *productListArray;

@property (nonatomic, readwrite, assign) NSUInteger totalCount;

@end

static GMCategoryModal *rootCategoryModal;

static NSString * const kCategoryIdKey                      = @"categoryId";
static NSString * const kParentIdKey                        = @"parentId";
static NSString * const kCategoryNameKey                    = @"categoryName";
static NSString * const kCategoryImageURLKey                = @"categoryImageURL";
static NSString * const kIsActiveKey                        = @"isActive";
static NSString * const kPositionKey                        = @"position";
static NSString * const kLevelKey                           = @"level";
static NSString * const kSubCategoriesKey                   = @"subCategories";
static NSString * const kIsExpandKey                        = @"isExpand";

@implementation GMCategoryModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"categoryId"                  : @"category_id",
             @"parentId"                    : @"parent_id",
             @"categoryName"                : @"name",
             @"categoryImageURL"            : @"images",
             @"isActive"                    : @"is_active",
             @"position"                    : @"position",
             @"level"                       : @"level",
             @"subCategories"               : @"children"
             };
}

+ (NSValueTransformer *)subCategoriesJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMCategoryModal class]];
}

+ (instancetype)loadRootCategory {
    
    rootCategoryModal = [self unarchiveRootCategory];
    return rootCategoryModal;
}

+ (GMCategoryModal *)unarchiveRootCategory {
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"category"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        GMCategoryModal *rootCategoryModal  = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        return rootCategoryModal;
    }
    return nil;
}

- (void)archiveRootCategory {
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"category"];
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:archivePath];
    DLOG(@"archived : %d",success);
}

#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.categoryId forKey:kCategoryIdKey];
    [aCoder encodeObject:self.parentId forKey:kParentIdKey];
    [aCoder encodeObject:self.categoryName forKey:kCategoryNameKey];
    [aCoder encodeObject:self.categoryImageURL forKey:kCategoryImageURLKey];
    [aCoder encodeObject:self.isActive forKey:kIsActiveKey];
    [aCoder encodeObject:self.position forKey:kPositionKey];
    [aCoder encodeObject:self.level forKey:kLevelKey];
    [aCoder encodeObject:self.subCategories forKey:kSubCategoriesKey];
    [aCoder encodeObject:@(self.isExpand) forKey:kIsExpandKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.categoryId = [aDecoder decodeObjectForKey:kCategoryIdKey];
        self.parentId = [aDecoder decodeObjectForKey:kParentIdKey];
        self.categoryName = [aDecoder decodeObjectForKey:kCategoryNameKey];
        self.categoryImageURL = [aDecoder decodeObjectForKey:kCategoryImageURLKey];
        self.isActive = [aDecoder decodeObjectForKey:kIsActiveKey];
        self.position = [aDecoder decodeObjectForKey:kPositionKey];
        self.level = [aDecoder decodeObjectForKey:kLevelKey];
        self.subCategories = [aDecoder decodeObjectForKey:kSubCategoriesKey];
        self.isExpand = [[aDecoder decodeObjectForKey:kIsExpandKey] boolValue];
    }
    return self;
}

#pragma mark - 

- (instancetype)initWithProductListDictionary:(NSDictionary *)responseDict {
    
    if(self = [super init]) {
        
        if(HAS_KEY(responseDict, @"product")) {
            
            NSMutableArray *productItemsArr = [NSMutableArray array];
            NSArray *items = responseDict[@"product"];
            for (NSDictionary *productDict in items) {
                
                NSError *mtlError = nil;
                GMProductModal *productModal = [MTLJSONAdapter modelOfClass:[GMProductModal class] fromJSONDictionary:productDict error:&mtlError];

                [productItemsArr addObject:productModal];
            }
            _productListArray = productItemsArr;
        }else if(HAS_KEY(responseDict, @"deals")) {
            
            NSMutableArray *productItemsArr = [NSMutableArray array];
            NSArray *items = responseDict[@"deals"];
            for (NSDictionary *productDict in items) {
                
                NSError *mtlError = nil;
                GMProductModal *productModal = [MTLJSONAdapter modelOfClass:[GMProductModal class] fromJSONDictionary:productDict error:&mtlError];
                
                [productItemsArr addObject:productModal];
            }
            _productListArray = productItemsArr;
        }
        
        if(HAS_DATA(responseDict, @"category_id"))
            _categoryId = responseDict[@"category_id"];
        
        if(HAS_DATA(responseDict, @"category_name"))
            _categoryName = responseDict[@"category_name"];
        else if(HAS_DATA(responseDict, @"name"))
            _categoryName = responseDict[@"name"];
        
        if(HAS_DATA(responseDict, @"images"))
            _categoryImageURL = responseDict[@"images"];
        
        if(HAS_DATA(responseDict, @"Totalcount"))//14/10/2015
            _totalCount = [responseDict[@"Totalcount"] integerValue];

        
    }
    return self;
}


@end
