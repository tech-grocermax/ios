//
//  GMProductListingVC.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMRootPageAPIController.h"
#import "GMProductModal.h"
#import "GMCategoryModal.h"
#import "GMRootPageViewController.h"


@interface GMProductListingVC : UIViewController

@property (strong, nonatomic) GMCategoryModal *catMdl;

@property (strong, nonatomic) GMRootPageAPIController *rootPageAPIController;
@property (assign, nonatomic) GMProductListingFromType productListingType;
@property (assign, nonatomic) GMRootPageViewControllerType productListPageViewType;



@property (nonatomic, strong) GMRootPageViewController *parentVC;

@property (nonatomic, strong) NSString *gaTrackingEventText; //14/10/2015

@property (assign, nonatomic) GMProductListingFromTypeForGA productListingFromTypeForGA;//18_June_2016 This is only use for GA Tracking


@end
