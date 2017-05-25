//
//  CTSNetBankingUpdate.h
//  RestFulltester
//
//  Created by Yadnesh Wankhede on 19/06/14.
//  Copyright (c) 2014 Citrus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTSProfileLayerConstants.h"
#import "CTSObject.h"

@interface CTSNetBankingUpdate : CTSObject
@property(strong, readonly) NSString* type;
@property(strong ) NSString* name; //user defined name
@property(strong ) NSString* bank; //name of the bank
@property(strong ) NSString* code; //CID code
@property(strong ) NSString* token;
@property(strong ) NSString* issuerCode;

@end
