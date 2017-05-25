//
//  GMTrendingBaseModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 4/10/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GMTrendingBaseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSMutableArray *trendingArray;
@end

@interface GMTrendingModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *trendingId;

@property (nonatomic, strong) NSString *trendingName;

@property (nonatomic, strong) NSNumber *popularity;

@property (nonatomic, strong) NSNumber *numResults;

@property (nonatomic, strong) NSString *dataType;

@end
