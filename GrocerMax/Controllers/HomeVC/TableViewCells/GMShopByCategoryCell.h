//
//  GMShopByCategoryCell.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GMShopByCategoryCellDelegate <NSObject>

@optional
-(void)didSelectCategoryItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath;
-(void)offerBtnPressedAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath;
@end

@interface GMShopByCategoryCell : UITableViewCell

@property(nonatomic,weak)id<GMShopByCategoryCellDelegate>delegate;

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath;

@end
