//
//  GMSearchVC.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 01/10/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSearchVC : UIViewController

- (void)performSearchOnServerWithParam:(NSDictionary*)param isBanner:(BOOL)isBanner;

@end
