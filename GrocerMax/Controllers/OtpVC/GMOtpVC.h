//
//  GMOtpVC.h
//  GrocerMax
//
//  Created by Deepak Soni on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMUserModal.h"

@interface GMOtpVC : UIViewController

@property (nonatomic, strong) GMUserModal *userModal;
@property BOOL isEditProfile;

@end
