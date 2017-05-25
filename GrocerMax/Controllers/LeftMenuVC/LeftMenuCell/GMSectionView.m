//
//  GMSectionView.m
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSectionView.h"

@implementation GMSectionView

- (void)configureWithSectionDisplayName:(NSString *)displayName {
    
//    [self.sectionNameLabel setText:displayName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:displayName];
    
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [displayName length])];
    
    self.sectionNameLabel.attributedText = attributedString;
}

+ (CGFloat)sectionHeight {
    
    return 40.0f;
}
@end
