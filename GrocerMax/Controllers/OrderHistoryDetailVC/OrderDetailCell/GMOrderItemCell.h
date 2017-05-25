//
//  GMOrderItemCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMOrderDeatilBaseModal.h"

@interface GMOrderItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderItemNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *orderQuantityLbl;

@property (weak, nonatomic) IBOutlet UILabel *totalOrderQuantityLbl;

@property (weak, nonatomic) IBOutlet UILabel *oredrItemPriceLbl;

+ (CGFloat)cellHeight;

- (void)configerViewData:(GMOrderItemDeatilModal *)orderItemDeatilModal;
@end
