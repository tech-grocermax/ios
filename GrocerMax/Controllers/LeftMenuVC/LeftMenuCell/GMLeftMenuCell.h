//
//  GMLeftMenuCell.h
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMCategoryModal.h"

@interface GMLeftMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *expandButton;

- (void)configureWithCategoryName:(NSString *)categoryName;

- (void)configureCellWith:(GMCategoryModal *)categoryModal;

- (void)maskCellFromTop:(CGFloat)margin;

- (void)setIdentationLevelOfCustomCell:(NSUInteger)level;

+ (CGFloat)cellHeight;
@end
