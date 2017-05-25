//
//  UIImage+Extends.m
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "UIImage+Extends.h"

static NSString * const kPlaceHolderImage                = @"";
static NSString * const kValidInputImage                 = @"check";
static NSString * const kInValidInputImage               = @"error";
static NSString * const kForwardArrowImage               = @"forward_caret";
static NSString * const kSearch_iconImage                = @"search_icon";
static NSString * const kLogoImage                       = @"logo";
static NSString * const kmenuBtnImage                    = @"menuBtn";
static NSString * const kbackBtnImage                    = @"back";
static NSString * const knewBackBtnImage                 = @"newBack";


static NSString * const khome_unselectedImage                      = @"home_unselected";
static NSString * const khome_selectedImage                        = @"home_selected";
static NSString * const kprofile_unselectedImage                   = @"profile_unselected";
static NSString * const kprofile_selectedImage                     = @"profile_selected";
static NSString * const koffer_unselectedImage                     = @"offer_unselected";
static NSString * const koffer_selectedImage                       = @"offer_selected";
static NSString * const ksearch_unselectedImage                    = @"search_unselected";
static NSString * const ksearch_selectedImage                      = @"search_selected";
static NSString * const kcart_unselectedImage                      = @"cart_unselected";
static NSString * const kcart_selectedImage                        = @"cart_selected";
static NSString * const kOfferImage                                = @"offer-tag";
static NSString * const kfreeImage                                 = @"free";

static NSString * const kCategoryPlaceHolderImage                  = @"categoryPlaceHolder";
static NSString * const kSubCategoryPlaceHolderImage               = @"subCategoryPlaceHolder";
static NSString * const kProductPlaceHolderImage                   = @"productPlaceHolder";


static NSString * const kSortUnSelectedRadioButton                                = @"radiounselected";
static NSString * const kSortSelectedRadioButton                                 = @"radioselected";

@implementation UIImage (Extends)

#pragma mark - RegistrationVC Image

+ (UIImage *)placeHolderImage {
    
    return [[UIImage imageNamed:kPlaceHolderImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)validInputFieldImage {
    
    return [[UIImage imageNamed:kValidInputImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)inValidInputFieldImage {
    
    return [[UIImage imageNamed:kInValidInputImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)forwardArrowImage {
    
    return [[UIImage imageNamed:kForwardArrowImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)searchIconImage{
    
    return [[UIImage imageNamed:kSearch_iconImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)logoImage{
    
    return [[UIImage imageNamed:kLogoImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)menuBtnImage{
    
    return [[UIImage imageNamed:kmenuBtnImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)backBtnImage {
    
    return [[UIImage imageNamed:knewBackBtnImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - Tab bar Images

+ (UIImage *)home_unselectedImage {
    
    return [[UIImage imageNamed:khome_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)home_selectedImage {
    
    return [[UIImage imageNamed:khome_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)profile_unselectedImage {
    
    return [[UIImage imageNamed:kprofile_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)profile_selectedImage {
    
    return [[UIImage imageNamed:kprofile_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)offer_unselectedImage {
    
    return [[UIImage imageNamed:koffer_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)offer_selectedImage {
    
    return [[UIImage imageNamed:koffer_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)search_unselectedImage {
    
    return [[UIImage imageNamed:ksearch_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)search_selectedImage {
    
    return [[UIImage imageNamed:ksearch_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)cart_unselectedImage {
    
    return [[UIImage imageNamed:kcart_unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)cart_selectedImage {
    
    return [[UIImage imageNamed:kcart_selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)freeImage {
    
    return [[UIImage imageNamed:kfreeImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)offerImage {
    
    return [[UIImage imageNamed:kOfferImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)categoryPlaceHolderImage {
    
    return [[UIImage imageNamed:kCategoryPlaceHolderImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)subCategoryPlaceHolderImage {
    
    return [[UIImage imageNamed:kSubCategoryPlaceHolderImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)productPlaceHolderImage {
    
    return [[UIImage imageNamed:kProductPlaceHolderImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


+ (UIImage *)sortSelectedImage {
    
    return [[UIImage imageNamed:kSortSelectedRadioButton] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


+ (UIImage *)sortUnSelectedImage {
    
    return [[UIImage imageNamed:kSortUnSelectedRadioButton] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
