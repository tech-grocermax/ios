//
//  GMCouponModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 02/07/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMCouponModal : NSObject


@property (nonatomic, strong) NSString *couponCode;

@property (nonatomic, strong) NSString *couponName;

@property (nonatomic, strong) NSString *couponDescription;

@property (nonatomic, strong) NSString *couponValidDate;

@property  BOOL isViewTermAndCondition;

@property  BOOL isApply;

- (instancetype)initWithCouponListDictionary:(NSDictionary *)responseDict;

@end
