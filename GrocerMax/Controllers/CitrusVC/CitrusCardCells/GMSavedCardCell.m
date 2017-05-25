//
//  GMSavedCardCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 23/02/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMSavedCardCell.h"

@implementation GMSavedCardCell

- (void)awakeFromNib {
    // Initialization code
    self.bgView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
