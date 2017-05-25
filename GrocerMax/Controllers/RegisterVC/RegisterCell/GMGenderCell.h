//
//  GMGenderCell.h
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GMGenderCellDelegate <NSObject>

- (void)genderSelectionWithType:(GMGenderType)genderType;

@end

@interface GMGenderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *maleButton;

@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@property (nonatomic, weak) id <GMGenderCellDelegate> delegate;

+ (CGFloat)cellHeight;
@end
