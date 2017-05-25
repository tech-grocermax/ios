//
//  GMShopByCategoryCollectionViewCell.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMShopByCategoryCollectionViewCell : UICollectionViewCell
//@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UIButton *offerBtn;

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath;

@end
