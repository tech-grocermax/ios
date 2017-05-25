//
//  GMOffersByDealTypeModal.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 24/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMOffersByDealTypeBaseModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *allArray;
@property (strong, nonatomic) NSArray *deal_categoryArray;
@property (assign, nonatomic) BOOL flag;

@end

@interface GMOffersByDealTypeModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *dealType;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *img;
@property (nonatomic, strong) NSArray *dealsArray;

- (instancetype)initWithDealType:(NSString *)dealType
                          dealId:(NSString *)dealId
                    dealImageUrl:(NSString *)imageUrl
                   andDealsArray:(NSArray *)dealsArray;
@end
