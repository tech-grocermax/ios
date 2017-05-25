//
//  MGAppliactionUpdate.h
//  FINDIT333
//
//  Created by arvind gupta on 24/02/15.
//  Copyright (c) 2015 Arvind Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMInternalNotificationModal.h"

#define APPIRATER_SIG_EVENTS_UNTIL_PROMPT	-1	// integer
#define APPIRATER_TIME_BEFORE_REMINDING		1	// double
#define APPIRATER_DEBUG				YES

@interface MGInternalNotificationAlert : NSObject {
    
    UIAlertController		*notificationAlert;
}
//@property(nonatomic, strong) UIAlertController *notificationAlert;
@property(nonatomic, strong) GMInternalNotificationModal *notificationModal;

+ (void)showNotificationAlert:(GMInternalNotificationModal *)notiModal;

-(void)showTextFieldAlert;
@end
