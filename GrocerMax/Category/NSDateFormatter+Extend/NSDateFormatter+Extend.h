//
//  NSDateFormatter+Extend.h
//  MunchAdo
//
//  Created by Amit kumar Swami on 08/04/15.
//  Copyright (c) 2015 Munchado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Extend)

+ (NSDateFormatter*)shareFormatter;

+ (NSDateFormatter *)dateFormatter_yyyy_MM_dd_hh_mm_ss_Z;

+ (NSDateFormatter *)dateFormatter_yyyy_MM_dd ;

+ (NSDateFormatter *)dateFormatter_hh_mm_a;

+ (NSDateFormatter *)dateFormatter_DD_MMM_YYYY;

+ (NSDateFormatter *)dateFormatter_MMM_DD__YYYY;
@end
