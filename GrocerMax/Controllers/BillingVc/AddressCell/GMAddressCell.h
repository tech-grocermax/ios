//
//  GMAddressCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMAddressCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *cellBgView;

@property (strong, nonatomic) IBOutlet UILabel *addressLbl;

@property (strong, nonatomic) IBOutlet GMButton *editAddressBtn;

@property (strong, nonatomic) IBOutlet GMButton *selectUnSelectBtn;


- (void)configerViewWithData:(id)modal;

+ (CGFloat)cellHeight;
@end
