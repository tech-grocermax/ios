//
//  GMSharedClass.m
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSharedClass.h"
#import "GMUserModal.h"
#import "GMStateBaseModal.h"
#import "Reachability.h"

#import <Google/SignIn.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <GoogleAnalytics/GAITracker.h>
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GoogleAnalytics/GAIFields.h>
#import "GMCartModal.h"
#import "NSDateFormatter+Extend.h"
#import "GMSearchKeyWordSavedModal.h"

#define kAlertTitle @"GrocerMax"
#import "GMTrendingBaseModal.h"
#import "MGInternalNotificationAlert.h"

@interface GMSharedClass ()

@property (nonatomic) Reachability* reachability;
@property (nonatomic) GMTrendingBaseModal* trendingBaseModal;


@end

@implementation GMSharedClass

static GMSharedClass *sharedHandler;

static NSString *const categoryImageUrlKey = @"com.GrocerMax.categoryImageUrlKey";
static NSString *const loggedInUserKey = @"com.GrocerMax.loggedInUserKey";
static NSString *const signedInUserKey = @"com.GroxcerMax.signedInUserKey";
static NSString *const userSelectedUserLocationKey = @"com.GroxcerMax.selectedUserLocation";

CGFloat const kMATabBarHeight = 49.0f;

#pragma mark - SharedInstance Method

+ (instancetype)sharedClass {
    
    if(!sharedHandler) {
        sharedHandler  = [[[self class] alloc] init];
        [sharedHandler setupReachability];
    }
    return sharedHandler;
}

#pragma mark - Error And Alert Messages

- (void) showErrorMessage:(NSString*)message{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:key_TitleMessage message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;
    
//    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
//    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelError animated:YES];
}

- (void) showSuccessMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelPositive animated:YES];
}

- (void) showWarningMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelWarning animated:YES];
}

- (void) showInfoMessage:(NSString*)message{
    
    NSError *strongError = [RZErrorMessenger errorWithDisplayTitle:kAlertTitle detail:message error:nil];
    [RZErrorMessenger displayError:strongError withStrength:kRZMessageStrengthStrongAutoDismiss level:kRZErrorMessengerLevelInfo animated:YES];
}

#pragma mark -

+ (BOOL)validateEmail:(NSString*)emailString {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:emailString];
    return isValid;
}

+ (BOOL)validateMobileNumberWithString:(NSString*)mobile {
    
    if (!NSSTRING_HAS_DATA(mobile))
        return NO;
    
    NSString *phoneRegex = @"^[789]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [phoneTest evaluateWithObject:mobile];
    return isValid;
}

#pragma mark -

- (BOOL)getUserLoggedStatus {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:loggedInUserKey] boolValue];
}

- (void)setUserLoggedStatus:(BOOL)status {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(status) forKey:loggedInUserKey];
    [defaults synchronize];
}

#pragma mark- UITabBar Animation

- (BOOL)tabBarIsVisible:(UIViewController*)controller {
    
    return controller.tabBarController.tabBar.frame.origin.y < SCREEN_SIZE.height;
}

- (void)setTabBarVisible:(BOOL)visible ForController:(UIViewController *)controller animated:(BOOL)animated {
    
    if(visible)
        controller.tabBarController.tabBar.translucent = NO;
    else
        controller.tabBarController.tabBar.translucent = YES;
    
    if ([self tabBarIsVisible:controller] == visible) return;
    
    CGRect frame = controller.tabBarController.tabBar.frame;
    CGFloat offsetY = (visible)? -kMATabBarHeight : kMATabBarHeight;
    
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        controller.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)saveLoggedInUserWithData:(NSData *)userData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userData forKey:signedInUserKey];
    [defaults synchronize];
}

- (GMUserModal *)getLoggedInUser {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:signedInUserKey];
    GMUserModal *archivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return archivedUser;
}

- (GMCityModal *)getSavedLocation {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:userSelectedUserLocationKey];
    GMCityModal *archivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return archivedUser;
}

- (void)saveSelectedLocationData:(NSData *)userData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userData forKey:userSelectedUserLocationKey];
    [defaults synchronize];
}

- (void)logout {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:signedInUserKey];
    GMUserModal *archivedUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    archivedUser = nil;
    [GMUserModal clearUserModal];
    [defaults removeObjectForKey:signedInUserKey];
    [defaults setObject:@(NO) forKey:loggedInUserKey];
    [defaults synchronize];
    
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logOut];
    [[GIDSignIn sharedInstance] signOut];
}

#pragma mark - Network Reachbility Test

-(void)setupReachability
{
    // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(reachabilityChanged:)
    //                                                 name:kReachabilityChangedNotification
    //                                               object:nil];
    
    
    // Allocate a reachability object
    self.reachability = [Reachability reachabilityForInternetConnection];
    
    
    //    [self reachabilityChanged:nil];// force full call
    //    [self.internetReachable startNotifier];
}

//-(void) reachabilityChanged:(NSNotification *)notice
//{
//    // !!!!! Important!!! called after network status changes
//    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
//    switch (internetStatus)
//    {
//        case NotReachable:
//        {
//            NSLog(@"The internet is down.");
//            self.internetActive = NO;
//
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            NSLog(@"The internet is working via WIFI.");
//            self.internetActive = YES;
//
//            break;
//        }
//        case ReachableViaWWAN:
//        {
//            NSLog(@"The internet is working via WWAN.");
//            self.internetActive = YES;
//
//            break;
//        }
//    }
//}

- (BOOL)isInternetAvailable {
    
    return [self.reachability isReachable];
}

- (void)trakScreenWithScreenName:(NSString *)scrrenName {
    
    [rocqAnalytics trackScreen:scrrenName];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:scrrenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [[AppsFlyerTracker sharedTracker] trackEvent:scrrenName withValue:nil];
}

- (void)trakeEventWithName:(NSString *)eventName withCategory:(NSString *)category label:(NSString *)label value:(NSNumber *)value{
    
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    if(!NSSTRING_HAS_DATA(category)) {
//        category = @"Action";
//    }
//    NSMutableDictionary *event =
//    [[GAIDictionaryBuilder createEventWithCategory:category
//                                            action:eventName
//                                             label:label
//                                             value:value] build];
//    [tracker send:event];
    
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValue:label];
//    [rocqAnalytics trackEvent:eventName properties:@{} position: CENTRE];
    if(NSSTRING_HAS_DATA(eventName) && NSSTRING_HAS_DATA(label) && NSSTRING_HAS_DATA(category))
    [rocqAnalytics trackEvent:eventName properties:@{eventName:label,@"category":category} position: CENTRE];
    
}

//new Event track
- (void)trakeEventWithName:(NSString *)eventName withCategory:(NSString *)category label:(NSString *)label{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    if(!NSSTRING_HAS_DATA(eventName)) {
        eventName = @"";
    }
    if(NSSTRING_HAS_DATA(eventName) && NSSTRING_HAS_DATA(label) && NSSTRING_HAS_DATA(category)) {
            [rocqAnalytics trackEvent:eventName properties:@{eventName:label,@"category":category} position: CENTRE];
    }
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:category
                                            action:eventName
                                             label:label
                                             value:0] build];
    [tracker send:event];
    
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValue:label];
    
//    [[QGSdk getSharedInstance] logEvent:eventName withParameters:event];
}

//new Event track//19_June_2016
- (void)trakeEventWithNameNew:(NSString *)eventName withCategory:(NSString *)category label:(NSString *)label{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    if(!NSSTRING_HAS_DATA(eventName)) {
        eventName = @"";
    }
    NSString *category_City= @"";
    GMCityModal * cityModal = [GMCityModal selectedLocation];
    if(cityModal != nil && NSSTRING_HAS_DATA(cityModal.cityName)) {
        category_City = [NSString stringWithFormat:@"%@ - %@",category,cityModal.cityName];
    }else {
        category_City = category;
    }
    
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:category_City
                                            action:eventName
                                             label:label
                                             value:0] build];
    [tracker send:event];
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValue:label];
    
    //Rahul 7/7/2016 QGSDK
//    [[QGSdk getSharedInstance] logEvent:category_City withParameters:event];

}

- (void)trakeForQAWithEventame:(NSString *)eventName withExtraParameter:(NSMutableDictionary *)extraParameter{
    
//    NSLog(@"%@",extraParameter);
    
    if([self getUserLoggedStatus]){
       GMUserModal *userModal = [self getLoggedInUser];
        if(NSSTRING_HAS_DATA(userModal.mobile)){
            [extraParameter setObject:userModal.mobile forKey:kEY_QA_EventParmeter_PhoneNumber];
        }
        if(NSSTRING_HAS_DATA(userModal.email)){
            [extraParameter setObject:userModal.email forKey:kEY_QA_EventParmeter_EmailId];
        }
//        if(NSSTRING_HAS_DATA(userModal.userId)){
//            [extraParameter setObject:userModal.userId forKey:@"user_id"];
//        }
    }
    [[QGSdk getSharedInstance] logEvent:eventName withParameters:extraParameter];
    
}



- (void)clearCart {
    
    GMCartModal *cartModal = [GMCartModal loadCart];
    [cartModal.cartItems removeAllObjects];
    [cartModal.deletedProductItems removeAllObjects];
    [cartModal archiveCart];
    GMUserModal *userModal = [self getLoggedInUser];
    userModal.quoteId = @"";
    [userModal persistUser];
}

-(NSMutableURLRequest *)requestHeader:(NSMutableURLRequest *)webRequest
{
    [webRequest setValue:kAppVersion forHTTPHeaderField:keyAppVersion];
    [webRequest setValue:kEY_iOS forHTTPHeaderField:kEY_device];
    return webRequest;

}

- (NSString *)getCategoryImageBaseUrl {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:categoryImageUrlKey];
}

- (void)setCategoryImageBaseUrl:(NSString *)baseurl {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:baseurl forKey:categoryImageUrlKey];
    [defaults synchronize];
}
//- (NSMutableURLRequest *)setHeaderRequest:(NSMutableURLRequest *)headerRequest {
//    [headerRequest setValue:kEY_iOS forKey:kEY_device];
//    [headerRequest setValue:kAppVersion forKey:keyAppVersion];
//    return headerRequest;
//}

- (NSString *)getDate:(NSString *)myDateString withFormate:(NSString *)formate {
    
    if(NSSTRING_HAS_DATA(formate)){
        formate =@"dd-MMM-yyyy";
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:myDateString];
    dateFormatter.dateFormat = formate;
    NSString *newDate = [dateFormatter stringFromDate:yourDate];
    return newDate;
}

- (NSString *)getDeliveryDate:(NSString *)deliveryStr {
    
//    NSDate *deliveryDate = [[NSDateFormatter dateFormatter_yyyy_MM_dd] dateFromString:deliveryStr];
//    NSString *timeStr = [[NSDateFormatter dateFormatter_DD_MMM_YYYY] stringFromDate:deliveryDate];
//    return timeStr;
    
    
    NSDate *deliveryDate = [[NSDateFormatter dateFormatter_yyyy_MM_dd] dateFromString:deliveryStr];
    NSString *timeStr = [[NSDateFormatter dateFormatter_MMM_DD__YYYY] stringFromDate:deliveryDate];
    return [NSString stringWithFormat:@"%@, %@",[self daysFromDate:deliveryDate],timeStr] ;
}

-(NSString *)daysFromDate:(NSDate *)deliveryDate {
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:deliveryDate];
    
    NSString *daysString = @"";
    switch ([component weekday]) {
        case 1:
            daysString = @"Sunday";
            break;
        case 2:
            daysString = @"Monday";
            break;
        case 3:
            daysString = @"Tuesday";
            break;
        case 4:
            daysString = @"Wednesday";
            break;
        case 5:
            daysString = @"Thursday";
            break;
        case 6:
            daysString = @"Friday";
            break;
        case 7:
            daysString = @"Saturday";
            break;
            
        default:
            break;
    }
    
    return daysString;
}

-(void)clearLaterUpdate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:APPLICATION_UPDATE_LATER])
    {
        [defaults removeObjectForKey:APPLICATION_UPDATE_LATER];
    }
    if([defaults objectForKey:APPLICATION_UPDATE_IGNORE])
    {
        [defaults removeObjectForKey:APPLICATION_UPDATE_IGNORE];
    }
    if([defaults objectForKey:APPLICATION_UPDATE_LATER_VALUE])
    {
        [defaults removeObjectForKey:APPLICATION_UPDATE_LATER_VALUE];
    }
    [defaults synchronize];
}

-(BOOL)checkConditionShowUpdate
{
    BOOL retValue = FALSE;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:APPLICATION_UPDATE_LATER])
    {
        NSDate* date1 = [defaults objectForKey:APPLICATION_UPDATE_LATER];
        NSDate* date2 = [NSDate date];
        NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
        double secondsInAnHour = 3600;
        double hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
        
        if(hoursBetweenDates>=24)
        {
            retValue = YES;
        }
        
        
    }
    else if([defaults objectForKey:APPLICATION_UPDATE_IGNORE])
    {
        NSDate* date1 = [defaults objectForKey:APPLICATION_UPDATE_IGNORE];
        NSDate* date2 = [NSDate date];
        NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
        double secondsInAnHour = 3600;
        double hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
        
        if(hoursBetweenDates>=24*7)
        {
            retValue = YES;
        }
    }
    else
    {
        retValue = YES;
    }
    return retValue;
}

-(BOOL)checkInternalNotificationWithMessageId:(NSString *)messageId withFrequency:(NSString *)frequency {
    
    BOOL retValue = FALSE;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:messageId]  && [defaults objectForKey:messageId] != nil) {
        
        NSDate* date1 = [defaults objectForKey:messageId];
        NSDate* date2 = [NSDate date];
        NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
        double minutInAnHour = 60;
        double minutBetweenDates = distanceBetweenDates / minutInAnHour;
        
        if(minutBetweenDates>=[frequency doubleValue])
        {
            retValue = YES;
        }
        
    } else {
        retValue = YES;
    }
    return retValue;
    
}

-(GMUserModal *)makeLastNameFromUserModal:(GMUserModal *)userModal {
    
    if(!NSSTRING_HAS_DATA(userModal.lastName)) {
        if(NSSTRING_HAS_DATA(userModal.firstName)){
            NSString *name = userModal.firstName;
            name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSArray *names = [name componentsSeparatedByString:@" "];
            
            if(names.count>0) {
                if(names.count>1) {
                    NSString *lastName = [names lastObject];
                    userModal.lastName = lastName;
                    NSString *firstName = @"";
                    for(int i = 0; i<names.count-1;i++){
                        if(i==0) {
                            firstName= [NSString stringWithFormat:@"%@",names[i]];
                        } else {
                            firstName= [NSString stringWithFormat:@"%@ %@",firstName,names[i]];
                        }
                    }
                    userModal.firstName = name;
                }
            }
            
            
        }
    }
    
    return userModal;
}

- (void)setTrendingBaseMdl:(GMTrendingBaseModal *)trendingModal {
    
//    GMTrendingModal *trendingBaseModal = [[GMTrendingModal alloc]init];
//    trendingBaseModal.trendingName = @"Arvind2";
//    trendingBaseModal.trendingId = @"34335485";
//    [trendingModal.trendingArray addObject:trendingBaseModal];
    
    GMSearchKeyWordSavedModal *searchKeyWordSavedModal = [GMSearchKeyWordSavedModal loadSavedTrendingModal];
    if(!searchKeyWordSavedModal){
        searchKeyWordSavedModal = [[GMSearchKeyWordSavedModal alloc] initWithSavedTrendingModalArray:(NSMutableArray *)trendingModal.trendingArray];
        [searchKeyWordSavedModal archiveavedTrendingModal];
    }else {
        
        for(int i = 0; i<trendingModal.trendingArray.count; i++){
           
            GMTrendingModal *trendingM = [trendingModal.trendingArray objectAtIndex:i];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.trendingId  MATCHES[c] %@",trendingM.trendingId];
            
            NSArray *tempArray = [searchKeyWordSavedModal.savedTrendingModalArray filteredArrayUsingPredicate:predicate];
            
            if(tempArray.count>0){
                
                GMTrendingModal *newTrendingM = [tempArray objectAtIndex:0];
                newTrendingM.trendingName = trendingM.trendingName;
                
                
            }else {
                [searchKeyWordSavedModal.savedTrendingModalArray addObject:trendingM];
            }
        }
        [searchKeyWordSavedModal archiveavedTrendingModal];
        
    }
    
    
    
    self.trendingBaseModal = trendingModal;
}

- (NSArray *)getTrendingBaseModalArray {
    if(self.trendingBaseModal){
    return self.trendingBaseModal.trendingArray;
    }else {
        return nil;
    }
}

-(void)setProductSortIndex:(NSString *)index{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:index forKey:KEY_ProductListSortByIndex];
    [defaults synchronize];
    
}

-(int)getProductSortIndex {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:KEY_ProductListSortByIndex]){
        return [[defaults objectForKey:KEY_ProductListSortByIndex] intValue];
    }else {
        return 0;
    }
    
}

-(void)saveBackGroundInTime:(BOOL)isSaved{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(isSaved){
        
        NSDate* currentTime = [NSDate date];
        [defaults setObject:currentTime forKey:APPLICATION_ENTER_IN_BACKGROUND_TIME];
    }else {
        if([defaults objectForKey:APPLICATION_ENTER_IN_BACKGROUND_TIME]){
            [defaults removeObjectForKey:APPLICATION_ENTER_IN_BACKGROUND_TIME];
        }
    }
    [defaults synchronize];
}
-(BOOL)checkConditionInBackGroundTime{
    
    BOOL retValue = FALSE;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:APPLICATION_ENTER_IN_BACKGROUND_TIME])
    {
        NSDate* date1 = [defaults objectForKey:APPLICATION_ENTER_IN_BACKGROUND_TIME];
        NSDate* date2 = [NSDate date];
        NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
        double minutsInAnHour = 60;
        double minitusBetweenDates = distanceBetweenDates / minutsInAnHour;
        
        if(minitusBetweenDates>=[[self getSavedCartSessionExpireTime] intValue])
        {
            retValue = YES;
        }
        
        
    }
    return retValue;
}

-(void)saveCartSessionExpireTime:(NSString *)timeInMinitus{
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:timeInMinitus forKey:APPLICATION_SESSION_EXPIRE_TIME];
    [defaults synchronize];
}

-(NSString *)getSavedCartSessionExpireTime{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:APPLICATION_SESSION_EXPIRE_TIME])
    {
        return [defaults objectForKey:APPLICATION_SESSION_EXPIRE_TIME];
    }else{
        return @"30";
    }
}

-(NSString *)getUDID
{
    UIDevice *device = [UIDevice currentDevice];
    NSUUID *UDID = [device identifierForVendor];
    NSString *hash_UDID = [UDID UUIDString];
    return hash_UDID;
}
-(void)showSubscribePopUp
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL subscribeStatus =  [[defaults objectForKey:key_IsSubscriptionPopUpShow] boolValue];
    if(subscribeStatus == FALSE){
        
        if([self checkConditionInSubscribeTime]) {
            if(![self getUserLoggedStatus]){
                MGInternalNotificationAlert *internalNotificationAlert = [[MGInternalNotificationAlert alloc]init];
                [internalNotificationAlert showTextFieldAlert];
            }
        }
    }
}


-(BOOL)checkConditionInSubscribeTime{
    
    BOOL retValue = FALSE;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:key_SubscriptionPopUp_ExpTime])
    {
        if([defaults objectForKey:key_SubscriptionPopUp_ShowTime]){
            NSDate* date1 = [defaults objectForKey:key_SubscriptionPopUp_ShowTime];
            NSDate* date2 = [NSDate date];
            NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
            double minutsInAnHour = 60;
            double minitusBetweenDates = distanceBetweenDates / minutsInAnHour;
            
            if(minitusBetweenDates>=[[self getSavedSubscribeExpireTime] doubleValue])
            {
                retValue = YES;
            }
        }else {
            return YES;
        }
        
        
    }
    return retValue;
}

-(NSString *)getSavedSubscribeExpireTime{//mintunt
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:key_SubscriptionPopUp_ExpTime])
    {
        return [defaults objectForKey:key_SubscriptionPopUp_ExpTime];
    }else{
        return @"1440";
    }
}

@end
