//
//  UIColor+Additions.h
//  Ruplee
//
//  Created by deepak.soni on 2/5/15.
//  Copyright (c) 2015 deepak.soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (instancetype)colorWithRGBValue:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)inputTextFieldColor;

+ (UIColor *)inputTextFieldWarningColor;

+ (UIColor *) colorFromHexString:(NSString *)hexString;

+ (UIColor *)inputTextFieldDisableColor;

+ (UIColor *)grayBackgroundColor;

+ (UIColor *)gmRedColor;

+ (UIColor *)gmBlackColor;

+ (UIColor *)gmGrayColor;

+ (UIColor *)gmOrangeColor;
@end
