//
//  GMStateBaseModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "MTLModel.h"

@interface GMStateBaseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSArray *stateArray;
@property (nonatomic, readonly, strong) NSArray *cityArray;
@end

@interface GMStateModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *regionId;

@property (nonatomic, readonly, strong) NSString *stateName;

@property (nonatomic, readonly, strong) NSArray *cityArray;
@end

@interface GMCityModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *cityId;

@property (nonatomic, readonly, strong) NSString *cityName;

@property (nonatomic, readonly, strong) NSString *stateId;

@property (nonatomic, readonly, strong) NSString *stateName;

@property (nonatomic, readonly, strong) NSString *storeId;

@property (nonatomic, readonly) BOOL isSelected;

- (void) setCityId:(NSString *)cityId;

- (void) setCityName:(NSString *)cityName;

- (void) setStateId:(NSString *)stateId;

- (void) setStateName:(NSString *)stateName;

- (void) setStoreId:(NSString *)storeId;

- (void) setIsSelected:(BOOL)isSelected;

+ (instancetype)selectedLocation;

- (void)persistLocation;
@end