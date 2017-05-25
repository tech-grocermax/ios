//
//  GMOffersCollectionViewCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOffersCollectionViewCell.h"
#import "GMProductModal.h"
#import "GMOffersByDealTypeModal.h"
#import "GMDealCategoryBaseModal.h"

@interface GMOffersCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImgView;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@end

@implementation GMOffersCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.clipsToBounds = YES;
//    
//    self.itemImgView.layer.cornerRadius = 5.0;
//    self.itemImgView.layer.masksToBounds = YES;
//    self.itemImgView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.itemImgView.layer.borderWidth = 3.0;
}

- (void)configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath andPageContType:(GMRootPageViewControllerType)rootType{
    
    NSString *titleName = @"";
    NSURL *imageUrl ;
    switch (rootType) {
            
        case GMRootPageViewControllerTypeOffersByDealTypeListing:
        {
            GMDealModal *mdl = data;
            titleName = mdl.dealName;
            imageUrl = [NSURL URLWithString:mdl.img];
        }
            break;
            
        case GMRootPageViewControllerTypeDealCategoryTypeListing:
        {
            GMDealModal *mdl = data;
            titleName = mdl.dealName;
            imageUrl = [NSURL URLWithString:mdl.img];
        }
            break;
            
            
        default:
            break;
    }
    
//    [self.itemImgView setImageWithURL:[NSURL URLWithString:mdl.image] placeholderImage:[UIImage imageNamed:@"STAPLES"]];

    NSDictionary* style1 = @{
                             NSFontAttributeName:FONT_LIGHT(13),
                             NSForegroundColorAttributeName : [UIColor whiteColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName:FONT_LIGHT(10),
                             NSForegroundColorAttributeName : [UIColor lightGrayColor]
          
                             };
    if(!NSSTRING_HAS_DATA(titleName)) {
        titleName = @"";
    }
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:titleName attributes:style1];
    
//    [attString1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:mdl.p_name attributes:style2]];
    
    self.itemName.attributedText = attString1;
    [self.itemImgView setImageWithURL:imageUrl placeholderImage:[UIImage subCategoryPlaceHolderImage]];
}

@end
