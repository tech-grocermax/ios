//
//  CBWKConnection.h
//  PayU_iOS_SDK_TestApp
//
//  Created by Sharad Goyal on 25/09/15.
//  Copyright (c) 2015 PayU, India. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBCustomActivityIndicator.h"
#import "CBConnectionHandler.h"
#import "CBAllPaymentOption.h"
#import <WebKit/WebKit.h>

@interface CBWKConnection : NSObject

@property (nonatomic,copy) NSString *postData;
@property (nonatomic,copy) NSString *urlString;

@property (nonatomic,assign) BOOL isWKWebView;
@property (nonatomic,assign) int cbServerID;
@property (nonatomic,strong) UIViewController *wkVC;

-(instancetype)init:(UIView *)view webView:(WKWebView *)webView;

-(void)payUActivityIndicator;
-(void) initialSetup;

- (void)payUuserContentController:(WKUserContentController *)userContentController
          didReceiveScriptMessage:(WKScriptMessage *)message;
- (void)payUwebView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;
- (void)payUwebView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation;
- (void)payUwebView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;
- (void)payUwebView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;
-(void)payUwebView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
- (void)payUwebView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;

- (void)payUwebView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)())completionHandler;

- (void)payUwebView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;

- (void)payUwebView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler;


@end
