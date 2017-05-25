//
//  PlaceholderAndValidStatus.h
//  PolicyBazaar
//
//  Created by Neeraj Kumar on 28/08/14.
//  Copyright (c) 2014 Neeraj Kumar. All rights reserved.
//


typedef enum {
	kValid,
	kInvalid,
	kBlank,
    kNone
}StatusType;

#import <Foundation/Foundation.h>

@interface PlaceholderAndValidStatus : NSObject

@property (nonatomic,strong) NSString* placeholder;

@property (nonatomic,assign) StatusType statusType;

@property (nonatomic, strong) NSString *inputFieldCellType;

- (instancetype)initWithCellType:(NSString *)cellType placeHolder:(NSString*)placeholderString andStatus:(StatusType)status;
- (BOOL)isEqual:(PlaceholderAndValidStatus *)statusObj;

@end
