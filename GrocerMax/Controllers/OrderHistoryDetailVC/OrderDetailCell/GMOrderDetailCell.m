//
//  GMOrderDetailCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderDetailCell.h"

@implementation GMOrderDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configerViewData:(NSString *)title value:(NSString *)value {
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(NSSTRING_HAS_DATA(title) && NSSTRING_HAS_DATA(value)) {
        self.titleLbl.text = title;
        self.valueLbl.text = value;
    } else {
        self.titleLbl.text = @"";
        self.valueLbl.text = @"";
    }
    
}

@end
