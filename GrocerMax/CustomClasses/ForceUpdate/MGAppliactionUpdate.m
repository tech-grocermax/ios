//
//  MGAppliactionUpdate.m
//  FINDIT333
//
//  Created by arvind gupta on 24/02/15.
//  Copyright (c) 2015 Arvind Gupta. All rights reserved.
//

#import "MGAppliactionUpdate.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

//NSString *const kAppiraterFirstUseDate				= @"kAppiraterFirstUseDate";
//NSString *const kAppiraterUseCount					= @"kAppiraterUseCount";
//NSString *const kAppiraterSignificantEventCount		= @"kAppiraterSignificantEventCount";
//NSString *const kAppiraterCurrentVersion			= @"kAppiraterCurrentVersion";
//NSString *const kAppiraterRatedCurrentVersion		= @"kAppiraterRatedCurrentVersion";
//NSString *const kAppiraterDeclinedToRate			= @"kAppiraterDeclinedToRate";
//NSString *const kAppiraterReminderRequestDate		= @"kAppiraterReminderRequestDate";

#define FORCEUPDATE_APP_ALERT_TAG 9876
#define LATERUPDATE_APP_ALERT_TAG 8765



@interface MGAppliactionUpdate ()
+ (MGAppliactionUpdate*)sharedInstance;
- (void)showUpdateLaterAlert;
- (void)showForceUpdateAlert;
- (void)hideRatingAlert;
@end

@implementation MGAppliactionUpdate
@synthesize updateAlert,alertMessage,isForceUpdate;

+ (MGAppliactionUpdate*)sharedInstance {
    static MGAppliactionUpdate *appUpadate = nil;
    if (appUpadate == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            appUpadate = [[MGAppliactionUpdate alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:
             UIApplicationWillResignActiveNotification object:nil];
        });
    }
    
    return appUpadate;
}

- (void)showForceUpdateAlert {

        UIViewController *topControler = [APP_DELEGATE getTopControler];
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    
            UIAlertAction *alertActionUpdate = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [topControler dismissViewControllerAnimated:YES completion:nil];
                [MGAppliactionUpdate appUpdate];
            }];
            [alertController addAction:alertActionUpdate];
    
    
            UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [topControler dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:alertActionCancel];
        
        
        [topControler presentViewController:alertController animated:YES completion:nil];
        
    
    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:key_TitleMessage
//                                                        message:alertMessage
//                                                       delegate:self
//                                              cancelButtonTitle:@"Cancel"
//                                              otherButtonTitles:@"Update", nil] ;
//    self.updateAlert = alertView;
//    self.updateAlert.tag = FORCEUPDATE_APP_ALERT_TAG;
//    [alertView show];
}

- (void)showUpdateLaterAlert{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:key_TitleMessage
                                                        message:alertMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Ignore"
                                              otherButtonTitles:@"Update",@"Later", nil] ;
    
    self.updateAlert = alertView;
    self.updateAlert.tag = LATERUPDATE_APP_ALERT_TAG;
    [alertView show];
}


+ (void)showUpdate:(BOOL)isForceUpdate message:(NSString *)message {
    [MGAppliactionUpdate sharedInstance].isForceUpdate = isForceUpdate;
    if(NSSTRING_HAS_DATA(message))
    {
        [MGAppliactionUpdate sharedInstance].alertMessage = message;
    }
    else
    {
         [MGAppliactionUpdate sharedInstance].alertMessage = APPLICATION_UPDATE_HARDCOADED_NOTE;
    }
    [MGAppliactionUpdate appLaunched:YES];
}


+ (void)appLaunched:(BOOL)canPromptForRating {
    
    if(![[MGAppliactionUpdate sharedInstance] isAlert])
    {
       if([MGAppliactionUpdate sharedInstance].isForceUpdate)
       {
           [[MGAppliactionUpdate sharedInstance] showForceUpdateAlert];
       }
       else
       {
           [[MGAppliactionUpdate sharedInstance] showUpdateLaterAlert];
       }
    }
}

- (BOOL)isAlert {
    if (self.updateAlert.visible) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)hideRatingAlert {
    if (self.updateAlert.visible) {
        if (APPIRATER_DEBUG)
        {
            //NSLog(@"APPIRATER Hiding Alert");
        }
        [self.updateAlert dismissWithClickedButtonIndex:-1 animated:NO];
    }
}

+ (void)appWillResignActive {
    if (APPIRATER_DEBUG)
    {
        //NSLog(@"APPIRATER appWillResignActive");
    }
    [[MGAppliactionUpdate sharedInstance] hideRatingAlert];
}

+ (void)appUpdate {
    
    //Use the in-app StoreKit view if available (iOS 6) and imported. This works in the simulator.
    
    
#if TARGET_IPHONE_SIMULATOR
    //NSLog(@"APPIRATER NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.");
#else
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/grocermax.com-online-grocery/id1049822835?ls=1&mt=8"]];
    
#endif
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(alertView.tag == FORCEUPDATE_APP_ALERT_TAG)
    {
        [[GMSharedClass sharedClass] clearLaterUpdate];
        switch (buttonIndex) {
            case 0:
            {
                break;
            }
            case 1:
            {
                [MGAppliactionUpdate appUpdate];
                break;
            }
            default:
                break;
        }
    }
    else if(alertView.tag == LATERUPDATE_APP_ALERT_TAG)
    {
        switch (buttonIndex) {
            case 0://Ignore
            {
                NSDate* currentDate = [NSDate date];
               //NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceNow];
                
                [defaults setObject:currentDate forKey:APPLICATION_UPDATE_IGNORE];
                if([defaults objectForKey:APPLICATION_UPDATE_LATER])
                {
                    [defaults removeObjectForKey:APPLICATION_UPDATE_LATER];
                }
                [defaults synchronize];
                break;
            }
            case 1://download
            {
                NSDate* currentDate = [NSDate date];
                [defaults setObject:currentDate forKey:APPLICATION_UPDATE_LATER];
                if([defaults objectForKey:APPLICATION_UPDATE_IGNORE])
                {
                    [defaults removeObjectForKey:APPLICATION_UPDATE_IGNORE];
                }
                [defaults synchronize];
                [MGAppliactionUpdate appUpdate];
            }
                break;
            case 2://later
            {
                NSDate* currentDate = [NSDate date];
                [defaults setObject:currentDate forKey:APPLICATION_UPDATE_LATER];
                if([defaults objectForKey:APPLICATION_UPDATE_IGNORE])
                {
                    [defaults removeObjectForKey:APPLICATION_UPDATE_IGNORE];
                }
                [defaults synchronize];
                break;
            }
            
            default:
                break;
        }
    }
}


@end
