//
//  GMLocalityBaseModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "MTLModel.h"

@interface GMLocalityBaseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSArray *localityArray;
@end

@interface GMLocalityModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSString *localityId;

@property (nonatomic, readonly, strong) NSString *localityName;

@property (nonatomic, readonly, strong) NSString *cityId;
@end