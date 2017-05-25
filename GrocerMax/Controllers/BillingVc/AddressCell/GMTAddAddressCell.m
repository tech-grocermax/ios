//
//  GMTAddAddressCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMTAddAddressCell.h"

@implementation GMTAddAddressCell

- (void)awakeFromNib {
    // Initialization code
    
    self.cellBgView.layer.borderColor = [UIColor colorWithRed:216.0/256.0 green:216.0/256.0 blue:216.0/256.0 alpha:1].CGColor;
    self.cellBgView.layer.borderWidth = 2.0;
    self.cellBgView.layer.cornerRadius = 4.0;
    
    [self setBackgroundColor:[UIColor colorWithRed:230.0/256.0 green:230.0/256.0 blue:230.0/256.0 alpha:1]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
