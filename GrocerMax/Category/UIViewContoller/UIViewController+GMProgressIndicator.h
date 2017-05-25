//
//  UIViewController+GMProgressIndicator.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (GMProgressIndicator)

- (void)showProgress;
- (void)showProgressWithText:(NSString *)message;
- (void)removeProgress;

- (void)addLeftMenuButton;
- (void)addLogImageInNavBar;
- (void)menuButtonPressed:(UIBarButtonItem*)button;

#pragma mark - Search icon on Right nav bar

-(void)showSearchIconOnRightNavBarWithNavTitle:(NSString*)titleStr;
-(void)showSearchIconOnRightNavBarWithNavImage:(UIImage*)navImage;

#pragma mark - Set 2nd tab as profile VC

- (void)setSecondTabAsProfile;

-(void)adjustShareInsets:(UITabBarItem *)customTabBarItem;
@end
