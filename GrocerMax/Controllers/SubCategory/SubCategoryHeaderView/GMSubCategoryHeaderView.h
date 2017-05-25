//
//  GMSubCategoryHeaderView.h
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSubCategoryHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UIView *cellBgView;

@property (strong, nonatomic) IBOutlet UIImageView *subcategoryImageView;

@property (strong, nonatomic) IBOutlet UIButton *subcategoryBtn;

- (void)configerViewWithData:(id)modal;

- (void)configerViewWithNewData:(id)modal;

@end
