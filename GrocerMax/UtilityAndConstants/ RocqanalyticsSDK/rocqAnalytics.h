//
//  ROCQ_Analytics.h
//  SDK_iOS
//
//  Created by venkaiah juvvigunta on 7/30/14.
//  Copyright (c) 2014 venkaiah juvvigunta. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <mach/mach.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import <CoreGraphics/CoreGraphics.h>
#import <MapKit/MapKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ifaddrs.h>
#import <AdSupport/ASIdentifierManager.h>
#import <arpa/inet.h>
#import "zlib.h"

#import <Foundation/Foundation.h>

typedef enum positions {TOP=1,LEFT=2,BOTTOM=3,RIGHT=4,CENTRE=5} positions;


@interface rocqAnalytics : NSObject
{
 /**
  *back ground queue to run the database operations in parallel
  */
 dispatch_queue_t backgroundQueue;
    
/**
 *positons for event in screen
 */
@public positions positions;
@public BOOL setCrashReportingEnable;
@public BOOL advertisingEnalbe;
}
/*!
 @method
 @abstract
 shared instance of analyitcs
 */
+(rocqAnalytics*)getSharedInstance;



/*!
 @method
 @abstract
 stores new device information into database if it is not send to server already.
 @param properties  A dictionary of features that we get from new device method of getFeatures class. Properties are like featurtes of the system like GPS,telephony,bluetooth,compass,gyroscope,accelerometer,ibeacon,proximity feature,light intensity feature and also system storage and screen information.
 */
+(void)sendNewDevice:(NSMutableDictionary*)newDeviceInfo;



/*!
 @method
 @abstract
 stores one time device information into database when the application is opened.
 @param properties  A dictionary of features that we get from deviceInfo method of getFeatures class. Properties contaions the information about wifi information,free local storage,free ram,current location details,current cpu usage and phone carrier.
 */
+(void)sendDeviceInfo:(NSMutableDictionary*)deviceInfo;


/*!
 @method
 @abstract
 tracks event with event name, properties of event and position of event button in screen+
 @param eventName - Name of event you want to track
 @param properties - Properties of event you want to track. Properties contains the information about the event details. For example if the event is buy then properties are like  item color,item price and item name. Like this we can mention as many elements as you want in properties dictionary.
 @param position - Position of event in screen. Position might be centre,left,right,bottom,top. This parameter will be help full which type of postion of event is used by users more
 */
+(void)trackEvent:(NSString *)eventName properties:(NSDictionary *)properties position:(int)position;


/*!
 @method
 @abstract
 tracks event with event name, properties of event and position of event button in screen+
 @param eventName - Name of event you want to track
 @param properties - Properties of event you want to track. Properties contains the information about the event details. For example if the event is buy then properties are like  item color,item price and item name. Like this we can mention as many elements as you want in properties dictionary.
 @param buttonID - button ID of an event in screen. This parameter will be help full in getting the position of  event in screen.
 */
+(void)trackEvent:(NSString *)eventName properties:(NSDictionary *)properties buttonID:(id)sender;

/*!
 @method
 @abstract
 tracks event with event name, properties of event.
 @param eventName - Name of event you want to track
 @param properties - Properties of event you want to track. Properties contains the information about the event details. For example if the event is buy then properties are like  item color,item price and item name. Like this we can mention as many elements as you want in properties dictionary.
 */
+(void)trackEvent:(NSString *)eventName properties:(NSDictionary *)properties;

/*!
 @method
 @abstract
 tracks event with event name, position of event in screen.
 @param eventName - Name of event you want to track
 @param position - Position of event in screen. Position might be centre,left,right,bottom,top. This parameter will be help full which type of postion of event is used by users more
 */
+(void)trackEvent:(NSString *)eventName position:(int)position;


/*!
 @method
 @abstract
 tracks event with event name, position of event in screen.
 @param eventName - Name of event you want to track
 @param buttonID - button ID of an event in screen. This parameter will be help full in getting the position of  event in screen.
 */
+(void)trackEvent:(NSString *)eventName buttonID:(id)sender;


/*!
 @method
 @abstract
 tracks event with just event name.
 @param eventName - Name of event you want to track
 */
+(void)trackEvent:(NSString *)eventName;




/*!
 @method
 @abstract 
 tracks screen with screen name and properties of the screen
 @param screen - name of screen you want to track
 @param properties - A dictionary of screen properties you want to track
*/
+(void)trackScreen:(NSString*)screen properties:(NSDictionary *)properties;



/*!
 @method
 @abstract
 tracks screen with screen name.
 @param screen - name of screen you want to track.
 */
+(void)trackScreen:(NSString*)screen;



/*!
 @method
 @abstract
 trtacks user with user ID.
 @param userID - ID of user 
 @param properties - a dictionary of user properties. Properties contains information about the user like user name, age, user city and email ID
 */
+(void)identity:(NSString *)userID properties:(NSDictionary*)properties;


/*!
 @method
 @abstract
 trtacks user with user ID.
 @param userID - ID of user
  */
+(void)identity:(NSString *)userID;

/*!
 @method
 @abstract
 setting app secret if not set
 @param appsecret - It is unique to application. App secret can be get after registering your application at following website  "rocq.io"
 */
+(void)setAppsecret:(NSString *)appsecret;


/*!
 @method
 @abstract
 gets the background queue to run some specific functions
 */
+(dispatch_queue_t)getBackgroundQueue;




+(void)processDataToDBInBackground:(NSMutableDictionary *)data WithKey:(NSString *)dataName;


/*!
 @method
 @abstract
 starts the session when ever new screen opens
 @param screenName - name of the new screen opened
 */
+(void)startSession:(NSString *)screenName  properties:(NSDictionary *)properties;

/*!
 @method
 @abstract
 tracks push notifications
 @param userInfo -push message
 */
+(void)trackPush:(NSDictionary *)userInfo;

/*!
 @method
 @abstract
 sets device token to send push notifications to application
 @param deviceToken
 */
+(void)setDeviceToken:(NSData *)deviceToken;

/*!
 @method
 @abstract
 tracking advertising ID
 @param adID - advertising ID
 */
+(void)trackAdvertisingID:(NSString *)adID;


/*!
 @method
 @abstract
 trakcs referrer
 @param url -url from which the application is installed
 */
+(void)trackreferrer:(NSURL *)url;

/*!
 @method
 @abstract
 stops ongoing session
 */
+(void)stopSession;

/*!
 @method
 @abstract
 sets the value for crash reports
 @param value - bool value to enable crash reports in applicaiton
 */
+(void)setCrashReportingEnalble:(BOOL)value;

/*!
 @method
 @abstract
 sets the value for advertising in application
 @param value - bool value to enable advertising inside application
 */
+(void)enableAdvertising:(BOOL)value;


+(void)deepLink:(NSString *)hostPage;

+(NSDictionary *)parseQueryString:(NSString *)deepLinkQuery;


+(void)setEventPosition:(id)sender;

/*!
 @method
 @abstract
 sets the value for crash reports
 @param value - bool value to enable crash reports in applicaiton
 */
+(void)setShouldUseLocationServices:(BOOL)value;

/*!
 @method
 @abstract
 setting app secret if not set
 @param Debug mode - It is printing logs to application.  */
+(void)setRQDebugMode:(BOOL)rq_debugMode;


/*!
 @method
 @abstract
 stores one time advertiser information into database when the application is opened.
 @param properties  A dictionary of features that we get from advertiseInfo method of getFeatures class. Properties contaions the information about advertiseInfo.
 */
+(void)sendAdvertiseInfo:(NSMutableDictionary*)advertiseInfo;


@end
