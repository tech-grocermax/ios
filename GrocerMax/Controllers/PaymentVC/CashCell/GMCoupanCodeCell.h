//
//  GMCoupanCodeCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 29/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMCoupanCodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *coupanCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *applyCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *textfeildBgView;

+ (CGFloat) cellHeight;

- (void)configerView:(id)modal carDetail:(GMCartDetailModal *)cartDetailModal;
@end
