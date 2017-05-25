//
//  UIImage+Extends.h
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extends)

+ (UIImage *)placeHolderImage;

+ (UIImage *)validInputFieldImage;

+ (UIImage *)inValidInputFieldImage;

+ (UIImage *)forwardArrowImage;

+ (UIImage *)searchIconImage;

+ (UIImage *)logoImage;

+ (UIImage *)menuBtnImage;

+ (UIImage *)backBtnImage;

#pragma mark - Tab bar Images

+ (UIImage *)home_unselectedImage ;
+ (UIImage *)home_selectedImage ;
+ (UIImage *)profile_unselectedImage;
+ (UIImage *)profile_selectedImage;
+ (UIImage *)offer_unselectedImage ;
+ (UIImage *)offer_selectedImage ;
+ (UIImage *)search_unselectedImage;
+ (UIImage *)search_selectedImage;
+ (UIImage *)cart_unselectedImage;
+ (UIImage *)cart_selectedImage ;

+ (UIImage *)freeImage;

+ (UIImage *)offerImage;

+ (UIImage *)categoryPlaceHolderImage;

+ (UIImage *)subCategoryPlaceHolderImage;

+ (UIImage *)productPlaceHolderImage;

+ (UIImage *)sortSelectedImage;

+ (UIImage *)sortUnSelectedImage;
@end
