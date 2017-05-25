//
//  UIColor+Additions.m
//  Ruplee
//
//  Created by deepak.soni on 2/5/15.
//  Copyright (c) 2015 deepak.soni. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (instancetype)colorWithRGBValue:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    
    return [[self alloc] initWithRGBValue:red green:green blue:blue];
}

- (instancetype)initWithRGBValue:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    
    CGFloat r = red / 255.0f;
    CGFloat g = green / 255.0f;
    CGFloat b = blue / 255.0f;
    return [self initWithRed:r green:g blue:b alpha:1.0f];
}

+ (UIColor *) colorFromHexString:(NSString *)hexString {
    
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)inputTextFieldColor {
    
    return [UIColor colorWithRGBValue:29.0 green:29.0 blue:29.0];
}

+ (UIColor *)inputTextFieldWarningColor {
    
    return [UIColor colorWithRGBValue:208.0 green:79.0 blue:59.0];
}

+ (UIColor *)inputTextFieldDisableColor {
    return [UIColor colorWithRGBValue:233.0 green:233.0 blue:233.0];
}

+ (UIColor *)grayBackgroundColor {
    return [UIColor colorWithRGBValue:244.0 green:244.0 blue:244.0];
}

+ (UIColor *)gmRedColor {
    return [UIColor colorFromHexString:@"#EE2D09"];
}

+ (UIColor *)gmBlackColor {
    return [UIColor colorFromHexString:@"#1D1D1D"];
}

+ (UIColor *)gmGrayColor {
    return [UIColor colorFromHexString:@"#7D7D7D"];
}

+ (UIColor *)gmOrangeColor {
    return [UIColor colorFromHexString:@"#FFA800"];
}
@end
