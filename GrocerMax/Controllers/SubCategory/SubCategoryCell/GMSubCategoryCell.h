//
//  GMSubCategoryCell.h
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSubCategoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *subCategoryBtn1;
@property (strong, nonatomic) IBOutlet UIButton *subCategoryBtn2;
//@property (strong, nonatomic) IBOutlet UIButton *subCategoryBtn3;

- (void)configerLastCell;

-(void)configerViewWithData:(id)modal;
@end
