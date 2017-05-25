//
//  GMHotDealVC.h
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMHotDealVC : UIViewController

- (void)fetchDealProductListingDataForOffersORDeals:(GMCategoryModal*)catMdl;
- (void)fetchDealProductListingDataForOffersORDeals:(GMCategoryModal*)catMdl withNotificationId:(NSString *)notificationId;

@end
