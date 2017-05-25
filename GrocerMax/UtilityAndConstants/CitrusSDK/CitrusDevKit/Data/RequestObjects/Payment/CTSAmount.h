//
//  CTSAmount.h
//  RestFulltester
//
//  Created by Raji Nair on 24/06/14.
//  Copyright (c) 2014 Citrus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface CTSAmount : JSONModel
@property(strong) NSString* currency, *value;
- (instancetype)initWithValue:(NSString *)valueArg;


@end
