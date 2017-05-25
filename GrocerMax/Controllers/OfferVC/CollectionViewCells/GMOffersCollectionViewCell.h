//
//  GMOffersCollectionViewCell.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMOffersCollectionViewCell : UICollectionViewCell

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath andPageContType:(GMRootPageViewControllerType)rootType;

@end
