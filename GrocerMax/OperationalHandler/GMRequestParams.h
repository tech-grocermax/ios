//
//  GMRequestParams.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GMCartModal;
@class GMAddressModalData;
@class GMProductModal;

@interface GMRequestParams : NSObject

+ (instancetype)sharedClass;

#pragma mark - Login Req Param

/**
 * Function for Fb Register New User ( facebook and gmail)
 * @param GET Var uemail, password, fname, lname, number
 * @output JSON string
 */

+ (NSMutableDictionary *)getUserFBLoginRequestParamsWith:(NSDictionary*)parameterDic;

- (NSMutableDictionary *)getUserLoginRequestParamsWith:(NSString *)userName password:(NSString *)password;

/**
 * Function for make user login parameter.
 * @param parameter dictionary
 * @Return get parameter for Login
 **/

+ (NSString *)userLoginParameter:(NSDictionary *)parameterDic;


/**
 * Function for make create user parameter.
 * @param parameter dictionary
 * @Return get parameter for createUser
 **/
+ (NSString *)createUserParameter:(NSDictionary *)parameterDic ;

/**
 * Function for make userDetail parameter.
 * @param parameter dictionary
 * @Return get parameter for user detail
 **/
+ (NSString *)userDetailParameter:(NSDictionary *)parameterDic;


/**
 * Function for make userlogout parameter.
 * @param parameter dictionary
 * @Return get parameter for user logout
 **/
+ (NSString *)logoutParameter:(NSDictionary *)parameterDic;


/**
 * Function for make userlogout parameter.
 * @param parameter dictionary
 * @Return get parameter for user logout
 **/
+ (NSString *)forgotPasswordParameter:(NSDictionary *)parameterDic;

/**
 * Function for make changePassword parameter.
 * @param parameter dictionary
 * @Return get parameter for user change password
 **/
+ (NSString *)changePasswordParameter:(NSDictionary *)parameterDic;


/**
 * Function for make edit Profile parameter.
 * @param parameter dictionary
 * @Return get parameter for user edit profile
 **/
+ (NSString *)editProfileParameter:(NSDictionary *)parameterDic;

/**
 * Function for make add and edit address parameter.
 * @param parameter dictionary
 * @Return get parameter for user add and edit address
 **/
+ (NSString *)addAndEditAddressParameter:(NSDictionary *)parameterDic;


/**
 * Function for make get user address parameter.
 * @param parameter dictionary
 * @Return get parameter for get user address
 **/
+ (NSString *)getAddressParameter:(NSDictionary *)parameterDic;


/**
 * Function for make delete user address parameter.
 * @param parameter dictionary
 * @Return get parameter for delete user address
 **/
+ (NSString *)deleteAddressParameter:(NSDictionary *)parameterDic ;

/**
 * Function for make get user Address With Time Slot address parameter.
 * @param parameter dictionary
 * @Return get parameter for get user Address With Time Slot address
 **/
+ (NSString *)getAddressWithTimeSlotParameter:(NSDictionary *)parameterDic;

/**
 * Function for make get category list parameter.
 * @param parameter dictionary
 * @Return get parameter for get category list
 **/
+ (NSString *)categoryParameter:(NSDictionary *)parameterDic;


/**
 * Function for make get product list parameter.
 * @param parameter dictionary
 * @Return get parameter for get product list
 **/
+ (NSString *)productListParameter:(NSDictionary *)parameterDic;

/**
 * Function for make get product detail parameter.
 * @param parameter dictionary
 * @Return get parameter for get product detail
 **/
+ (NSString *)productDetailParameter:(NSDictionary *)parameterDic;

/**
 * Function for make search parameter.
 * @param parameter dictionary
 * @Return get parameter for search
 **/
+ (NSString *)searchParameter:(NSDictionary *)parameterDic;


/**
 * Function for make active order or order histry parameter.
 * @param parameter dictionary
 * @Return get parameter for active order or order histry
 **/
+ (NSString *)activeOrderOrOrderHistryParameter:(NSDictionary *)parameterDic;


/**
 * Function for make order detail parameter.
 * @param parameter dictionary
 * @Return get parameter for order detail
 **/
+ (NSString *)getOrderDetailParameter:(NSDictionary *)parameterDic;

/**
 * Function for make add to cart parameter.
 * @param parameter dictionary
 * @Return get parameter for add to cart
 **/
+ (NSString *)addToCartParameter:(NSDictionary *)parameterDic;


/**
 * Function for make cart detail parameter.
 * @param parameter dictionary
 * @Return get parameter for cart detail
 **/
+ (NSString *)cartDetailParameter:(NSDictionary *)parameterDic;

/**
 * Function for make delete item parameter.
 * @param parameter dictionary
 * @Return get parameter for delete item
 **/
+ (NSString *)deleteItemParameter:(NSDictionary *)parameterDic;

/**
 * Function for make set order status parameter.
 * @param parameter dictionary
 * @Return get parameter for set order status
 **/
+ (NSString *)setStatusParameter:(NSDictionary *)parameterDic;

/**
 * Function for make order check out parameter.
 * @param parameter dictionary
 * @Return get parameter for checkout
 **/
+ (NSString *)checkoutParameter:(NSDictionary *)parameterDic;

/**
 * Function for make add or remove coupon code parameter.
 * @param parameter dictionary
 * @Return get parameter for add or remove coupon code
 **/
+ (NSString *)addOrRemoveCouponParameter:(NSDictionary *)parameterDic;

/**
 * Function for make payment sucess or faill parameter.
 * @param parameter dictionary
 * @Return get parameter for payment sucess or faill
 **/
+ (NSString *)paymentSuccessOrfailParameter:(NSDictionary *)parameterDic;


/**
 * Function for make add to cart as a guest parameter.
 * @param parameter dictionary
 * @Return get parameter for add to cart as a guest
 **/
+ (NSString *)addToCartGustParameter:(NSDictionary *)parameterDic ;


/**
 * Function for make get location parameter.
 * @param parameter dictionary
 * @Return get parameter for get location
 **/
+ (NSString *)getLocationParameter:(NSDictionary *)parameterDic;

- (NSDictionary *)getAddAddressParameterDictionaryFrom:(GMAddressModalData *)addressModal andIsNewAddres:(BOOL)isNewAddress;

/**
 * Function for shop by Catalog Listing
 * @param parameter dictionary
 * @Return get parameter for shopbyCategory
 **/
+ (NSString *)shopbyCategoryParameter:(NSDictionary *)parameterDic;

/**
 * Function for shop by Catalog Listing
 * @param parameter dictionary
 * @Return get parameter for shopByDealType
 **/
+ (NSString *)shopByDealTypeParameter:(NSDictionary *)parameterDic;


/**
 * Function for Deals by deal type  Listing
 * @param parameter dictionary
 * @Return get parameter for dealsByDealType
 **/
+ (NSString *)dealsByDealTypeParameter:(NSDictionary *)parameterDic ;


/**
 * Function for Deal Catalog Listing
 * @param parameter dictionary
 * @Return get parameter for dealProductListing
 **/
+ (NSString *)dealProductListingParameter:(NSDictionary *)parameterDic;

/**
 * Function for offer By Deal Type
 * @param parameter dictionary
 * @Return get parameter for offerByDealType
 **/
+ (NSString *)offerByDealTypeParameter:(NSDictionary *)parameterDic;

/**
 * Function for all product list
 * @param parameter dictionary
 * @Return get parameter for product List All
 **/
+ (NSString *)productListAllParameter:(NSDictionary *)parameterDic;

    
@end
