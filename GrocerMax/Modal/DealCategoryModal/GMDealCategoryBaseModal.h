//
//  GMDealCategoryBaseModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 24/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "MTLModel.h"

@interface GMDealCategoryBaseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSArray *dealCategories;

@property (nonatomic, readonly, strong) NSArray *allDealCategory;

@property (nonatomic, readonly, strong) NSArray *dealNameArray;
@end

@interface GMDealCategoryModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *categoryId;

@property (nonatomic, readonly, strong) NSString *images;

@property (nonatomic, readonly, strong) NSString *categoryName;

@property (nonatomic, readonly, strong) NSString *isActive;

@property (nonatomic, readonly, strong) NSArray *deals;

- (instancetype) initWithCategoryId:(NSString *)categoryId
                             images:(NSString *)images
                       categoryName:(NSString *)categoryName
                           isActive:(NSString *)isActive
                           andDeals:(NSArray *)deals;
@end

@interface GMDealModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *dealId;

@property (nonatomic, readonly, strong) NSString *categoryId;

@property (nonatomic, readonly, strong) NSString *dealName;

@property (nonatomic, readonly, strong) NSString *img;
@end