//
//  GMCategoryModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "MTLModel.h"

@interface GMCategoryModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *categoryId;

@property (nonatomic, readonly, strong) NSString *parentId;

@property (nonatomic, readonly, strong) NSString *categoryName;

@property (nonatomic, readonly, strong) NSString *categoryImageURL;

@property (nonatomic, readonly, strong) NSString *isActive;

@property (nonatomic, readonly, strong) NSString *position;

@property (nonatomic, readonly, strong) NSString *level;

@property (nonatomic, readonly, strong) NSArray *subCategories;

@property (nonatomic, readonly, assign) BOOL isExpand;

@property (nonatomic, readonly, assign) NSUInteger indentationLevel;

@property (nonatomic, readonly, assign) BOOL isSelected;

@property (nonatomic, strong) NSString *offercount;

@property (nonatomic, readonly, strong) NSArray *productListArray;

@property (nonatomic, readonly, assign) NSUInteger totalCount;



+ (instancetype)loadRootCategory;

- (void)archiveRootCategory;

- (void)setCategoryId:(NSString *)categoryId;

- (void)setParentId:(NSString *)parentId;

- (void)setCategoryName:(NSString *)categoryName;

- (void)setCategoryImageURL:(NSString *)categoryImageURL;

- (void)setIsActive:(NSString *)isActive;

- (void)setPosition:(NSString *)position;

- (void)setLevel:(NSString *)level;

- (void)setSubCategories:(NSArray *)subCategories;

- (void)setIsExpand:(BOOL)isExpand;

- (void)setIndentationLevel:(NSUInteger)indentationLevel;

- (void)setIsSelected:(BOOL)isSelected;

-(void)setOffercount:(NSString *)offercount;

- (void)setProductListArray:(NSArray *)productListArray;

- (void)setTotalCount:(NSUInteger)totalCount;

#pragma mark - 

- (instancetype)initWithProductListDictionary:(NSDictionary *)responseDict;


@end
