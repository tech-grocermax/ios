//
//  GMSortProductListCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 24/04/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSortProductListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *radioButtonImageView;

+(CGFloat)getCellHeight;
-(void)configerCellViewWithTitle:(NSString *)title selected:(BOOL)isSelected;

@end
