//
//  GMApiPathGenerator.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMApiPathGenerator : NSObject


//+ (NSString *)userLoginPath;


/**
 * Function for FB Registration
 * @param
 * @Return FB Registration
 **/
+ (NSString *)fbregisterPath;


/**
 * Function for Check User Login
 * @param
 * @Return loginpath
 **/
+ (NSString *)userLoginPath;

/**
 * Function for Create New User
 * @param
 * @Return createUserPath
 **/
+ (NSString *)createUserPath;

/**
 * Function for Get User Details
 * @param
 * @Return userDetailPath
 **/
+ (NSString *)userDetailPath;


/**
 * Function for User Logout
 * @param
 * @Return logOutPath
 **/
+ (NSString *)logOutPath;

/**
 * Function for User Forgot Password
 * @param
 * @Return forgotPasswordPath
 **/
+ (NSString *)forgotPasswordPath;

/**
 * Function for User Change Password
 * @param
 * @Return changePasswordPath
 **/
+ (NSString *)changePasswordPath;

/**
 * Function for User Edit Profile
 * @param
 * @Return editProfilePath
 **/
+ (NSString *)editProfilePath;

/**
 * Function for Add User Address
 * @param
 * @Return addAddressPath
 **/
+ (NSString *)addAddressPath;

/**
 * Function for Edit User Address
 * @param
 * @Return editAddressPath
 **/
+ (NSString *)editAddressPath;

/**
 * Function for Get All User Address
 * @param
 * @Return getAddressPath
 **/
+ (NSString *)getAddressPath;

/**
 * Function for Delete User Address
 * @param
 * @Return deleteAddressPath
 **/
+ (NSString *)deleteAddressPath;

/**
 * Function for Get User Address With Available Date / Time Slot
 * @param
 * @Return getAddressWithTimeSlotPath
 **/
+ (NSString *)getAddressWithTimeSlotPath;

/**
 * Function for Category Listing
 * @param
 * @Return categoryPath
 **/
+ (NSString *)categoryPath;

/**
 * Function for Product Listing
 * @param
 * @Return productListPath
 **/
+ (NSString *)productListPath;

/**
 * Function for Product Detail
 * @param
 * @Return productDetailPath
 **/
+ (NSString *)productDetailPath;

/**
 * Function for Search
 * @param
 * @Return searchPath
 **/
+ (NSString *)searchPath;

/**
 * Function for Get User Active Orders (Pending,Processing)
 * @param
 * @Return activeOrderPath
 **/
+ (NSString *)activeOrderPath;

/**
 * Function for Get User All Orders History
 * @param
 * @Return orderHistoryPath
 **/
+ (NSString *)orderHistoryPath;

/**
 * Function for Get Orders Detail
 * @param
 * @Return getOrderDetailPath
 **/
+ (NSString *)getOrderDetailPath;

/**
 * Function for Add to Cart
 * @param
 * @Return addToCartPath
 **/
+ (NSString *)addToCartPath;

/**
 * Function for Get Cart Detail
 * @param
 * @Return cartDetailPath
 **/
+ (NSString *)cartDetailPath;

/**
 * Function for Delete and Update Item from Cart
 * @param
 * @Return deleteItemPath
 **/
+ (NSString *)deleteItemPath;

/**
 * Function for Set Order Status
 * @param
 * @Return asetStatusPath
 **/
+ (NSString *)asetStatusPath;

/**
 * Function for Final Order Checkout
 * @param
 * @Return checkoutPath
 **/
+ (NSString *)checkoutPath;

/**
 * Function for Apply Coupon on cart
 * @param
 * @Return addCouponPath
 **/
+ (NSString *)addCouponPath;

/**
 * Function for Remove Coupon on cart
 * @param
 * @Return removeCouponPath
 **/
+ (NSString *)removeCouponPath;

/**
 * Function for Successful Payment
 * @param
 * @Return successPath
 **/
+ (NSString *)successPath;

/**
 * Function for Fail Payment
 * @param
 * @Return failPath
 **/
+ (NSString *)failPath;


/**
 * Function for Successful Payment by payTm
 * @param
 * @Return successPath
 **/
+ (NSString *)successPathForPayTM;

/**
 * Function for Fail Payment by paytm
 * @param
 * @Return failPath
 **/
+ (NSString *)failPathForPayTM;

/**
 * Function for Add to Cart
 * @param
 * @Return addTocartGustPath
 **/
+ (NSString *)addTocartGustPath;

/**
 * Function for Location
 * @param
 * @Return getLocationPath
 **/
+ (NSString *)getLocationPath;

+ (NSString *)getStatePath;

+ (NSString *)getLocalityPath;

+ (NSString *)userCategoryPath;


/**
 * Function for shop by Catalog Listing
 * @param GET Var page, cat_id
 * @output shopbyCategoryPath
 */

+ (NSString *)shopbyCategoryPath;

/**
 * Function for shop by Catalog Listing
 * @param GET Var page, cat_id
 * @output shopByDealTypePath
 */

+ (NSString *)shopByDealTypePath;

/**
 * Function for Deals by deal type  Listing
 * @param GET Var page, deal_type_id
 * @output dealsbydealtypePath
 */

+ (NSString *)dealsbydealtypePath;

/**
 * Function for Deal Catalog Listing
 * @param GET Var page, deal_id
 * @output dealProductListingPath
 */

+ (NSString *)dealProductListingPath;

/**
 * Function for offer By Deal Type
 * @param GET Var page, deal_id
 * @output offerByDealType
 */

+ (NSString *)offerByDealTypePath;

/**
 * Function for product List All
 * @param GET Var page, cat_id
 * @output productListAll
 */

+ (NSString *)productListAllPath;

/**
 This api  use for home page banner
 * Function for home page banner
 * return name,imageurl , linkurl
 * mandatory no
 * @output JSON string
 */

+ (NSString *)homeBannerPath;


/**
 This api  use for genrate hash url
 * Function for payU hash genrate
 * return hash path URL
 * mandatory no
 * @output JSON string
 */

+ (NSString *)hashGenreatePath;

/**
 This api  use to send device token
 * Function for send device token
 * return device token path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)sendDeviceToken;

/**
 This api  use home page
 * Function for home page
 * return home page path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)homePagePath;

/**
 This api  use to reorder your order
 * Function for reorder your order
 * return reorder path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)reorderPath;

/**
 This api  use for wallet
 * Function for To get internal wallet monney
 * return internal wallet path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)walletPath;

/**
 This api  to decrease balence from internal wallet
 * Function for To decrease balence from internal wallet
 * return internal wallet balence decrease path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)decreasewWalletBalancePath;

/**
 This api  use to wallet order history
 * Function wallet order history
 * return wallet history path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)walletHistoryPath;

/**
 This api  use to get payment way
 * Function get payment way
 * return payment way path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)paymentWayPath;


/**
 This api  use to citrus payment cancle and suceess
 * Function get payment way
 * return payment way path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)loadCitrus;


/**
 This api  use to get terms and condition
 * Function get terms and condition
 * return terms and condition path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)termandCondition ;


/**
 This api  use to get contact detail
 * Function get contact detail
 * return contact path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)contact;


/**
 This api  use to get subcategorybanner
 * Function get subcategorybanner
 * return subcategorybanner path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)subcategorybannerPath;


/**
 This api  use to get specialdeal
 * Function get specialdeal
 * return specialdeal path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)specialdealPath;


/**
 This api  use to get couponcode
 * Function get couponcode
 * return couponcode path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)couponcodePath ;

/**
 This api  use to get maxCoins List
 * Function get maxCoinsList
 * return maxCoin path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)maxCoinsPath;


/**
 This api  use to subscribers emailId for nonlogin user
 * Function send subscribers emailId
 * return subscribers path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)subscribersPath;

/**
 This api  use to single page banner
 * Function single page banner
 * return single page banner path URL
 * mandatory no
 * @output JSON string
 */
+ (NSString *)pagebannermsgPath;

@end
