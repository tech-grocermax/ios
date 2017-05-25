//
//  GMRootPageModelController.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMRootPageViewController.h"

@interface GMRootPageModelController : NSObject

@property (strong, nonatomic) NSArray *modelPageData;
@property (assign, nonatomic) GMRootPageViewControllerType rootControllerType;
@property (nonatomic, strong) GMRootPageViewController *rootPageViewController;
@property (assign, nonatomic) GMProductListingFromTypeForGA productListingFromTypeForGA;

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index ;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;

- (NSString*)titleNameFormModal:(id)mdl;

@end
