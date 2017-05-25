//
//  GMHomeModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 09/11/15.
//  Copyright © 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMHotDealBaseModal.h"
#import "GMHomeBannerModal.h"
#import "GMBannerModal.h"
#import "GMTrendingBaseModal.h"
#import "GMSubscriptionPopUp.h"

@interface GMHomeModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) GMCategoryModal *rootCategoryModal;

@property (nonatomic, readonly, strong) NSArray *hotDealArray;

@property (nonatomic, readonly, strong) NSArray *bannerListArray;

@property (nonatomic, readonly, strong) NSArray *categoryArray;

@property (nonatomic, readonly, strong) NSArray *specialDealArray;

@property (nonatomic, readonly, strong) NSString *imageUrl;

@property (nonatomic, readonly, strong) GMTrendingBaseModal *trendingBaseModal;

@property (nonatomic, readonly, strong) GMSubscriptionPopUp *subscriptionPopUp;
@end
