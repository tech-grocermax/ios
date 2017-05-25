//
//  GMPageControllCell.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GMPageControllCellDelegate <NSObject>

@optional
-(void)didSelectItemAtTableViewCellIndexPath:(NSIndexPath*)tblIndexPath andCollectionViewIndexPath:(NSIndexPath *)collectionIndexpath;

@end

@interface GMPageControllCell : UITableViewCell

@property(nonatomic,strong)NSIndexPath *tblViewCellIndexPath;

@property(nonatomic,weak)id<GMPageControllCellDelegate>delegate;

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath;

@end
