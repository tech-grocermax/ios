//
//  GMHomeBannerModal.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 04/10/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMHomeBannerBaseModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *bannerListArray;

@end

@interface GMHomeBannerModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *linkUrl;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *notificationId;

- (GMHomeBannerModal *)initWithDictionary:(NSDictionary *)notificationDetailDic;

@end
