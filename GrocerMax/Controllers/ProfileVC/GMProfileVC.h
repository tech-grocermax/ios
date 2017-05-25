//
//  GMProfileVC.h
//  GrocerMax
//
//  Created by Deepak Soni on 12/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMProfileVC : UIViewController

- (void)setSecondTabAsLogIn;
- (void) goOrderHistoryList;
- (void) goToWallet;
- (void) goToMaxCoins;

@property BOOL isMenuWallet;

@end
