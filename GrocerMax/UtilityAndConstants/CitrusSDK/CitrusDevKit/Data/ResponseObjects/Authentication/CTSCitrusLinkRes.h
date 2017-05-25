//
//  CTSCitrusLinkRes.h
//  CTS iOS Sdk
//
//  Created by Yadnesh Wankhede on 11/9/15.
//  Copyright © 2015 Citrus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTSResponse.h"
typedef enum {
    CitrusSiginTypeMOtp,
    CitrusSiginTypeEOtp,
    CitrusSiginTypePassword,
    CitrusSiginTypeMOtpOrPassword,
    CitrusSiginTypeEOtpOrPassword
} CitrusSiginType;
@interface CTSCitrusLinkRes : NSObject
@property(strong)NSString *userMessage;
@property(assign)CitrusSiginType siginType;
@property(strong)NSString *linkedMobile;
@property(strong)NSString *linkedEmail;


-(instancetype)initWithResponse:(CTSResponse *)response;
@end
