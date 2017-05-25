//
//  NSDateFormatter+Extend.m
//  MunchAdo
//
//  Created by Amit kumar Swami on 08/04/15.
//  Copyright (c) 2015 Munchado. All rights reserved.
//

#import "NSDateFormatter+Extend.h"

@implementation NSDateFormatter (Extend)

#pragma mark- Search Param Formatters

+ (NSDateFormatter*)shareFormatter {
    static NSDateFormatter *_sharedFormatter = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedFormatter = [[self alloc] init];
        _sharedFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//        _sharedFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    
    _sharedFormatter.timeZone = [NSTimeZone defaultTimeZone];
//    NSLog(@"_sharedFormatter.timeZone = %@",_sharedFormatter.timeZone.name);
    
    return _sharedFormatter;
}

+ (NSDateFormatter *)dateFormatter_yyyy_MM_dd_hh_mm_ss_Z {
    [[self shareFormatter] setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    return [self shareFormatter];
}

+ (NSDateFormatter *)dateFormatter_yyyy_MM_dd {
    [[self shareFormatter] setDateFormat:@"yyyy-MM-dd"];
    return [self shareFormatter];
}

+ (NSDateFormatter *)dateFormatter_hh_mm_a {
    [[self shareFormatter] setDateFormat:@"hh:mm a"];
    return [self shareFormatter];
}

+ (NSDateFormatter *)dateFormatter_DD_MMM_YYYY {
    
    [[self shareFormatter] setDateFormat:@"dd MMM, yyyy"];
    return [self shareFormatter];
}

+ (NSDateFormatter *)dateFormatter_MMM_DD__YYYY {
    
    [[self shareFormatter] setDateFormat:@"MMM dd yyyy"];
    return [self shareFormatter];
}
@end
