//
//  MGAppliactionUpdate.m
//  FINDIT333
//
//  Created by arvind gupta on 24/02/15.
//  Copyright (c) 2015 Arvind Gupta. All rights reserved.
//

#import "MGInternalNotificationAlert.h"
#import "GMOperationalHandler.h"




@interface MGInternalNotificationAlert ()<UITextFieldDelegate>
+ (MGInternalNotificationAlert*)sharedInstance;
- (void)shownotificationAlert;
@end

@implementation MGInternalNotificationAlert
//@synthesize notificationAlert;

+ (MGInternalNotificationAlert*)sharedInstance {
    static MGInternalNotificationAlert *notificationAlert = nil;
    if (notificationAlert == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            notificationAlert = [[MGInternalNotificationAlert alloc] init];
          
        });
    }
    
    return notificationAlert;
}

- (void)shownotificationAlert {
    if([self.notificationModal.type isEqualToString:KEY_APPLICATION_INTERNAL_NOTIFICATION_POPUP]) {
        
        if(self.notificationModal.actions.count>0) {
        NSString *msg = @"";
        if(NSSTRING_HAS_DATA(self.notificationModal.notificationMessage)){
            msg = self.notificationModal.notificationMessage;
        }
            UIViewController *topControler = [APP_DELEGATE getTopControler];
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:msg preferredStyle:UIAlertControllerStyleAlert];
        
            for(int i = 0; i<[self.notificationModal.actions count]; i++) {
                GMInternalNotificationActionsModal *notificationActionsModal = [self.notificationModal.actions objectAtIndex:i];
                NSString *firstActionTitle = @"";
                
                if(NSSTRING_HAS_DATA(notificationActionsModal.text)){
                    firstActionTitle = notificationActionsModal.text;
                }
                
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:firstActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [topControler dismissViewControllerAnimated:YES completion:nil];
                [self  notificationAction:notificationActionsModal];
            }];
                [alertController addAction:alertAction];
            }
            
        
        [topControler presentViewController:alertController animated:YES completion:nil];
        }
    }
    
}

-(void)notificationAction:(GMInternalNotificationActionsModal*)actionModal {
    
    NSString *value = @"";
    NSString *name = @"";
    
    if(NSSTRING_HAS_DATA(actionModal.page)) {
        value = actionModal.page;
    }
    
    if(NSSTRING_HAS_DATA(actionModal.name)) {
        name = actionModal.name;
    }
    [APP_DELEGATE openScreen:actionModal.key data:value displayName:name];
}


+ (void)showNotificationAlert:(GMInternalNotificationModal *)notiModal{
    
    [MGInternalNotificationAlert sharedInstance].notificationModal = notiModal;
     [[MGInternalNotificationAlert sharedInstance] shownotificationAlert];
}


-(void)showTextFieldAlert {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    BOOL isSubscriptionPopUpShow =  [[defaults objectForKey:key_IsSubscriptionPopUpShow] boolValue];
    
    if(isSubscriptionPopUpShow == FALSE) {
        NSDate* currentTime = [NSDate date];
        [defaults setObject:currentTime forKey:key_SubscriptionPopUp_ShowTime];
        
        NSString *msg  = @"";
        NSString *cancelText  = @"Cancel";
        NSString *oKText  = @"Ok";
        
        if([defaults objectForKey:key_SubscriptionPopUp_Message]) {
            msg = [defaults objectForKey:key_SubscriptionPopUp_Message];
        }
        
        if([defaults objectForKey:key_SubscriptionPopUp_Cancel]) {
            cancelText = [defaults objectForKey:key_SubscriptionPopUp_Cancel];
        }
        
        if([defaults objectForKey:key_SubscriptionPopUp_Ok]) {
            oKText = [defaults objectForKey:key_SubscriptionPopUp_Ok];
        }
        
        
        UIViewController *topControler = [APP_DELEGATE getTopControler];

        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:key_TitleMessage message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
        UIAlertAction *alertOk = [UIAlertAction actionWithTitle:oKText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *textField = alertController.textFields[0];
            
            if([GMSharedClass  validateEmail:textField.text]){
                [alertController dismissViewControllerAnimated:YES completion:nil];
                
                
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults] ;//setObject:deviceTokenString forKey:kEY_notification_token];
                
                NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
                    [userDic setObject:textField.text forKey:@"email"];
                if([userdefault objectForKey:kEY_notification_token]){
                    
                    [userDic setObject:[userdefault objectForKey:kEY_notification_token] forKey:@"device_id"];
                }
                
                NSString *iosUDID = [[GMSharedClass sharedClass] getUDID];
                if(NSSTRING_HAS_DATA(iosUDID)){
                    [userDic setObject:iosUDID forKey:@"ios_uuid"];
                }
                
                
                [[GMOperationalHandler handler] sendSubscribersData:userDic withSuccessBlock:^(id resposeData) {

                   [userdefault setObject:@(YES) forKey:key_IsSubscriptionPopUpShow];
                    [userdefault synchronize];
                    
                } failureBlock:^(NSError *error) {
                    
                }];
                
            }else {
//                [[GMSharedClass sharedClass] showInfoMessage:@"Please Provide Valid email id."];
                [topControler presentViewController:alertController animated:YES completion:nil];
            }
            
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Email Id";
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.delegate = self;
            
//            tf.addTarget(self, action: "textChanged:", forControlEvents: .EditingChanged)
            
        }];
        
        
        [alertController addAction:alertCancel];
        [alertController addAction:alertOk];
        [topControler presentViewController:alertController animated:YES completion:nil];

    }
}

- (BOOL)textField: (UITextField*) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString*)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange: range withString: string];
    
    // check string length
    NSInteger newLength = [newString length];
    BOOL okToChange = (newLength <= 16);    // don't allow names longer than this
    
    if (okToChange)
    {
        // Find our Ok button
        UIResponder *responder = textField;
        Class uiacClass = [UIAlertController class];
        while (![responder isKindOfClass: uiacClass])
        {
            responder = [responder nextResponder];
        }
        UIAlertController *alert = (UIAlertController*) responder;
        UIAlertAction *okAction  = [alert.actions objectAtIndex: 0];
        
        // Dis/enable Ok button based on same-name
        BOOL duplicateName = NO;
        // <check for duplicates, here>
        
        okAction.enabled = !duplicateName;
    }
    
    
    return (okToChange);
}
@end
