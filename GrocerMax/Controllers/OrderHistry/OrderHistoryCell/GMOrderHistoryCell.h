//
//  GMOrderHistoryCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMOrderHistoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *cellBgView;
@property (weak, nonatomic) IBOutlet GMButton *reorderBtn;

//@property (strong, nonatomic) IBOutlet UILabel *titleLbl;

-(void)configerViewWithData:(id)modal;
+ (CGFloat) getCellHeight;

@end
