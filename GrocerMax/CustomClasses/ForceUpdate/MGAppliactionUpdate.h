//
//  MGAppliactionUpdate.h
//  FINDIT333
//
//  Created by arvind gupta on 24/02/15.
//  Copyright (c) 2015 Arvind Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kAppiraterFirstUseDate;
extern NSString *const kAppiraterUseCount;
extern NSString *const kAppiraterSignificantEventCount;
extern NSString *const kAppiraterCurrentVersion;
extern NSString *const kAppiraterRatedCurrentVersion;
extern NSString *const kAppiraterDeclinedToRate;
extern NSString *const kAppiraterReminderRequestDate;
#define APPIRATER_APP_ID				@"1049822835"
#define APPIRATER_LOCALIZED_APP_NAME    [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:(NSString *)kCFBundleNameKey]
#define APPIRATER_APP_NAME				APPIRATER_LOCALIZED_APP_NAME ? APPIRATER_LOCALIZED_APP_NAME : [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]

#define APPIRATER_MESSAGE				[NSString stringWithFormat:APPIRATER_LOCALIZED_MESSAGE, APPIRATER_APP_NAME]
#define APPIRATER_MESSAGE_TITLE             [NSString stringWithFormat:APPIRATER_LOCALIZED_MESSAGE_TITLE, APPIRATER_APP_NAME]


#define APPIRATER_DAYS_UNTIL_PROMPT		30
#define APPIRATER_USES_UNTIL_PROMPT		20
#define APPIRATER_SIG_EVENTS_UNTIL_PROMPT	-1	// integer
#define APPIRATER_TIME_BEFORE_REMINDING		1	// double
#define APPIRATER_DEBUG				YES

@interface MGAppliactionUpdate : NSObject<UIAlertViewDelegate> {
    
    UIAlertView		*updateAlert;
}
@property(nonatomic, strong) NSString *alertMessage;
@property(nonatomic, strong) UIAlertView *updateAlert;
@property(assign, nonatomic) BOOL isForceUpdate;
+ (void)showUpdate:(BOOL)isForceUpdate message:(NSString *)message;

@end
