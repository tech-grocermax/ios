//
//  AppDelegate.h
//  GrocerMax
//
//  Created by Deepak Soni on 08/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMNavigationController.h"
#import "AppsFlyerTracker.h"
#import "rocqAnalytics.h"
#import "QGSdk.h"

@class GMTabBarVC;
@class GMSearchVC;
@class GMProfileVC;

@class GMHomeVC;

@class GMHotDealVC;


@interface AppDelegate : UIResponder <UIApplicationDelegate,AppsFlyerTrackerDelegate>

@property (strong, nonatomic) RZMessagingWindow *errorWindow;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GMNavigationController *navController;

@property (nonatomic, strong) MMDrawerController *drawerController;

@property (nonatomic, strong) GMTabBarVC *tabBarVC;

- (void)setTopVCOnCenterOfDrawerController:(UIViewController*)topVC;

- (void)setTopVCOnHotDealsController:(UIViewController*)topVC;
- (UIViewController *)getTopControler;

- (void)popToCenterViewController;
//use for internal notification
-(void)openScreen:(NSString *)screenName data:(NSString *)value displayName:(NSString *)name;

-(GMSearchVC*) rootSearchVCFromFourthTab;

-(GMHomeVC*) rootHomeVCFromFourthTab;

- (void)goToHomeWithAnimation:(BOOL)animation;

-(GMProfileVC*) rootProfileVCFromSecondTab;

-(GMHotDealVC*) rootHotDealVCFromThirdTab;

-(void)ShowProcessingView;

-(void)HideProcessingView;

@end

