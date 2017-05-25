//
//  GMSectionView.h
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSectionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *sectionNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *sectionButton;

- (void)configureWithSectionDisplayName:(NSString *)displayName;

+ (CGFloat)sectionHeight;
@end
