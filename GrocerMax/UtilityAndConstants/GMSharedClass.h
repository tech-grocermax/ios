//
//  GMSharedClass.h
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMUserModal;
@class GMCityModal;
@class UIViewController;
@class GMTrendingBaseModal;

@interface GMSharedClass : NSObject


+ (instancetype)sharedClass;

- (void)showErrorMessage:(NSString*)message;

- (void)showWarningMessage:(NSString*)message;

- (void)showSuccessMessage:(NSString*)message;

- (void)showInfoMessage:(NSString*)message;

+ (BOOL)validateEmail:(NSString*)emailString;

+ (BOOL)validateMobileNumberWithString:(NSString*)mobile;

- (BOOL)getUserLoggedStatus;

- (void)setUserLoggedStatus:(BOOL)status;

- (void)setTabBarVisible:(BOOL)visible ForController:(UIViewController *)controller animated:(BOOL)animated;

- (void)saveLoggedInUserWithData:(NSData *)userData;

- (GMUserModal *)getLoggedInUser;

- (GMCityModal *)getSavedLocation;

- (void) logout;

- (void)saveSelectedLocationData:(NSData *)userData;

- (BOOL)isInternetAvailable;

-(NSMutableURLRequest *)requestHeader:(NSMutableURLRequest *)webRequest;

- (void)trakScreenWithScreenName:(NSString *)scrrenName ;

- (void)trakeEventWithName:(NSString *)eventName withCategory:(NSString *)category label:(NSString *)label value:(NSNumber *)value;

- (void)trakeEventWithName:(NSString *)eventName withCategory:(NSString *)category label:(NSString *)label;

- (void)trakeEventWithNameNew:(NSString *)eventName withCategory:(NSString *)category label:(NSString *)label;

- (void)trakeForQAWithEventame:(NSString *)eventName withExtraParameter:(NSMutableDictionary *)extraParameter;

- (void) clearCart;

- (NSString *)getCategoryImageBaseUrl;

- (void)setCategoryImageBaseUrl:(NSString *)baseurl;


- (NSMutableURLRequest *)setHeaderRequest:(NSMutableURLRequest *)headerRequest;

- (NSString *)getDeliveryDate:(NSString *)deliveryStr;

-(void)clearLaterUpdate;

-(BOOL)checkConditionShowUpdate;

-(BOOL)checkInternalNotificationWithMessageId:(NSString *)messageId_frequency withFrequency:(NSString *)frequency;

-(GMUserModal *)makeLastNameFromUserModal:(GMUserModal *)userModal;



- (void)setTrendingBaseMdl:(GMTrendingBaseModal *)trendingModal ;
- (NSArray *)getTrendingBaseModalArray;


-(void)setProductSortIndex:(NSString *)index;

-(int)getProductSortIndex;


-(void)saveBackGroundInTime:(BOOL)isSaved;

-(BOOL)checkConditionInBackGroundTime;

-(void)saveCartSessionExpireTime:(NSString *)timeInMinitus;

-(NSString *)getSavedCartSessionExpireTime;

-(NSString *)getUDID;

-(void)showSubscribePopUp;

@end