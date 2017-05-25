//
//  UIViewController+GMProgressIndicator.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "UIViewController+GMProgressIndicator.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AppDelegate.h"
#import "GMSearchBarView.h"
#import "GMProfileVC.h"

@implementation UIViewController (GMProgressIndicator)

- (void)showProgress {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    [self showProgressWithText:nil];
    [APP_DELEGATE ShowProcessingView];
}

- (void)showProgressWithText:(NSString *)message {
    
//    [SVProgressHUD setBackgroundColor:[UIColor gmRedColor]];
    [SVProgressHUD setForegroundColor:[UIColor colorFromHexString:@"#FFA800"]];
    [SVProgressHUD setRingThickness:1.0f];
    [SVProgressHUD setFont:FONT_REGULAR(13)];
//    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    //    [self.view setUserInteractionEnabled:NO];// added by R
    if (![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)removeProgress {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    //    [self.view setUserInteractionEnabled:YES];// added by R
//    [SVProgressHUD dismiss];
    [APP_DELEGATE HideProcessingView];
}

#pragma mark - Add 3 Bar Menu Btn on Left Nav Bar

- (void)addLeftMenuButton {
    
    UIImage *image = [[UIImage menuBtnImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (self.navigationItem.leftBarButtonItem == nil){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithImage:image
                                                 style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(menuButtonPressed:)];
    }
}

#pragma mark - Add Title View as logo image

- (void)addLogImageInNavBar {
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage logoImage]];
    imgView.frame = CGRectMake(0, 0, 1.64 * 40, 40);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imgView;
}

-(void)showSearchIconOnRightNavBarWithNavTitle:(NSString*)titleStr {
    
    self.navigationItem.titleView = nil;
    self.navigationItem.title = titleStr;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage searchIconImage]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(searchButtonPressed:)];
}

-(void)showSearchIconOnRightNavBarWithNavImage:(UIImage*)navImage {
    
    if (navImage == nil) {
        [self addLogImageInNavBar];
    }else{
        UIImageView *imgView = [[UIImageView alloc] initWithImage:navImage];
        imgView.frame = CGRectMake(0, 0, 1.64 * 40, 40);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.navigationItem.titleView = imgView;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithImage:[UIImage searchIconImage]
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(searchButtonPressed:)];
}

-(void)searchButtonPressed:(UIBarButtonItem*)sender {
    
    self.navigationItem.rightBarButtonItem = nil;
    
    GMSearchBarView *searchBarview = [GMSearchBarView searchBarObj];
    //    searchBarview.delegate = self;
    
    self.navigationItem.titleView = searchBarview;
}

#pragma mark - menu btn Action

- (void)menuButtonPressed:(UIBarButtonItem*)button {
    
    [self.view endEditing:YES];
    AppDelegate *appdel = APP_DELEGATE;
    
    if(appdel.drawerController.openSide == MMDrawerSideNone) {
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_OpenDrawer withCategory:@"" label:nil value:nil];
    } else {
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CloseDrawer withCategory:@"" label:nil value:nil];
    }
    
    [appdel.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Set 2nd tab as profile VC

- (void)setSecondTabAsProfile{
    
    GMProfileVC *profileVC = [[GMProfileVC alloc] initWithNibName:@"GMProfileVC" bundle:nil];
    UIImage *profileVCTabImg = [[UIImage imageNamed:@"profile_unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    UIImage *profileVCTabSelectedImg = [[UIImage imageNamed:@"profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    profileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:profileVCTabImg selectedImage:profileVCTabSelectedImg];
    [self adjustShareInsets:profileVC.tabBarItem];
    [[self.tabBarController.viewControllers objectAtIndex:1] setViewControllers:@[profileVC] animated:YES];
}

-(void)adjustShareInsets:(UITabBarItem *)customTabBarItem {
    [customTabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, 0.0)];
    [customTabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
}
@end
