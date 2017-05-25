//
//  GMGenderCell.m
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMGenderCell.h"

@implementation GMGenderCell

+ (CGFloat)cellHeight {
    
    return 64.0f;
}

#pragma mark - IBActionMethods

- (IBAction)maleButtonTapped:(id)sender {
    
    [self.maleButton setSelected:YES];
    [self.femaleButton setSelected:NO];
    
    if([self.delegate respondsToSelector:@selector(genderSelectionWithType:)])
        [self.delegate genderSelectionWithType:GMGenderTypeMale];
}

- (IBAction)femaleButtonTapped:(id)sender {
    
    [self.femaleButton setSelected:YES];
    [self.maleButton setSelected:NO];
    
    if([self.delegate respondsToSelector:@selector(genderSelectionWithType:)])
        [self.delegate genderSelectionWithType:GMGenderTypeFemale];
}

@end
