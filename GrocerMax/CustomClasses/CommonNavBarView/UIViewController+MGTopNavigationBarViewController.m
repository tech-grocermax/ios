//
//  UIViewController+MGTopNavigationBarViewController.m
//  FINDIT333
//
//  Created by rahul chaudhary on 10/01/15.
//  Copyright (c) 2015 Arvind Gupta. All rights reserved.
//

#import "UIViewController+MGTopNavigationBarViewController.h"

@implementation UIViewController (MGTopNavigationBarViewController)
#pragma mark - Load Nav Bar View




-(GMCommonNavBarView*)addBarViewWithTitle:(NSString*)titleString isRightButton:(BOOL)isRightButton{
    
    GMCommonNavBarView *navigationBarView = [[[NSBundle mainBundle] loadNibNamed:@"GMCommonNavBarView" owner:nil options:nil] firstObject];
    
    navigationBarView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 60);
    
//    [navigationBarView.backBtn addTarget:self action:@selector(dismissBackBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [navigationBarView.menuBtn addTarget:self action:@selector(navigationMenuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    if(isRightButton) {
        navigationBarView.rightButton.hidden = FALSE;
    }else {
        navigationBarView.rightButton.hidden = TRUE;
    }
    
    if(NSSTRING_HAS_DATA(titleString))
    {
        navigationBarView.titleLbl.text = titleString;
    }
    
    [self.view addSubview:navigationBarView];
    
    return navigationBarView;
}

#pragma mark - UIButton Action

-(void)navigationBackBtnPressed:(UIButton*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dismissBackBtnPressed:(UIButton*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)navigationMenuBtnPressed:(UIButton*)sender{
    
    
}


@end
