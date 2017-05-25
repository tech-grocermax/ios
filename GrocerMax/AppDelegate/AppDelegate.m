//
//  AppDelegate.m
//  GrocerMax
//
//  Created by Deepak Soni on 08/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "AppDelegate.h"
#import "GMLoginVC.h"
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "GMTabBarVC.h"
#import "GMHomeVC.h"
#import "GMLeftMenuVC.h"
#import "GMHotDealVC.h"
#import "GMSearchVC.h"
#import "GMProfileVC.h"
#import "GMHomeBannerModal.h"
#import "GMOffersByDealTypeModal.h"
#import "GMDealCategoryBaseModal.h"
#import "GMRootPageViewController.h"
#import "UIGifImage.h"
#import <GoogleAnalytics/GAI.h>
#import "GMHotDealVC.h"
#import "GMStateBaseModal.h"
#import <SVProgressHUD/SVIndefiniteAnimatedView.h>
#import "GMCartVC.h"
#import "GMProductDescriptionVC.h"
#import "GMWebViewVC.h"
#import "GMSinglePageVC.h"

#define TAG_PROCESSING_INDECATOR 100090

static NSString *const kGaPropertyId = @"UA-64820863-1";

static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 20;
static NSString *const kRocqAnalyticsSecret = @"e12ff641b2";


@interface AppDelegate ()<LeftMenuDelegate>
{
    UIAlertView *alert;
}

//@property (nonatomic, strong) XHDrawerController *drawerController;
@property (nonatomic, strong) GMCategoryModal *rootCategoryModal;
@property (nonatomic, strong) GMHomeBannerModal *pushModal;
@property (nonatomic, strong) SVIndefiniteAnimatedView *indefiniteAnimatedView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
//    [self fetchAllCategories];
    
    // for ios 8 and above
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        // for iOS 8 below
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    [AppsFlyerTracker sharedTracker].appleAppID = APPLE_APP_ID; // The Apple app ID. Example 34567899
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = AppsFyler_Key;
//    [self sendDeviceToken:@"d6a39b42ca6636de31f4c9e7dbdfd3fca5c731f928b81ad65181009eefd3cf98"];
    
    
#warning change setDevProfile to no for live app

    //replace <your app id> with the one you received from QGraph
    [[QGSdk getSharedInstance] onStart:QGRAPH_APP_ID setDevProfile:YES];
    //add this method to track app launch through QGraph notification click
    [[QGSdk getSharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    
    
    
    //https://developers.google.com/identity/sign-in/ios/offline-access
    [self initializeGoogleAnalytics];
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    if (configureError != nil) {
        NSLog(@"Error configuring the Google context: %@", configureError);
    }
    
    [GIDSignIn sharedInstance].clientID = @"522049028388-d290uain6f364tvk38ee8h82av0b7aep.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].serverClientID = @"522049028388-d290uain6f364tvk38ee8h82av0b7aep.apps.googleusercontent.com";
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [rocqAnalytics setAppsecret:kRocqAnalyticsSecret];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    self.tabBarVC = [[GMTabBarVC alloc] init];
    
    GMLeftMenuVC *leftMenuVC = [[GMLeftMenuVC alloc] initWithNibName:@"GMLeftMenuVC" bundle:nil];
    leftMenuVC.delegate = self;
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.tabBarVC leftDrawerViewController:[[UINavigationController alloc] initWithRootViewController:leftMenuVC]];
    self.drawerController.maximumLeftDrawerWidth = 260.0;
    
    self.navController.navigationBarHidden = YES;
    self.window.rootViewController = self.drawerController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [rocqAnalytics setRQDebugMode:NO];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[AppsFlyerTracker sharedTracker] trackAppLaunch]; //***** THIS LINE IS MANDATORY *****
    
    [AppsFlyerTracker sharedTracker].delegate = self;
    
    GMCartModal *cartModal = [GMCartModal loadCart];
    if(cartModal.cartItems.count>0) {
        [[GMSharedClass sharedClass] saveBackGroundInTime:YES];
    }else {
        [[GMSharedClass sharedClass] saveBackGroundInTime:NO];
    }

    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self.window makeKeyAndVisible];
    if ( self.errorWindow == nil ) {
        self.errorWindow = [RZMessagingWindow defaultMessagingWindow];
        [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
    }
    
    [FBSDKAppEvents activateApp];
    
    //    -(void)saveBackGroundInTime:(BOOL)isSaved
    //    -(BOOL)checkConditionInBackGroundTime
    if([[GMSharedClass sharedClass] checkConditionInBackGroundTime]){
        GMCartVC *cartVC = [self rootCartVCFromFiftTab];
        if (cartVC == nil)
            return ;
        
        [cartVC.navigationController popToRootViewControllerAnimated:NO];
        [self goToHomeWithAnimation:YES];
    }else{
        [[GMSharedClass sharedClass] saveBackGroundInTime:NO];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    
//    [rocqAnalytics deepLink:[url host]];
    
    NSDictionary *deepLinkData=[[NSDictionary alloc]init];
    
    deepLinkData=[rocqAnalytics parseQueryString:[url query]];
    
    
    BOOL isFB = YES;
    if([[url absoluteString] rangeOfString:@"grocermax"].location != NSNotFound && [[url absoluteString] rangeOfString:@"grocermax"].location != NSNotFound)
    {
        
        if([GMCityModal selectedLocation] == nil) {
            return YES;
        }
        [self deepLinkingUrl:url];

        return YES;
        
    }
    
    if([[url absoluteString] rangeOfString:@"com.googleusercontent.apps.522049028388-d290uain6f364tvk38ee8h82av0b7aep"].location != NSNotFound && [[url absoluteString] rangeOfString:@"com.googleusercontent.apps.522049028388-d290uain6f364tvk38ee8h82av0b7aep"].location != NSNotFound)
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
        
    }
    
    if (isFB) {
    
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }return TRUE;
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    
//    [rocqAnalytics deepLink:[url host]];
    
    NSString *source = @"";
    if([options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey]) {
        source = [options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey];
    }
//    if(NSSTRING_HAS_DATA(source)) {
//        [rocqAnalytics deepLink:source];
//    }
    
    
    NSDictionary *deepLinkData=[[NSDictionary alloc]init];
    
    deepLinkData=[rocqAnalytics parseQueryString:[url query]];
        
    BOOL isFB = YES;
    if([[url absoluteString] rangeOfString:@"grocermax"].location != NSNotFound && [[url absoluteString] rangeOfString:@"grocermax"].location != NSNotFound)
    {
        if([GMCityModal selectedLocation] == nil) {
            return YES;
        }
        [self deepLinkingUrl:url];
        return YES;
        
    }
//    NSString *source = @"";
//    if([options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey]) {
//        source = [options objectForKey:UIApplicationOpenURLOptionsSourceApplicationKey];
//    }
    
    if([[url absoluteString] rangeOfString:@"com.googleusercontent.apps.522049028388-d290uain6f364tvk38ee8h82av0b7aep"].location != NSNotFound && [[url absoluteString] rangeOfString:@"com.googleusercontent.apps.522049028388-d290uain6f364tvk38ee8h82av0b7aep"].location != NSNotFound)
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:source
                                          annotation:options];
    
    }
    
    if (isFB) {
    
//        UIApplicationOpenURLOptionsSourceApplicationKey
        
        
        return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              openURL:url
                                                    sourceApplication:source
                                                           annotation:options];
    }
    
    return YES;
}

-(void)deepLinkingUrl:(NSURL *)url {
    
    self.pushModal = nil;
    
    if([GMCityModal selectedLocation] == nil) {
        return;
    }
    NSString *value = @"";
    NSString *name = @"";
    NSArray* componentsArray = [[url absoluteString] componentsSeparatedByString:@"?"];
    if([componentsArray count]>1)
    {
        NSString* paramsStr = [componentsArray objectAtIndex:1];
        NSArray* paramsArray = [paramsStr componentsSeparatedByString:@"&"];
        for(NSString* str in paramsArray)
        {
            NSArray* paramsValuesArray = [str componentsSeparatedByString:@"="];
            if([[paramsValuesArray objectAtIndex:0] isEqualToString:@"data"])
            {
                value = [[paramsValuesArray objectAtIndex:1] stringByRemovingPercentEncoding];
                
            } else if([[paramsValuesArray objectAtIndex:0] isEqualToString:@"name"])
            {
                name = [[paramsValuesArray objectAtIndex:1] stringByRemovingPercentEncoding];
                
            }
        }
    }
    
    
    if([[url absoluteString] rangeOfString:KEY_Banner_Home].location != NSNotFound) {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return ;
        
        [tabBarVC setSelectedIndex:0];
        [self performSelector:@selector(goToHome) withObject:nil afterDelay:0.20];
    }
    else if([[url absoluteString] rangeOfString:KEY_Banner_shopbydealtype].location != NSNotFound) {
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return ;
        
        [tabBarVC setSelectedIndex:2];
//        [tabBarVC.viewControllers objectAtIndex:2];
    } else if([[url absoluteString] rangeOfString:KEY_Banner_search].location != NSNotFound) {
        
        NSMutableDictionary *localDic = [NSMutableDictionary new];
        [localDic setObject:value forKey:kEY_keyword];
        
        [self.tabBarVC  setSelectedIndex:3];
        GMSearchVC *searchVC = [APP_DELEGATE rootSearchVCFromFourthTab];
        if (searchVC == nil)
            return ;
        [searchVC performSearchOnServerWithParam:localDic isBanner:YES];
        
        
    } else if([[url absoluteString] rangeOfString:KEY_Banner_offerbydealtype].location != NSNotFound) {
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(name)) {
            bannerCatMdl.categoryName = name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
        [self getOffersDealFromServerWithCategoryModal:bannerCatMdl];
        
        
    } else if([[url absoluteString] rangeOfString:KEY_Banner_dealsbydealtype].location != NSNotFound) {
        
        [self fetchDealCategoriesFromServerWithDealTypeId:value];
        
    } else if([[url absoluteString] rangeOfString:KEY_Banner_productlistall].location != NSNotFound) {
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(name)) {
            bannerCatMdl.categoryName = name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
        
        [self fetchProductListingDataForCategory:bannerCatMdl];
        
        
    } else if([[url absoluteString] rangeOfString:KEY_Banner_dealproductlisting].location != NSNotFound) {
        
        GMHotDealVC *hotDealVC = [self rootHotDealVCFromThirdTab];
        if (hotDealVC == nil)
            return ;
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(name)) {
            bannerCatMdl.categoryName = name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
        [hotDealVC fetchDealProductListingDataForOffersORDeals:bannerCatMdl];
        
        
    }else if([[url absoluteString] rangeOfString:KEY_Notification_Productdetail].location != NSNotFound){
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return ;
        [tabBarVC setSelectedIndex:0];
        
        GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
        GMProductModal *productModal = [[GMProductModal alloc]init];
        productModal.productid = value;
        vc.modal = productModal;
        vc.parentVC = nil;
        UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
        
        [centerNavVC pushViewController:vc animated:YES];
        
        
    }else if([[url absoluteString] rangeOfString:KEY_Notification_Specialdeal].location != NSNotFound)
    {
        NSString *stringName = @"Result";
        if(NSSTRING_HAS_DATA(name)) {
            stringName = name;
        }
        [self specailBanner:value categoryId:@"-1" name:stringName];
        
    }else if([[url absoluteString] rangeOfString:KEY_Notification_Singlepage].location != NSNotFound)
    {
        GMSinglePageVC *singlePageVC = [[GMSinglePageVC alloc]init];
        singlePageVC.bannerSinglePageId = value;
        singlePageVC.displayName = name;
        
        [self.tabBarVC  setSelectedIndex:0];
        GMHomeVC *homeVC  = [self rootHomeVCFromFourthTab];
        [homeVC.navigationController pushViewController:singlePageVC animated:YES];
        
    }

}

-(void)openScreen:(NSString *)screenName data:(NSString *)value displayName:(NSString *)name{
    if([screenName isEqualToString:KEY_Notification_Home]) {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return ;
        
        [tabBarVC setSelectedIndex:0];
        [self performSelector:@selector(goToHome) withObject:nil afterDelay:0.20];
    }
    else if([screenName isEqualToString:KEY_Notification_shopbydealtype]) {
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return ;
        
        [tabBarVC setSelectedIndex:2];
        //        [tabBarVC.viewControllers objectAtIndex:2];
    } else if([screenName isEqualToString:KEY_Notification_search]) {
        
        NSMutableDictionary *localDic = [NSMutableDictionary new];
        [localDic setObject:value forKey:kEY_keyword];
        
        [self.tabBarVC  setSelectedIndex:3];
        GMSearchVC *searchVC = [APP_DELEGATE rootSearchVCFromFourthTab];
        if (searchVC == nil)
            return ;
        [searchVC performSearchOnServerWithParam:localDic isBanner:YES];
        
        
    } else if([screenName isEqualToString:KEY_Notification_offerbydealtype]) {
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(name)) {
            bannerCatMdl.categoryName = name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
        [self getOffersDealFromServerWithCategoryModal:bannerCatMdl];
        
        
    } else if([screenName isEqualToString:KEY_Notification_dealsbydealtype]) {
        
        [self fetchDealCategoriesFromServerWithDealTypeId:value];
        
    } else if([screenName isEqualToString:KEY_Notification_productlistall]) {
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(name)) {
            bannerCatMdl.categoryName = name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
        
        [self fetchProductListingDataForCategory:bannerCatMdl];
        
        
    } else if([screenName isEqualToString:KEY_Notification_dealproductlisting]) {
        
        GMHotDealVC *hotDealVC = [self rootHotDealVCFromThirdTab];
        if (hotDealVC == nil)
            return ;
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(name)) {
            bannerCatMdl.categoryName = name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
        [hotDealVC fetchDealProductListingDataForOffersORDeals:bannerCatMdl];
        
        
    }else if([screenName isEqualToString:KEY_Notification_Profile]) {
        
        [self.tabBarVC  setSelectedIndex:1];
        GMProfileVC *profileVc = [self rootProfileVCFromSecondTab];
        if (profileVc == nil)
            return ;
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
        [centerNavVC popToViewController:profileVc animated:YES];
        
        
    }else if([screenName isEqualToString:KEY_Notification_LogOut]) {
        GMTabBarVC *privioustabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        UINavigationController *priviouscenterNavVC = [privioustabBarVC.viewControllers objectAtIndex:privioustabBarVC.selectedIndex];
        [priviouscenterNavVC popToRootViewControllerAnimated:YES];
        
        [[GMSharedClass sharedClass] logout];
        [[GMSharedClass sharedClass] clearCart];
        [self.tabBarVC updateBadgeValueOnCartTab];
         
        [self.tabBarVC  setSelectedIndex:1];
        GMProfileVC *profileVc = [self rootProfileVCFromSecondTab];
        
        if (profileVc == nil)
            return ;
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
        [centerNavVC popToViewController:profileVc animated:YES];
        
        [profileVc setSecondTabAsLogIn];
        
        
    }else if([screenName isEqualToString:KEY_Notification_ViewCart]) {
        
        [self.tabBarVC  setSelectedIndex:4];
        GMCartVC *cartVC = [self rootCartVCFromFiftTab];
        if (cartVC == nil)
            return ;
        
        if([cartVC isKindOfClass:[GMCartVC class]]) {
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
        [centerNavVC popToViewController:cartVC animated:YES];
        }
        
    }else if([screenName isEqualToString:KEY_Notification_Productdetail]) {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return ;
        [tabBarVC setSelectedIndex:0];
        
        GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
        GMProductModal *productModal = [[GMProductModal alloc]init];
        productModal.productid = value;
        vc.modal = productModal;
        vc.parentVC = nil;
        
        UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
        
        [centerNavVC pushViewController:vc animated:YES];
        
        
    }else if([screenName isEqualToString:KEY_Notification_Specialdeal]) {
        [self specailBanner:value categoryId:@"-1" name:name];
        
    }else if([screenName isEqualToString:KEY_Notification_Singlepage])
    {
        GMSinglePageVC *singlePageVC = [[GMSinglePageVC alloc]init];
        singlePageVC.bannerSinglePageId = value;
        singlePageVC.displayName = name;
        
        [self.tabBarVC  setSelectedIndex:0];
        GMHomeVC *homeVC  = [self rootHomeVCFromFourthTab];
        [homeVC.navigationController pushViewController:singlePageVC animated:YES];
        
    }else if([screenName isEqualToString:KEY_Notification_Upgrade])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/grocermax.com-online-grocery/id1049822835?ls=1&mt=8"]];
        
    }else {
        
//        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
//        if (tabBarVC == nil)
//            return ;
//        [tabBarVC setSelectedIndex:0];
//        [self performSelector:@selector(goToHome) withObject:nil afterDelay:0.20];
    }

}

-(void) goToHome{
    GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
    UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
    for (UIViewController *vc in [centerNavVC viewControllers]) {// pop to dashboard
        
        if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMHomeVC class])]) {
            [centerNavVC popToViewController:vc animated:YES];
            break;
        }
    }
}
#pragma mark - PushNotification Delgate

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
//    NSLog(@"My Device token is: %@", deviceToken);
    
    [[QGSdk getSharedInstance] setToken:deviceToken];

    [rocqAnalytics setDeviceToken:deviceToken];
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:kEY_notification_token];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self sendDeviceToken:deviceTokenString];
    
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
//    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    [rocqAnalytics trackPush:userInfo];
    
    if([application applicationState] == UIApplicationStateActive)
    {
        if(alert)
        {
            [alert dismissWithClickedButtonIndex:-1 animated:YES];
            alert = nil;
        }
        self.pushModal = nil;
        [self makePushModal:userInfo];
        NSString *alertMsg = @"Notification";
        if( [[userInfo objectForKey:Keyaps] objectForKey:Keyalert] != NULL && [[[userInfo objectForKey:Keyaps] objectForKey:Keyalert] isKindOfClass:[NSString class]])
            alertMsg = [[userInfo objectForKey:Keyaps] objectForKey:Keyalert];
        
        alert = [[UIAlertView alloc]initWithTitle:key_TitleMessage  message:alertMsg delegate:self cancelButtonTitle:Cancel_Text otherButtonTitles:@"GO",nil, nil];
        [alert show];
        
    }
    else if([application applicationState] == UIApplicationStateBackground)
    {
        self.pushModal = nil;
        [self makePushModal:userInfo];
        [self goFromNotifiedScreen];
        self.pushModal = nil;
    }
    else
    {
        self.pushModal = nil;
        [self makePushModal:userInfo];
        [self goFromNotifiedScreen];
        self.pushModal = nil;
    }
    
    // Please make sure you add this method
    [[QGSdk getSharedInstance] application:application didReceiveRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNoData);
    NSLog(@"Notification Delivered");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[QGSdk getSharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - Push Modal maker Method

- (void)makePushModal:(NSDictionary *)dataResultDec {
    
    if([dataResultDec objectForKey:@"messageType"] && [[dataResultDec objectForKey:@"messageType"] isEqualToString:@"rq_disp"]) {
        if([dataResultDec objectForKey:@"url"] && [[dataResultDec objectForKey:@"url"] isKindOfClass:[NSString class]])
        {
            NSString *resultString = [dataResultDec objectForKey:@"url"];
            NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *localError = nil;
            NSMutableDictionary *resultDec = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            if(localError == nil) {
            self.pushModal = [[GMHomeBannerModal alloc] initWithDictionary:resultDec];
            }
        }
        
    }
    else if([dataResultDec objectForKey:@"data"] && [[dataResultDec objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *resultDec = [dataResultDec objectForKey:@"data"];
        self.pushModal = [[GMHomeBannerModal alloc] initWithDictionary:resultDec];
    }
    else if([dataResultDec objectForKey:@"source"] && [[dataResultDec objectForKey:@"source"] isEqualToString:@"QG"]) {
        
        if([dataResultDec objectForKey:@"deepLink"] && NSSTRING_HAS_DATA([dataResultDec objectForKey:@"deepLink"])){
            
//            NSString *deepLinkUrl = [dataResultDec objectForKey:@"deepLink"];
//            
//            self.pushModal = [[GMHomeBannerModal alloc] init];
//            self.pushModal.linkUrl = deepLinkUrl;
            
            NSString *resultString = [dataResultDec objectForKey:@"deepLink"];
            NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *localError = nil;
            NSMutableDictionary *resultDec = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
            if(localError == nil) {
                self.pushModal = [[GMHomeBannerModal alloc] initWithDictionary:resultDec];
            }
            
            
        }
      }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(buttonIndex == 1)
        {
                [self performSelector:@selector(goFromNotifiedScreen) withObject:nil afterDelay:0];
        }
}

#pragma mark - Notification Handle Method

- (void)sendDeviceToken:(NSString*)deviceToken {
    
    NSMutableDictionary *deviceDic = [NSMutableDictionary new];
    [deviceDic setObject:deviceToken forKey:@"deviceToken"];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    if(userModal != nil && NSSTRING_HAS_DATA(userModal.userId)) {
        [deviceDic setObject:userModal.userId forKey:kEY_userid];
    }
    if(userModal != nil && NSSTRING_HAS_DATA(userModal.email)) {
        [deviceDic setObject:userModal.email forKey:kEY_email];
    }
    if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName)) {
        [deviceDic setObject:userModal.firstName forKey:kEY_fname];
    }
    
    [[GMOperationalHandler handler] deviceToken:deviceDic withSuccessBlock:^(id responceData) {
        
        
    } failureBlock:^(NSError *error) {

    }];
}

- (void) goFromNotifiedScreen {
    
    if([GMCityModal selectedLocation] == nil) {
        return;
    }
    
    if (!NSSTRING_HAS_DATA(self.pushModal.linkUrl)) {
        return;
    }
    
    NSArray *typeStringArr = [self.pushModal.linkUrl componentsSeparatedByString:@"?"];
    NSString *typeStr = typeStringArr.firstObject;
    NSArray *valueStringArr = [self.pushModal.linkUrl componentsSeparatedByString:@"="];
    NSString *value = valueStringArr.lastObject;
    if([self.pushModal.linkUrl isEqualToString:KEY_Banner_Home]) {
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return ;
        
        [tabBarVC setSelectedIndex:0];
        [self performSelector:@selector(goToHome) withObject:nil afterDelay:0.20];
    }
    else if ([self.pushModal.linkUrl isEqualToString:KEY_Banner_shopbydealtype]) {
            GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return;
            [tabBarVC.viewControllers objectAtIndex:2];
        return;
    }
    
    if (!(NSSTRING_HAS_DATA(typeStr) && NSSTRING_HAS_DATA(value))) {
        return;
    }
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_BannerSelection withCategory:self.pushModal.linkUrl label:value value:nil];
    
    if ([typeStr isEqualToString:KEY_Banner_search]) {
        
        NSMutableDictionary *localDic = [NSMutableDictionary new];
        [localDic setObject:value forKey:kEY_keyword];
        
        if(NSSTRING_HAS_DATA(self.pushModal.notificationId)) {
            [localDic setObject:self.pushModal.notificationId forKey:KEY_Notification_Id];
        }
        
        [self.tabBarVC  setSelectedIndex:3];
        GMSearchVC *searchVC = [APP_DELEGATE rootSearchVCFromFourthTab];
        if (searchVC == nil)
            return;
        [searchVC performSearchOnServerWithParam:localDic isBanner:YES];
        
    }else if ([typeStr isEqualToString:KEY_Banner_offerbydealtype]) {
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(self.pushModal.name)) {
            bannerCatMdl.categoryName = self.pushModal.name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
//        bannerCatMdl.categoryName = @"Banner Result";
        
        [self getOffersDealFromServerWithCategoryModal:bannerCatMdl];
        
    }else if ([typeStr isEqualToString:KEY_Banner_dealsbydealtype]) {
        
        [self fetchDealCategoriesFromServerWithDealTypeId:value];
        
    }else if ([typeStr isEqualToString:KEY_Banner_productlistall]) {
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
        if(NSSTRING_HAS_DATA(self.pushModal.name)) {
            bannerCatMdl.categoryName = self.pushModal.name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
//        bannerCatMdl.categoryName = @"Banner Result";
        
        [self fetchProductListingDataForCategory:bannerCatMdl];
    } else if ([typeStr isEqualToString:KEY_Banner_dealproductlisting]) {
        
        GMHotDealVC *hotDealVC = [self rootHotDealVCFromThirdTab];
        if (hotDealVC == nil)
            return;
        
        GMCategoryModal *bannerCatMdl = [GMCategoryModal new];
        bannerCatMdl.categoryId = value;
//        bannerCatMdl.categoryName = @"Banner Result";
        if(NSSTRING_HAS_DATA(self.pushModal.name)) {
            bannerCatMdl.categoryName = self.pushModal.name;
        } else {
            bannerCatMdl.categoryName = @"Result";
        }
        NSString *notificationId = @"";
        if(NSSTRING_HAS_DATA(self.pushModal.notificationId)) {
            notificationId = self.pushModal.notificationId;
        }
        [hotDealVC fetchDealProductListingDataForOffersORDeals:bannerCatMdl withNotificationId:notificationId];
    }else if([typeStr isEqualToString:KEY_Notification_Productdetail]){
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        if (tabBarVC == nil)
            return ;
        [tabBarVC setSelectedIndex:0];
        
        GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
        GMProductModal *productModal = [[GMProductModal alloc]init];
        NSString *notificationId = @"";
        if(NSSTRING_HAS_DATA(self.pushModal.notificationId)) {
            notificationId = self.pushModal.notificationId;
        }
        vc.notificationId = notificationId;
        productModal.productid = value;
        vc.modal = productModal;
        vc.parentVC = nil;
        UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
        [centerNavVC pushViewController:vc animated:YES];
        
    }else if([typeStr isEqualToString:KEY_Notification_Specialdeal])
    {
        NSString *stringName = @"Result";
        if(NSSTRING_HAS_DATA(self.pushModal.name)) {
            stringName = self.pushModal.name;
        }
        [self specailBanner:value categoryId:@"-1" name:stringName];
    }else if([typeStr isEqualToString:KEY_Notification_Singlepage])
    {
        GMSinglePageVC *singlePageVC = [[GMSinglePageVC alloc]init];
        singlePageVC.bannerSinglePageId = value;
        singlePageVC.displayName = self.pushModal.name;
        
        [self.tabBarVC  setSelectedIndex:0];
        GMHomeVC *homeVC  = [self rootHomeVCFromFourthTab];
        [homeVC.navigationController pushViewController:singlePageVC animated:YES];
        
    }

    
}


-(void)specailBanner:(NSString *)sku categoryId:(NSString *)categoryId name:(NSString *)name {
    [self.tabBarVC  setSelectedIndex:0];
    GMHomeVC *homeVC  = [self rootHomeVCFromFourthTab];
    [homeVC specailBanner:sku categoryId:categoryId name:name];
    
}
#pragma mark - offersByDeal

- (void)getOffersDealFromServerWithCategoryModal:(GMCategoryModal*)categoryModal {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:categoryModal.categoryId forKey:kEY_cat_id];
    [localDic setObject:kEY_iOS forKey:kEY_device];
    
    if(NSSTRING_HAS_DATA(self.pushModal.notificationId)) {
        [localDic setObject:self.pushModal.notificationId forKey:KEY_Notification_Id];
    }
    
    [self ShowProcessingView];
    [[GMOperationalHandler handler] getOfferByDeal:localDic withSuccessBlock:^(id offersByDealTypeBaseModal) {
        
        [self HideProcessingView];
        
        GMProductListingBaseModal *productListingBaseMdl = offersByDealTypeBaseModal;
        
        // All Cat list side by ALL Tab
        NSMutableArray *categoryArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.hotProductListArray) {
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // All products, for ALL Tab category
        NSMutableArray *allCatProductListArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.productsListArray) {
            [allCatProductListArray addObjectsFromArray:catMdl.productListArray];
            
            if (catMdl.productListArray.count >= 1) {
                
                //                if(!NSSTRING_HAS_DATA(catMdl.categoryId)) {
                //                    catMdl.categoryId = @"0";
                //                }
                [categoryArray addObject:catMdl];
            }
        }
        
        // set all product list in ALL tab category mdl
        categoryModal.productListArray = allCatProductListArray;
        
        // set this cat modal as ALL tab
        [categoryArray insertObject:categoryModal atIndex:0];
        
        if (categoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
            [[GMSharedClass sharedClass] showErrorMessage:@"Sorry, No products listed in this category"];
            return ;
        }
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.navigationTitleString = categoryModal.categoryName;
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeDealGA;
//        [self.navigationController pushViewController:rootVC animated:YES];
        
        [self.tabBarVC  setSelectedIndex:0];
       GMHomeVC *homeVC  = [self rootHomeVCFromFourthTab];
        [homeVC.navigationController pushViewController:rootVC animated:YES];
        
        
    } failureBlock:^(NSError *error) {
        [self HideProcessingView];
    }];
}

- (NSMutableArray *)createOffersByDealTypeModalFrom:(GMOffersByDealTypeBaseModal *)baseModal {
    
    NSMutableArray *offersByDealTypeArray = [NSMutableArray array];
    GMOffersByDealTypeModal *allModal = [[GMOffersByDealTypeModal alloc] initWithDealType:@"All" dealId:@"" dealImageUrl:@"" andDealsArray:baseModal.allArray];
    [offersByDealTypeArray addObject:allModal];
    [offersByDealTypeArray addObjectsFromArray:baseModal.deal_categoryArray];
    return offersByDealTypeArray;
}

#pragma nark - Fetching Hot Deals Methods

- (void)fetchDealCategoriesFromServerWithDealTypeId:(NSString *)dealTypeId {
    
    [self ShowProcessingView];
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:dealTypeId forKey:kEY_deal_type_id];
    [localDic setObject:kEY_iOS forKey:kEY_device];
    
    if(NSSTRING_HAS_DATA(self.pushModal.notificationId)) {
        [localDic setObject:self.pushModal.notificationId forKey:KEY_Notification_Id];
    }
    
    [[GMOperationalHandler handler] dealsByDealType:localDic withSuccessBlock:^(id dealCategoryBaseModal) {
        
        [self HideProcessingView];
//        NSMutableArray *dealCategoryArray = [self createCategoryDealsArrayWith:dealCategoryBaseModal];
//
//        if (dealCategoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
//            return ;
//        }
        [self.tabBarVC  setSelectedIndex:0];
        
        
        
        
        
        GMProductListingBaseModal *productListingBaseMdl = dealCategoryBaseModal;
        
        // All Cat list side by ALL Tab
        NSMutableArray *categoryArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.hotProductListArray) {
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // All products, for ALL Tab category
        NSMutableArray *allCatProductListArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.productsListArray) {
            [allCatProductListArray addObjectsFromArray:catMdl.productListArray];
            
            if (catMdl.productListArray.count >= 1) {
                
                //                if(!NSSTRING_HAS_DATA(catMdl.categoryId)) {
                //                    catMdl.categoryId = @"0";
                //                }
                [categoryArray addObject:catMdl];
            }
        }
        
        // set all product list in ALL tab category mdl
        GMCategoryModal *categoryModal = [[GMCategoryModal alloc]init];
        categoryModal.categoryId = @"-1";
        categoryModal.productListArray = allCatProductListArray;
        
        // set this cat modal as ALL tab
        [categoryArray insertObject:categoryModal atIndex:0];
        
        if (categoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
            [[GMSharedClass sharedClass] showErrorMessage:@"Sorry, No products listed in this category"];
            return ;
        }
        
//        GMHotDealModal *hotDealModal =  [self.hotDealsArray objectAtIndex:0];
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlisting;
        rootVC.navigationTitleString = @"Deals";
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeDealGA;
//        [self.navController pushViewController:rootVC animated:YES];
        
        [self.tabBarVC  setSelectedIndex:0];
        GMHomeVC *homeVC  = [self rootHomeVCFromFourthTab];
        [homeVC.navigationController pushViewController:rootVC animated:YES];
        
//        [APP_DELEGATE setTopVCOnHotDealsController:rootVC];
//        [self.navigationController pushViewController:rootVC animated:YES];
        
//        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
//        rootVC.pageData = dealCategoryArray;
//        rootVC.navigationTitleString = [dealCategoryBaseModal.dealNameArray firstObject];
//        rootVC.rootControllerType = GMRootPageViewControllerTypeDealCategoryTypeListing;
//        [APP_DELEGATE setTopVCOnHotDealsController:rootVC];
        
    } failureBlock:^(NSError *error) {
        
        [self HideProcessingView];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

- (NSMutableArray *)createCategoryDealsArrayWith:(GMDealCategoryBaseModal *)dealCategoryBaseModal {
    
    NSMutableArray *dealCategoryArray = [NSMutableArray arrayWithArray:dealCategoryBaseModal.dealCategories];
    GMDealCategoryModal *allModal = [[GMDealCategoryModal alloc] initWithCategoryId:@"" images:@"" categoryName:@"All" isActive:@"1" andDeals:dealCategoryBaseModal.allDealCategory];
    [dealCategoryArray insertObject:allModal atIndex:0];
    return dealCategoryArray;
}

#pragma mark - fetchProductListingDataForCategory

- (void)fetchProductListingDataForCategory:(GMCategoryModal*)categoryModal {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:categoryModal.categoryId forKey:kEY_cat_id];
    if(NSSTRING_HAS_DATA(self.pushModal.notificationId)) {
        [localDic setObject:self.pushModal.notificationId forKey:KEY_Notification_Id];
    }
    
    [self ShowProcessingView];
    [[GMOperationalHandler handler] productListAll:localDic withSuccessBlock:^(id productListingBaseModal) {
        [self HideProcessingView];
        
        GMProductListingBaseModal *productListingBaseMdl = productListingBaseModal;
        
        // All Cat list side by ALL Tab
        NSMutableArray *categoryArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.hotProductListArray) {
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // All products, for ALL Tab category
        NSMutableArray *allCatProductListArray = [NSMutableArray new];
        
        for (GMCategoryModal *catMdl in productListingBaseMdl.productsListArray) {
            [allCatProductListArray addObjectsFromArray:catMdl.productListArray];
            
            if (catMdl.productListArray.count >= 1) {
                [categoryArray addObject:catMdl];
            }
        }
        
        // set all product list in ALL tab category mdl
        categoryModal.productListArray = allCatProductListArray;
        
        // set this cat modal as ALL tab
        [categoryArray insertObject:categoryModal atIndex:0];
        
        if (categoryArray.count < 2) {// GMRootPageViewController, must require at least 2 object, because one object is removing from index 0, in view did load to remove "ALL" tab 28/10/2015
            return ;
        }
        
        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData = categoryArray;
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlistingCategory;
        rootVC.navigationTitleString = categoryModal.categoryName;
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeCategoryGA;
        [self.tabBarVC  setSelectedIndex:0];
        GMHomeVC *homeVC  = [self rootHomeVCFromFourthTab];
        [homeVC.navigationController pushViewController:rootVC animated:YES];
        
    } failureBlock:^(NSError *error) {
        [self HideProcessingView];
    }];
}
#pragma mark - Drawer Handling Methods

- (void)setTopVCOnCenterOfDrawerController:(UIViewController*)topVC {
    
    GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
    UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
    for (UIViewController *vc in [centerNavVC viewControllers]) {// pop to dashboard
        
        if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMHomeVC class])]) {
            [centerNavVC popToViewController:vc animated:NO];
            break;
        }
    }
    if ([NSStringFromClass([topVC class]) isEqualToString:NSStringFromClass([GMHomeVC class])]) {
        // for dashboard
        
    }
    else {
        //other
        [centerNavVC pushViewController:topVC animated:NO];
    }
    [self.drawerController closeDrawerAnimated:YES completion:nil];
}

- (UIViewController *)getTopControler {
    
    GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
    UIViewController *centerVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
    return centerVC;
}
- (void)popToCenterViewController {
    
    UINavigationController *centerNavVC = (UINavigationController*)(self.drawerController.centerViewController);
    for (UIViewController *vc in [centerNavVC viewControllers]) {// pop to dashboard
        
        if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMHomeVC class])]) {
            [centerNavVC popToViewController:vc animated:NO];
            break;
        }
    }
}

- (void)setTopVCOnHotDealsController:(UIViewController*)topVC {
    
    GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
    [tabBarVC setSelectedIndex:2];
    UINavigationController *centerNavVC = [tabBarVC.viewControllers objectAtIndex:tabBarVC.selectedIndex];
    for (UIViewController *vc in [centerNavVC viewControllers]) {// pop to dashboard
        
        if ( [NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([GMHotDealVC class])]) {
            [centerNavVC popToViewController:vc animated:NO];
            break;
        }
    }
    if ([NSStringFromClass([topVC class]) isEqualToString:NSStringFromClass([GMHotDealVC class])]) {
        // for dashboard
        
    }
    else {
        //other
        [centerNavVC pushViewController:topVC animated:NO];
    }
    [self.drawerController closeDrawerAnimated:YES completion:nil];
}

-(GMSearchVC*) rootSearchVCFromFourthTab {
    
    @try {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        GMNavigationController *searchNavVC = [tabBarVC.viewControllers objectAtIndex:3];
        
        GMSearchVC *searchVC = [searchNavVC viewControllers][0];
        return searchVC;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return nil;
}

-(GMHotDealVC*) rootHotDealVCFromThirdTab {
    
    @try {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        GMNavigationController *hotdealNavVC = [tabBarVC.viewControllers objectAtIndex:2];
        
        GMHotDealVC *hotDealVC = [hotdealNavVC viewControllers][0];
        return hotDealVC;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return nil;
}

-(GMCartVC*) rootCartVCFromFiftTab {
    
    @try {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        GMNavigationController *hotdealNavVC = [tabBarVC.viewControllers objectAtIndex:4];
        
        GMCartVC *cartVC = [hotdealNavVC viewControllers][0];
        return cartVC;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return nil;
}

- (void)goToHomeWithAnimation:(BOOL)animation {
    
    [self.window.layer removeAllAnimations];
    UINavigationController *navController = [self.tabBarVC.viewControllers firstObject];
    [self.tabBarVC setSelectedIndex:0];
    [navController popToRootViewControllerAnimated:animation];
}

- (void) initializeGoogleAnalytics {
    
    
    [[GAI sharedInstance] setDispatchInterval:kGaDispatchPeriod];
    [[GAI sharedInstance] setDryRun:kGaDryRun];
    [[GAI sharedInstance] trackerWithTrackingId:kGaPropertyId];
    
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
//    gai.logger.logLevel = kGAILogLevelVerbose;//Remove in release
    
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Splash_Screen];
}

-(GMProfileVC*) rootProfileVCFromSecondTab {
    
    @try {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        GMNavigationController *profileNavVC = [tabBarVC.viewControllers objectAtIndex:1];
        
        UIViewController *viewController = [profileNavVC viewControllers][0];
        GMProfileVC *profileVC;
        if([viewController isKindOfClass:[GMProfileVC class]]) {
            profileVC = (GMProfileVC *)viewController;
        } else if([profileNavVC viewControllers].count>1){
            profileVC = [profileNavVC viewControllers][1];
        }
//        profileVC = [profileNavVC viewControllers][0];
        return profileVC;
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
    
    return nil;
}

-(GMHomeVC*) rootHomeVCFromFourthTab {
    [self.drawerController closeDrawerAnimated:YES completion:nil];

    @try {
        
        GMTabBarVC *tabBarVC = (GMTabBarVC *)(self.drawerController.centerViewController);
        GMNavigationController *homeNavVC = [tabBarVC.viewControllers objectAtIndex:0];
        
        GMHomeVC *homeVC = [homeNavVC viewControllers][0];
        return homeVC;
    }
    @catch (NSException *exception) {
    }
    @finally {
        
    }
    
    return nil;
}

#pragma mark activity indicator
-(void)ShowProcessingView
{
    if([self.window viewWithTag:TAG_PROCESSING_INDECATOR])
        [[self.window viewWithTag:TAG_PROCESSING_INDECATOR] removeFromSuperview];
    
    UIView *processingAlertView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    [processingAlertView setTag:TAG_PROCESSING_INDECATOR];
    [processingAlertView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    self.indefiniteAnimatedView.center = processingAlertView.center;
    [processingAlertView addSubview:self.indefiniteAnimatedView];
    [self.window addSubview:processingAlertView];
    
    // NSLog(@"Show------>");
    
}

-(void)HideProcessingView
{
    UIView *processsingView = [self.window viewWithTag:TAG_PROCESSING_INDECATOR];
    [processsingView removeFromSuperview];
    
    // NSLog(@"Hide------>");
    
}

- (SVIndefiniteAnimatedView *)indefiniteAnimatedView {
    if (_indefiniteAnimatedView == nil) {
        _indefiniteAnimatedView = [[SVIndefiniteAnimatedView alloc] initWithFrame:CGRectZero];
        _indefiniteAnimatedView.strokeThickness = 2.0;
        _indefiniteAnimatedView.strokeColor = [UIColor gmOrangeColor];
        _indefiniteAnimatedView.radius = 24;
        [_indefiniteAnimatedView sizeToFit];
    }
    return _indefiniteAnimatedView;
}

#pragma AppsFlyerTrackerDelegate methods
- (void) onConversionDataReceived:(NSDictionary*) installData{
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        NSLog(@"This is a none organic install.");
        NSLog(@"Media source: %@",sourceID);
        NSLog(@"Campaign: %@",campaign);
    } else if([status isEqualToString:@"Organic"]) {
//        NSLog(@"This is an organic install.");
    }
}

- (void) onConversionDataRequestFailure:(NSError *)error{
//    NSLog(@"Failed to get data from AppsFlyer's server: %@",[error localizedDescription]);
}

#pragma mark - LeftMenuDelegate Method

-(void)goToWallet {
    [self.tabBarVC setSelectedIndex:1];
    
    if([[GMSharedClass sharedClass] getUserLoggedStatus] == YES) {
        
       GMProfileVC *profileVc = [self rootProfileVCFromSecondTab];
//        [self.tabBarVC.selectedViewController  popToRootViewControllerAnimated:YES];
        [self.tabBarVC.selectedViewController popToViewController:profileVc animated:NO];
        profileVc.isMenuWallet = YES;
    }
}

-(void)goToMaxCoins {
    [self.tabBarVC setSelectedIndex:1];
    
    if([[GMSharedClass sharedClass] getUserLoggedStatus] == YES) {
        
        GMProfileVC *profileVc = [self rootProfileVCFromSecondTab];
        [self.tabBarVC.selectedViewController popToViewController:profileVc animated:NO];
        
        [profileVc goToMaxCoins];
//        goToMaxCoins
    }
}

-(void)goContactUs {
//    if([[GMSharedClass sharedClass] isInternetAvailable]) {
        [self.tabBarVC setSelectedIndex:0];
        GMWebViewVC *webViewVC = [[GMWebViewVC alloc] initWithNibName:@"GMWebViewVC" bundle:nil];
        webViewVC.isTermsAndCondition = NO;
        [self.tabBarVC.selectedViewController pushViewController:webViewVC animated:YES];
//    } else {
//        [[GMSharedClass sharedClass] showErrorMessage:@"Please check internet connection."];
//    }
    
}
@end
