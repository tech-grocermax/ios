//
//  CBConstant.h
//  iOSCustomeBrowser
//
//  Created by Suryakant Sharma on 15/04/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#ifndef iOSCustomeBrowser_CBConstant_h
#define iOSCustomeBrowser_CBConstant_h

#define iOS_MANUFACTURER         @"apple"
#define CB_CODE                  @"10.0"
#define MERCHANT_ID              @"gtKFFx"
#define SDK_CODE                 @"20.0"

#define CB_TEST_URL_WKWEBVIEW              @"https://test.payu.in/js/sdk_js/v3/"
#define CB_TEST_URL_UIWEBVIEW              @"https://test.payu.in/js/sdk_js/v4/"
#define CB_MOBILE_TEST_URL_WKWEBVIEW       @"https://mobiletest.payu.in/js/sdk_js/v3/"
#define CB_MOBILE_TEST_URL_UIWEBVIEW       @"https://mobiletest.payu.in/js/sdk_js/v4/"
#define CB_PRODUCTION_URL_WKWEBVIEW        @"https://secure.payu.in/js/sdk_js/v3/"
#define CB_PRODUCTION_URL_UIWEBVIEW        @"https://secure.payu.in/js/sdk_js/v4/"
#define CB_RETRY_PAYMENT_OPTION_URL        @"https://secure.payu.in/_payment_options"

//#define CB_MOBILE_TEST_URL(msg)  [CBConnectionHandler getBaseUrl:(msg)]

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define SCREEN_WIDTH  [[ UIScreen mainScreen ] bounds ].size.width

// To check Test or Production URL
#define IS_TEST_URL 1

#define ENTER_OTP                   @"enterOTP"
#define CHOOSE                      @"choose"
#define OTP                         @"otp"
#define PIN                         @"pin"
#define INCORRECT_PIN               @"incorrectPIN"
#define INCORRECT_OTP               @"incorrectOTP"
#define CLOSE                       @"close"
#define CLOSE_LOADER                @"closeLoader"

#define RETRY_OTP                   @"retryOTP"
#define REGERERATE                  @"regenerate"
#define REGERERATE_OTP              @"regenerate_otp"
#define OTP_LENGTH                  @"otp_length"
#define OTP_REGENERATE_TIMER        @"regen_timer"


#define DETECT_BANK_KEY @"detectBank"
#define INIT  @"init"

// logging on/off
#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...)
#endif


// constants for CBConnection
#define  PG_URL_LIST            @"pgUrlList"
#define INFO_DICT_RESPONSE      @"response"


/*
 
 load custome view
 
 */

#define loadView() \
NSBundle *mainBundle = [NSBundle mainBundle]; \
NSArray *views = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]; \
[self addSubview:views[0]];

#define loadViewWithName(name) \
NSBundle *mainBundle = [NSBundle mainBundle]; \
NSArray *views = [mainBundle loadNibNamed:name owner:self options:nil]; \
[self addSubview:views[0]];


#define     IPHONE_3_5    480
#define     IPHONE_4      568
#define     IPHONE_4_7    667
#define     IPHONE_5_5    736

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif
