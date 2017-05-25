//
//  GMOrderDetailCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMOrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *valueLbl;

- (void)configerViewData:(NSString *)title value:(NSString *)value;

@end
