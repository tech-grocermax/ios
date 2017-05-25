//
//  UIViewController+MGTopNavigationBarViewController.h
//  FINDIT333
//
//  Created by rahul chaudhary on 10/01/15.
//  Copyright (c) 2015 Arvind Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMCommonNavBarView.h"
#import "UIViewController+GMProgressIndicator.h"

@interface UIViewController (MGTopNavigationBarViewController)

-(GMCommonNavBarView*)addBarViewWithTitle:(NSString*)titleString isRightButton:(BOOL)isRightButton;
@end
