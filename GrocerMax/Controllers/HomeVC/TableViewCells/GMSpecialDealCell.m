//
//  GMSpecialDealCell.m
//  GrocerMax
//
//  Created by Deepak Soni on 4/10/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMSpecialDealCell.h"

@implementation GMSpecialDealCell

- (void)configureSpecialDealCellWith:(GMBannerModal *)bannerModal {
    
    [self.specialDealName setText:bannerModal.name];    
    [self.specialDealImageView setImageWithURL:[NSURL URLWithString:bannerModal.imageURL] placeholderImage:[UIImage subCategoryPlaceHolderImage]];
}

+ (CGFloat)cellHeight {
    
    return 210.0f;
}
@end
