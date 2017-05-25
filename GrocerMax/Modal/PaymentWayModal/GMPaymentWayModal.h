//
//  GMPaymentWayModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 06/02/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMPaymentWayModal : NSObject

@property (nonatomic, strong) NSString *paymentMethodDisplayName;
@property (nonatomic, strong) NSString *paymentMethodId;
@property (nonatomic, strong) NSString *paymentMethodNameCode;
@property (nonatomic, strong) NSString *paymentMethodDefaultName;
@property (nonatomic, strong) NSString *displayOrder;

- (instancetype)initWithPaymentWayDictionary:(NSDictionary *)responseDict;
@end
