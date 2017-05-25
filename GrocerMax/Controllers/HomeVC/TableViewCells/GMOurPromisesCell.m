//
//  GMOurPromisesCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 17/10/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOurPromisesCell.h"

@interface GMOurPromisesCell ()

@property (weak, nonatomic) IBOutlet UILabel *ourPromissesLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation GMOurPromisesCell

- (void)awakeFromNib {
    // Initialization code
    
    NSString *string = @"OUR PROMISES";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    float spacing = 3.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    self.ourPromissesLbl.attributedText = attributedString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Configure cell

-(void)configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath{
    
}


@end
