//
//  GMSpecialDealCell.h
//  GrocerMax
//
//  Created by Deepak Soni on 4/10/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMBannerModal.h"

@interface GMSpecialDealCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *specialDealName;

@property (weak, nonatomic) IBOutlet UIImageView *specialDealImageView;

- (void)configureSpecialDealCellWith:(GMBannerModal *)bannerModal;

+ (CGFloat)cellHeight;
@end
