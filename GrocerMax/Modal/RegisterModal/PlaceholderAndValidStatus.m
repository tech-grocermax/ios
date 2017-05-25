//
//  PlaceholderAndValidStatus.m
//  PolicyBazaar
//
//  Created by Neeraj Kumar on 28/08/14.
//  Copyright (c) 2014 Neeraj Kumar. All rights reserved.
//

#import "PlaceholderAndValidStatus.h"

@implementation PlaceholderAndValidStatus

@synthesize placeholder = _placeholder;
@synthesize statusType = _statusType;

- (instancetype)initWithCellType:(NSString *)cellType placeHolder:(NSString *)placeholderString andStatus:(StatusType)status {
    
    _inputFieldCellType = cellType;
    _placeholder = placeholderString;
    _statusType = status;
    return self;
}


- (BOOL)isEqual:(PlaceholderAndValidStatus *)statusObj {
    if (self == statusObj)  // this is pointer comparision..
        return YES;
    if (![(id)[self placeholder] isEqual:[statusObj placeholder]]) // this is value comparision..
        return NO;
    return YES;
}
@end
