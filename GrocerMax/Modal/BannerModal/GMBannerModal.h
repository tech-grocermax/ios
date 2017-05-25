//
//  GMBannerModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 10/04/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMBannerModal : MTLModel <MTLJSONSerializing>


@property (nonatomic, strong) NSString *bannerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *linkUrl;



- (instancetype)initWithBannerItemDict:(NSDictionary *)bannerDict;

@end
