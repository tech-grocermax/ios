//
//  GMAddShippingAddressVC.h
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMAddressModalData;

@protocol AddAShippingddressDelegate <NSObject>

- (void)removeFromSupperView;

@end

typedef void (^NewAddressHandler)(GMAddressModalData *addressModal, BOOL edited);

@interface GMAddShippingAddressVC : UIViewController

@property (nonatomic, strong) GMAddressModalData *editAddressModal;

@property (nonatomic, strong) id<AddAShippingddressDelegate> delegate;

@property (nonatomic) BOOL isComeFromShipping;

@property (nonatomic, strong) NewAddressHandler newAddressHandler;
@end
