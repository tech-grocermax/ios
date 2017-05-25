//
//  GMLeftMenuCell.m
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMLeftMenuCell.h"

@interface GMLeftMenuCell()

@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *dividerLineImaegView;

@end

NSUInteger const leftMargin = 15;

@implementation GMLeftMenuCell

- (void)configureWithCategoryName:(NSString *)categoryName {
    
    [self.categoryNameLabel setText:categoryName];
    [self.expandButton setHidden:YES];
    [self.arrowImageView setHidden:NO];
    [self.dividerLineImaegView setHidden:YES];
}

- (void)configureCellWith:(GMCategoryModal *)categoryModal {
    
    [self.arrowImageView setHidden:YES];
    [self.categoryNameLabel setText:categoryModal.categoryName];
    [self.expandButton setSelected:!categoryModal.isExpand];
    [self setIdentationLevelOfCustomCell:categoryModal.indentationLevel];
    if(categoryModal.isExpand) {
        
        [self.dividerLineImaegView setHidden:NO];
        [self.expandButton setHidden:NO];
    }
    else {
        
        [self.dividerLineImaegView setHidden:YES];
        [self.expandButton setHidden:YES];
    }
}

- (void)setIdentationLevelOfCustomCell:(NSUInteger)level {
    
    self.leftMarginConstraint.constant = leftMargin + (leftMargin * level);
}

+ (CGFloat)cellHeight {
    
    return 40.0f;
}

- (void)maskCellFromTop:(CGFloat)margin {
    self.layer.mask = [self visibilityMaskWithLocation:margin/self.frame.size.height];
    self.layer.masksToBounds = YES;
}

- (CAGradientLayer *)visibilityMaskWithLocation:(CGFloat)location {
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.frame = self.bounds;
    mask.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0] CGColor], (id)[[UIColor colorWithWhite:1 alpha:1] CGColor], nil];
    mask.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:location], [NSNumber numberWithFloat:location], nil];
    return mask;
}

@end
