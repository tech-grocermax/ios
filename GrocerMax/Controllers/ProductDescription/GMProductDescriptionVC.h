//
//  GMProductDescriptionVC.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMProductModal.h"
#import "GMRootPageViewController.h"

@interface GMProductDescriptionVC : UIViewController

@property (strong, nonatomic) GMProductModal *modal;
@property (nonatomic, strong) GMRootPageViewController *parentVC;
@property (strong, nonatomic) NSString *notificationId;

@property (assign, nonatomic) GMProductListingFromTypeForGA productListingFromTypeForGA;//18_June_2016 This is only use for GA Tracking
@end
