//
//  GMSortProductListCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 24/04/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMSortProductListCell.h"

@implementation GMSortProductListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(CGFloat)getCellHeight{
    return 50.0f;
}
-(void)configerCellViewWithTitle:(NSString *)title selected:(BOOL)isSelected{
    
    if(NSSTRING_HAS_DATA(title)){
        self.titleLbl.text = title;
    }else {
        self.titleLbl.text = @"";
    }
    
    
    if(isSelected) {
        self.radioButtonImageView.image = [UIImage sortSelectedImage];
    }else {
        self.radioButtonImageView.image = [UIImage sortUnSelectedImage];
    }
    
}
@end
