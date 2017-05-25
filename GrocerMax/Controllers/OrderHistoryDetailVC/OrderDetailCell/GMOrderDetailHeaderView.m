//
//  GMOrderDetailHeaderView.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderDetailHeaderView.h"
#import "UIColor+Additions.h"

@implementation GMOrderDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)congigerHeaderData :(NSString *)value{
    self.backgroundColor = [UIColor colorWithRGBValue:244 green:244 blue:244];
    if(NSSTRING_HAS_DATA(value)) {
        self.headerTitleLbl.text = [NSString stringWithFormat:@"%@" ,value];
    }
    else {
        self.headerTitleLbl.text = @"";
    }
}

@end
