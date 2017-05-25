//
//  ActivityViewCustomActivity.m
//  FINDIT333
//
//  Created by arvind gupta on 10/12/14.
//  Copyright (c) 2014 Arvind Gupta. All rights reserved.
//

#import "ActivityViewCustomActivity.h"

@implementation ActivityViewCustomActivity
@synthesize message;

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}
- (NSString *)activityType
{
    return @"WhatsApp";
}

- (NSString *)activityTitle
{
    return @"WhatsApp";
}

- (UIImage *)activityImage
{
    // Note: These images need to have a transparent background and I recommend these sizes:
    // iPadShare@2x should be 126 px, iPadShare should be 53 px, iPhoneShare@2x should be 100
    // px, and iPhoneShare should be 50 px. I found these sizes to work for what I was making.

    if(SYSTEM_VERSION_GREATER_THAN(@"7.9"))
    {
        return [UIImage imageNamed:@"whatsApp8"];
    }
    else if(SYSTEM_VERSION_GREATER_THAN(@"6.9"))
    {
        return [UIImage imageNamed:@"whatsApp"];
    }
    else
    {
        return [UIImage imageNamed:@"whatsApp6"];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    //NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    //NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController
{
    //NSLog(@"%s",__FUNCTION__);
    return nil;
}

- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity
    NSString *url = [NSString stringWithFormat:@"whatsapp://send?text=%@",message];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [self activityDidFinish:YES];
}



@end
