//
//  MGSocialMedia.h
//  FINDIT333
//
//  Created by arvind gupta on 26/11/14.
//  Copyright (c) 2014 Arvind Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGSocialMedia : NSObject 

+(id)sharedSocialMedia;

- (void)showActivityView:(NSString *)message;
- (void)showActivityView:(NSString *)message controler:(UIViewController *)mainController;

@end
