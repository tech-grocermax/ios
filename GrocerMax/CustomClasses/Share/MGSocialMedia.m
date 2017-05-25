//
//  MGSocialMedia.m
//  FINDIT333
//
//  Created by arvind gupta on 26/11/14.
//  Copyright (c) 2014 Arvind Gupta. All rights reserved.
//

#import "MGSocialMedia.h"
#import "ActivityViewCustomActivity.h"
#import "AppDelegate.h"
#import "XHDrawerController.h"

@interface MGSocialMedia ()

@end

@implementation MGSocialMedia


static MGSocialMedia *INSTANCE = nil;

+(id)sharedSocialMedia
{
    @synchronized(self)
    {
        if(INSTANCE == nil)
        {
            INSTANCE = [[self alloc] init];
        }
    }
    return INSTANCE;
}

- (void)showActivityView:(NSString *)message;
{
    [self showActivityView:message controler:nil];
}

- (void)showActivityView:(NSString *)message controler:(UIViewController *)mainController
{
    
    NSString *shareText = @"";
    if(message)
    {
        shareText = message;
    }
    //UIImage how can I add an image
    NSArray *itemsToShare = @[shareText];
    NSString *url = [NSString stringWithFormat:@"whatsapp://"];
    
    UIActivityViewController *activityVC ;
//    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
//    {
//        ActivityViewCustomActivity *ca = [[ActivityViewCustomActivity alloc]init];
//        ca.message = shareText;
//        
//        activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare
//                                                       applicationActivities:[NSArray arrayWithObject:ca]];
//    }
//    else
//    {
        activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
//    }
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        activityVC.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    }
    
    
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed)
    {
    };
    
    if(mainController)
    {
        [mainController presentViewController:activityVC animated:YES completion:nil];
    }
    else
    {
        UIViewController *controller = ((UINavigationController*)((APP_DELEGATE).drawerController.centerViewController)).viewControllers.lastObject;
        
        [controller presentViewController:activityVC animated:YES completion:nil];
    }
    
    
}

@end
