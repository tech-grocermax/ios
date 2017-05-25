//
//  GMOffersVC.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRootPageAPIController.h"
#import "GMProductModal.h"
#import "GMCategoryModal.h"
#import "GMRootPageViewController.h"

@interface GMOffersVC : UIViewController

@property (strong, nonatomic) id data;
@property (assign, nonatomic) GMRootPageViewControllerType rootControllerType;
@property (nonatomic, strong) GMRootPageViewController *parentVC;
@property (nonatomic, strong) NSString *gaTrackingEventText;


@end
