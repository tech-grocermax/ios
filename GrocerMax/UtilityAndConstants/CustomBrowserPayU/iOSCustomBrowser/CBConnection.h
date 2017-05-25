//
//  CBConnection.h
//  PayUTestApp
//
//  Created by Umang Arya on 20/07/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBCustomActivityIndicator.h"
#import "CBConnectionHandler.h"
#import "CBAllPaymentOption.h"


@interface CBConnection : NSObject


@property (nonatomic,assign) BOOL isWKWebView;
@property (nonatomic,assign) int cbServerID;

- (instancetype)init:(UIView *)view webView:(UIWebView *) webView;
- (void)payUActivityIndicator;
- (void)initialSetup;
- (void)payUwebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request;
- (void)payUwebViewDidFinishLoad:(UIWebView *)webView;
//- (void)deallocHandler;

@end
