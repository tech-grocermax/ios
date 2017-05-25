//
//  GMRegistrationResponseModal.h
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMRegistrationResponseModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *result;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSNumber *otp;

@property (nonatomic, strong) NSString *flag;
@end
