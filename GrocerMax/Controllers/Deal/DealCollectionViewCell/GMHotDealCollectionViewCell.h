//
//  GMHotDealCollectionViewCell.h
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMHotDealCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *cellBgView;
@property (strong, nonatomic) IBOutlet UIImageView *dealImage;

- (void)configureCellWithData:(id)data ;

@end
