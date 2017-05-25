//
//  GMWebViewVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 04/03/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMWebViewVC.h"

#define Network_error @"Network error"

@interface GMWebViewVC ()<UIWebViewDelegate> {
    UILabel *networkErrorLabel;
}
@property (weak, nonatomic) IBOutlet UIWebView *customWebView;

@end

@implementation GMWebViewVC
@synthesize URLRequest;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    networkErrorLabel = [[UILabel alloc]init];
    [networkErrorLabel setBackgroundColor:[UIColor clearColor]];
    networkErrorLabel.text = Network_error;
    [networkErrorLabel setFont:[UIFont italicSystemFontOfSize:14]];
    [networkErrorLabel setTextColor:[UIColor grayColor]];
    [networkErrorLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:networkErrorLabel];
    networkErrorLabel.hidden = TRUE;
    self.customWebView.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    
        [self getDataFromServer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.isTermsAndCondition) {
        self.title = @"TERMS & CONDITIONS";
    } else {
        self.title = @"CONTACT US";
    }
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
//    [self makeTabBarHidden:YES];
   
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    if([[request.URL absoluteString] isEqualToString:@"about:blank"]){
//        return NO;
//    }
//    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self successData];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self failureData];
}


-(void)successData
{
    networkErrorLabel.hidden = TRUE;
    
    [self removeProgress];
}

-(void)failureData
{
    networkErrorLabel.hidden = FALSE;
    [self removeProgress];
}



-(void)getDataFromServer {
    
    [self showProgress];
    
    [[GMOperationalHandler handler] termsAndConditionOrContact:nil isTermsAndCondition:self.isTermsAndCondition withSuccessBlock:^(NSString *responceData) {
        
        [self successData];
        [self.customWebView loadHTMLString:responceData baseURL:nil];
        
    } failureBlock:^(NSError *error) {
        
        [self failureData];
    }];
    
}

@end
