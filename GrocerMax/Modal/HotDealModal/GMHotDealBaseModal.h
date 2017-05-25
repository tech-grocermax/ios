//
//  GMHotDealModal.h
//  GrocerMax
//
//  Created by arvind gupta on 23/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMHotDealBaseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSArray *hotDealArray;

- (void)setHotDealArray:(NSArray *)hotDealArray;

+ (instancetype)loadHotDeals;

- (void)archiveHotDeals;
@end

@interface GMHotDealModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *dealTypeId;

@property (nonatomic, readonly, strong) NSString *dealType;

@property (nonatomic, readonly, strong) NSString *imageName;

@property (nonatomic, readonly, strong) NSString *imageURL;

@property (nonatomic, readonly, strong) NSString *bigImageURL;

- (void)setDealTypeId:(NSString *)dealTypeId;

- (void) setDealType:(NSString *)dealType;

- (void) setImageName:(NSString *)imageName;

- (void) setImageURL:(NSString *)imageURL;

- (void)setBigImageURL:(NSString *)bigImageURL;
@end
