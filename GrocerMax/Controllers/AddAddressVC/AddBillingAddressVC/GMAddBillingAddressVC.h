//
//  GMAddBillingAddressVC.h
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NewBillingAddressHandler)(GMAddressModalData *address, BOOL edited);

@interface GMAddBillingAddressVC : UIViewController

@property (nonatomic, strong) GMAddressModalData *editAddressModal;

@property (nonatomic, strong) NewBillingAddressHandler newBillingAddressHandler;
@end
