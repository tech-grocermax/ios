//
//  GMLeftMenuVC.h
//  GrocerMax
//
//  Created by Deepak Soni on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuDelegate <NSObject>

-(void)goToWallet;
-(void)goContactUs;
-(void)goToMaxCoins;


@end

@interface GMLeftMenuVC : UIViewController

@property (weak, nonatomic) id<LeftMenuDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;

@end
