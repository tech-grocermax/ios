//
//  GMShopByDealCell.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GMShopByDealCellDelegate <NSObject>

@optional
-(void)didSelectDealItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath;

@end

@interface GMShopByDealCell : UITableViewCell

@property(nonatomic,weak)id<GMShopByDealCellDelegate>delegate;

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath;

@end
