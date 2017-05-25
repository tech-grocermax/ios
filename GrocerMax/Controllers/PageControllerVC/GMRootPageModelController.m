//
//  GMRootPageModelController.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRootPageModelController.h"
#import "GMCategoryModal.h"
#import "GMRootPageAPIController.h"
#import "GMProductListingVC.h"
#import "GMOffersVC.h"
#import "GMDealCategoryBaseModal.h"
#import "GMOffersByDealTypeModal.h"

@interface GMRootPageModelController ()

@property (strong, nonatomic) GMRootPageAPIController *rootPageAPIController;

@end

@implementation GMRootPageModelController


- (instancetype)init {
    self = [super init];
    if (self) {
        self.rootPageAPIController = [[GMRootPageAPIController alloc] init];
    }
    return self;
}

#pragma mark - methods

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    // Return the data view controller for the given index.
    if (([self.modelPageData count] == 0) || (index >= [self.modelPageData count])) {
        return nil;
    }
    
    switch (self.rootControllerType) {
        case  GMRootPageViewControllerTypeProductlisting:
        {
            GMProductListingVC *proListVC = [[GMProductListingVC alloc] initWithNibName:@"GMProductListingVC" bundle:nil];
            proListVC.catMdl = self.modelPageData[index];
            proListVC.rootPageAPIController = self.rootPageAPIController;
            proListVC.parentVC = self.rootPageViewController;
            proListVC.productListingType = GMProductListingFromTypeCategory;
            proListVC.productListPageViewType = GMRootPageViewControllerTypeProductlisting;
            proListVC.gaTrackingEventText =
            kEY_GA_Event_ProductListingThroughSubCategories;
            proListVC.productListingFromTypeForGA = self.productListingFromTypeForGA;

            return proListVC;
        }
            break;
        case  GMRootPageViewControllerTypeProductlistingCategory:
        {
            GMProductListingVC *proListVC = [[GMProductListingVC alloc] initWithNibName:@"GMProductListingVC" bundle:nil];
            proListVC.catMdl = self.modelPageData[index];
            proListVC.rootPageAPIController = self.rootPageAPIController;
            proListVC.parentVC = self.rootPageViewController;
            proListVC.productListingType = GMProductListingFromTypeCategory;
            proListVC.productListPageViewType = GMRootPageViewControllerTypeProductlistingCategory;
            proListVC.gaTrackingEventText =
            kEY_GA_Event_ProductListingThroughSubCategories;
            proListVC.productListingFromTypeForGA = self.productListingFromTypeForGA;
            
            return proListVC;
        }
            break;
        case GMRootPageViewControllerTypeOffersByDealTypeListing:
        {
            GMOffersVC *offersVC = [[GMOffersVC alloc] initWithNibName:@"GMOffersVC" bundle:nil];
            offersVC.rootControllerType = GMRootPageViewControllerTypeOffersByDealTypeListing;
            offersVC.data = self.modelPageData[index];
            offersVC.parentVC = self.rootPageViewController;
            offersVC.gaTrackingEventText = kEY_GA_Event_OffersThroughOffersDealsCategory;
            
            return offersVC;
        }
            break;
            
        case GMRootPageViewControllerTypeDealCategoryTypeListing:
        {
            GMOffersVC *offersVC = [[GMOffersVC alloc] initWithNibName:@"GMOffersVC" bundle:nil];
            offersVC.rootControllerType = GMRootPageViewControllerTypeDealCategoryTypeListing;
            offersVC.data = self.modelPageData[index];
            offersVC.parentVC = self.rootPageViewController;
            offersVC.gaTrackingEventText = kEY_GA_Event_OffersThroughDealCategory;

            return offersVC;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController{

    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    
    switch (self.rootControllerType) {
        case  GMRootPageViewControllerTypeProductlisting:
        {
            GMProductListingVC *proListVC = (GMProductListingVC*)viewController;
            return [self.modelPageData indexOfObject:proListVC.catMdl];
        }
            break;
        case  GMRootPageViewControllerTypeProductlistingCategory:
        {
            GMProductListingVC *proListVC = (GMProductListingVC*)viewController;
            return [self.modelPageData indexOfObject:proListVC.catMdl];
        }
            break;
        case GMRootPageViewControllerTypeOffersByDealTypeListing:
        {
            GMOffersVC *offersVC = (GMOffersVC*)viewController;
            return [self.modelPageData indexOfObject:offersVC.data];
        }
            break;
        case GMRootPageViewControllerTypeDealCategoryTypeListing:
        {
            GMOffersVC *offersVC = (GMOffersVC*)viewController;
            return [self.modelPageData indexOfObject:offersVC.data];
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (NSString*)titleNameFormModal:(id)mdl{
    
    switch (self.rootControllerType) {
        case  GMRootPageViewControllerTypeProductlisting:
        case  GMRootPageViewControllerTypeProductlistingCategory:
        {
            GMCategoryModal *catMdl = mdl;
            return catMdl.categoryName;
        }
            break;
        case GMRootPageViewControllerTypeOffersByDealTypeListing:
        {
            GMOffersByDealTypeModal *offersDealTypeModal = mdl;
            return offersDealTypeModal.dealType;
        }
            break;
        case GMRootPageViewControllerTypeDealCategoryTypeListing:
        {
            GMDealCategoryModal *modal = mdl;
            return modal.categoryName;
        }
            break;
            
        default:
            break;
    }
    
    return @"";
}


@end
