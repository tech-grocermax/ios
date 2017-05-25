//
//  GMSubCategoryVC.h
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSubCategoryVC : UIViewController

@property (nonatomic, strong) NSMutableArray *subcategoryDataArray;//Use to store subcategory data Array

@property (nonatomic, strong) GMCategoryModal *rootCategoryModal;//Use to store subcategory Modal

@end
