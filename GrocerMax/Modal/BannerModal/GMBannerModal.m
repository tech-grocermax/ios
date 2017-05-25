//
//  GMBannerModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 10/04/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMBannerModal.h"

@implementation GMBannerModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"bannerId"          : @"id",
             @"name"              : @"name",
             @"sku"               : @"sku",
             @"imageURL"          : @"imageurl",
             @"linkUrl"          : @"linkurl"
             };
}


- (instancetype)initWithBannerItemDict:(NSDictionary *)bannerDict;
{
    if(self = [super init]) {
        
        
        if(HAS_KEY(bannerDict, @"id")){
            _bannerId = [NSString stringWithFormat:@"%@",[bannerDict objectForKey:@"id"]];
        }
        if(HAS_KEY(bannerDict, @"name")){
            _name = [NSString stringWithFormat:@"%@",[bannerDict objectForKey:@"name"]];
        }
        if(HAS_KEY(bannerDict, @"sku")){
            _sku = [NSString stringWithFormat:@"%@",[bannerDict objectForKey:@"sku"]];
        }
        if(HAS_KEY(bannerDict, @"category_id")){
            _categoryId = [NSString stringWithFormat:@"%@",[bannerDict objectForKey:@"category_id"]];
        }
        
        if(HAS_KEY(bannerDict, @"imageurl") || HAS_KEY(bannerDict, @"imageUrl")){
            if(HAS_KEY(bannerDict, @"imageurl")){
                _imageURL = [NSString stringWithFormat:@"%@",[bannerDict objectForKey:@"imageurl"]];
            }else if(HAS_KEY(bannerDict, @"imageUrl")){
                _imageURL = [NSString stringWithFormat:@"%@",[bannerDict objectForKey:@"imageUrl"]];
            }
        }
        if(HAS_KEY(bannerDict, @"linkurl") || HAS_KEY(bannerDict, @"linkUrl")){
            if(HAS_KEY(bannerDict, @"linkurl")) {
                _linkUrl = [NSString stringWithFormat:@"%@",[bannerDict objectForKey:@"linkurl"]];
            } else if(HAS_KEY(bannerDict, @"linkUrl")) {
                _linkUrl = [NSString stringWithFormat:@"%@",[bannerDict objectForKey:@"linkUrl"]];
            }
        }
    }
    
    
    return self;
}
@end
