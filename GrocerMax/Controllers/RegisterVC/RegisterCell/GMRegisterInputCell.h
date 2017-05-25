//
//  GMRegisterInputCell.h
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderAndValidStatus.h"

@interface GMRegisterInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (nonatomic, assign) StatusType statusType;

@property (nonatomic, assign) BOOL isShowTapped;

+ (CGFloat)cellHeight;
@end
