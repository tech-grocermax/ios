//
//  GMConstants.h
//  GrocerMax
//
//  Created by Deepak Soni on 09/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#define GrocerMax_GMConstants_h

#ifdef DEBUG
#define DLOG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLOG(xx, ...)  ((void)0)
#endif

#define SCREEN_SIZE    CGSizeMake([[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height)

#define SYSTEM_VERSION_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//#define HAS_KEY(_x,_y) (([_x objectForKey:_y]) && !([[_x objectForKey:_y] isEqual:[NSNull null]]))

#define HAS_KEY(_x,_y) ([_x isKindOfClass:[NSDictionary class]] && (([_x objectForKey:_y]) && !([[_x objectForKey:_y] isEqual:[NSNull null]])))

//#define NSSTRING_HAS_DATA(_x) (((_x) != nil) && ( [(_x) length] > 0 ))
#define NSSTRING_HAS_DATA(_x) (((_x) != nil) && (![(_x) isKindOfClass:[NSNull class]]) && ( [(_x) length]>0))

#define HAS_DATA(_x,_y) (([_x objectForKey:_y]) && !([[_x objectForKey:_y] isEqual:[NSNull null]]) && ([[NSString stringWithFormat:@"%@", [_x objectForKey:_y]] length] > 0))

#define GMLocalizedString(key) [[NSBundle mainBundle]localizedStringForKey:(key) value:@"" table:@"Messages"]

#define APP_DELEGATE (AppDelegate *)([[UIApplication sharedApplication] delegate])

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define grocerMaxDirectory [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)

#define APPLE_APP_ID				@"1049822835"
#define AppsFyler_Key	            @"XNjhQZD7Yhe2dFs8kL7bpn"

#define PAYTM_MERCHANT_ID            @"grocer28494183264317"
#define PAYTM_WEBSITE                @"Retailwap"
#define PAYTM_INDUSTRYID             @"Retail101"
#define PAYTM_CHANNELID              @"WAP"
#define PAYTM_CHECKSUMGENRATIONURL   @"http://grocermax.com/generateChecksum.php"
#define PAYTM_CHECKVALIDATIONURL     @"http://grocermax.com/verifyChecksum.php"

#define QGRAPH_APP_ID               @"1edab9dae01bf98f625a"

//border color and Width, cornerRadius

#define BORDER_COLOR [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor
#define BORDER_WIDTH 0.80
#define CORNER_RADIUS 5.00

//End border color, Width, cornerRadius

//#define kAppVersion       @"1.3"
#define kAppVersion       @"1.5"
#define keyAppVersion     @"version"
#define key_TitleMessage  @"GrocerMax"
#define key_SubscriptionPopUp           @"key_SubscriptionPopUp"

#define key_SubscriptionPopUp_Cancel     @"key_SubscriptionPopUp_Cancel"
#define key_SubscriptionPopUp_Ok        @"key_SubscriptionPopUp_Ok"
#define key_SubscriptionPopUp_Message   @"key_SubscriptionPopUp_Message"
#define key_SubscriptionPopUp_ExpTime   @"key_SubscriptionPopUp_ExpTime"
#define key_SubscriptionPopUp_ShowTime  @"key_SubscriptionPopUp_ShowTime"
#define key_IsSubscriptionPopUpShow     @"IsSubscriptionPopUpShow"

#define PayU_Cridentail   @"yPnUG6:test"

#define PayU_Key   @"yPnUG6"
#define PayU_Salt   @"jJ0mWFKl"
#define PayU_Product_Info @"GrocerMax Product Info"

// fonts

#define FONT_REGULAR(s) [UIFont fontWithName:@"HelveticaNeue" size:s]
#define FONT_BOLD(s)    [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define FONT_LIGHT(s)   [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
#define FONT_MEDIUM(s)   [UIFont fontWithName:@"HelveticaNeue-Medium" size:s]

#define FONT_LATO_REGULAR(s) [UIFont fontWithName:@"Lato-Regular" size:s]
#define FONT_LATO_BOLD(s)    [UIFont fontWithName:@"Lato-Bold" size:s]
#define FONT_LATO_LIGHT(s)   [UIFont fontWithName:@"Lato-Light" size:s]


//Force update or update
#define KEY_APPLICATION_INTERNAL_NOTIFICATION @"notification"
#define KEY_APPLICATION_INTERNAL_NOTIFICATION_POPUP @"popup"

#define KEY_APPLICATION_UPDATE @"upgrade-app"
#define KEY_APPLICATION_UPDATE_NOTE  @"UPDATE_NOTE"
#define APPLICATION_UPDATE_HARDCOADED_NOTE  @"New version of app is available in App Store.To use this feature please download the latest version of app."

#define APPLICATION_UPDATE_LATER  @"applicationUpdateLater"
#define APPLICATION_UPDATE_IGNORE @"applicationUpdateIgnore"
#define APPLICATION_UPDATE_LATER_VALUE @"applicationUpdateLaterValue"

#define APPLICATION_ENTER_IN_BACKGROUND_TIME @"APPLICATIONENTERINBACKGROUNDTIME"
#define APPLICATION_SESSION_EXPIRE_TIME @"APPLICATIONSESSIONEXPIRETIME"

#define PAYMENT_CANCEL_ALERT_MESSAGE  @"Do you want to cancel this payment?"

//Notification key
#define Keyaps @"aps"
#define Keyalert @"alert"
#define KeyapnsType @"apnsType"
#define Cancel_Text @"Cancel"

#define   KEY_Banner_Home @"home"
#define   KEY_Banner_search @"search"
#define   KEY_Banner_offerbydealtype @"offerbydealtype"
#define   KEY_Banner_dealsbydealtype @"dealsbydealtype"
#define   KEY_Banner_productlistall @"productlistall"
#define   KEY_Banner_dealproductlisting @"dealproductlisting"
#define   KEY_Banner_shopbydealtype @"shopbydealtype"


#define   KEY_Notification_Id @"notificationid"
#define   KEY_ProductListSortByIndex @"ProductListSortByIndex"



#define   KEY_Notification_Home @"home"
#define   KEY_Notification_search @"search"
#define   KEY_Notification_offerbydealtype @"offerbydealtype"
#define   KEY_Notification_dealsbydealtype @"dealsbydealtype"
#define   KEY_Notification_productlistall @"productlistall"
#define   KEY_Notification_dealproductlisting @"dealproductlisting"
#define   KEY_Notification_shopbydealtype @"shopbydealtype"
#define   KEY_Notification_LogOut @"logout"
#define   KEY_Notification_Profile @"profile"
#define   KEY_Notification_ViewCart @"viewcart"
#define   KEY_Notification_Productdetail @"productdetail"
#define   KEY_Notification_Specialdeal @"specialdeal"
#define   KEY_Notification_Singlepage @"singlepage"

#define   KEY_Notification_Upgrade @"upgrade"//only for internal notification



#define   payment_success_notifications_ByCitrus @"payment_success_notifications_ByCitrus"
#define   payment_failure_notifications_ByCitrus @"payment_failure_notifications_ByCitrus"

//Resoponce Key
#define kEY_Result                        @"Result"
#define kEY_flag                          @"flag"

// Key : Login

#define kEY_uemail                        @"uemail"
#define kEY_password                      @"password"
#define kEY_email                         @"email"
#define kEY_oldPassword                   @"old_password"



//key : Registration

#define kEY_fname                          @"fname"
#define kEY_lname                          @"lname"
#define kEY_number                         @"number"
#define kEY_otp                            @"otp"

// Key : fbRegister

#define kEY_QuoteId                         @"QuoteId"
#define kEY_Result                          @"Result"
#define kEY_TotalItem                       @"TotalItem"
#define kEY_UserID                          @"UserID"
#define kEY_flag                            @"flag"
#define kEY_Mobile                          @"Mobile"




//key : userdetail

#define kEY_userid                         @"userid"
#define kEY_user_id                         @"user_id"

//key : changepassword

#define kEY_old_password                   @"old_password"

//key : addaddress

#define kEY_addressid                      @"addressid"
#define kEY_addressline1                   @"addressline1"
#define kEY_addressline2                   @"addressline2"
#define kEY_addressline3                   @"addressline3"
#define kEY_city                           @"city"
#define kEY_state                          @"state"
#define kEY_pin                            @"pin"
#define kEY_postcode                       @"postcode"

#define kEY_state                          @"state"
#define kEY_countrycode                    @"countrycode"
#define kEY_phone                          @"phone"
#define kEY_phone                          @"phone"
#define kEY_telephone                      @"telephone"
#define kEY_region                         @"region"
#define kEY_regionId                       @"region_id"

#define kEY_default_billing                @"default_billing"
#define kEY_default_shipping               @"default_shipping"
#define kEY_cityId                         @"cityid"

#define kEY_notification_token            @"notification_token"

//key : category

#define kEY_parentid                       @"parentid"
#define kEY_cat_id                         @"cat_id"
#define kEY_pro_id                         @"pro_id"
#define kEY_page                           @"page"

#define kEY_sku                            @"sku"

//key : search

#define kEY_keyword                        @"keyword"

//key : getorderdetail

#define kEY_orderid                        @"orderid"

//key : addtocart

#define kEY_cus_id                         @"cus_id"
#define kEY_quote_id                       @"quote_id"
#define kEY_products                       @"products"

//key : deleteitem

#define kEY_productid                      @"productid"
#define kEY_updateid                       @"updateid"
#define kEY_products                       @"products"

//key : setstatus

#define kEY_orderid                        @"orderid"
#define kEY_status                         @"status"
#define kEY_comment                        @"comment"

//key : checkout

#define kEY_shipping                       @"shipping"
#define kEY_billing                        @"billing"
#define kEY_lot                            @"lot"
#define kEY_payment_method                 @"payment_method"
#define kEY_shipping_method                @"shipping_method"
#define kEY_timeslot                       @"timeslot"
#define kEY_date                           @"date"
#define kEY_payment_method_ByWallet        @"payment_method_Wallet"
#define kEY_IS_PaymentFrom_Wallet          @"wallet"
#define kEY_IS_InterNalWallet_Amount       @"internalWalletAmount"
#define kEY_IS_Total_paid_Amount           @"totalAmount"

//key : addcoupon

#define kEY_couponcode                     @"couponcode"
#define kEY_products                       @"products"
#define kEY_quantity                       @"quantity"

// Key : Deals

#define kEY_deal_type_id                  @"deal_type_id"
#define kEY_deal_id                       @"deal_id"

// Key : Categoriew

#define kEY_category_id                    @"category_id"
#define kEY_category                       @"category"
#define kEY_offercount                     @"offercount"
#define kEY_images                         @"images"


#define kEY_device                           @"device"
#define kEY_iOS                              @"ios"

// Key : PayU

#define kEY_PayU_Amount                   @"amount"
#define kEY_PayU_Surl                     @"surl"
#define kEY_PayU_Furl                     @"furl"
#define kEY_PayU_User_Credentials         @"user_credentials"
#define kEY_PayU_Key                      @"key"
#define kEY_PayU_Txnid                    @"txnid"
#define kEY_PayU_Fname                    @"fname"
#define kEY_PayU_Email                    @"email"
#define kEY_PayU_Phone                    @"phone"
#define kEY_PayU_Productinfo              @"productinfo"

#define PayU_Surl @"https://payu.herokuapp.com/ios_success"
#define PayU_Furl @"https://payu.herokuapp.com/ios_failure"







//Start Google Analytic screenName and event name
#define kEY_GA_Splash_Screen                 @"SplashScreen"
#define kEY_GA_City_Screen                   @"CityScreen"
#define kEY_GA_Home_Screen                   @"HomeScreen"



#define kEY_GA_LogIn_Screen                  @"LogInScreen"
#define kEY_GA_Register_Screen               @"RegisterScreen"
#define kEY_GA_ForgotPassword_Screen         @"ForgotPasswordScreen"
#define kEY_GA_OTP_Screen                    @"OTPScreen"
#define kEY_GA_Profile_Screen                @"ProfileScreen"
#define kEY_GA_ForgotPassword_Screen         @"ForgotPasswordScreen"
#define kEY_GA_Wallet_Screen                 @"WalletScreen"
#define kEY_GA_WalletHistory_Screen          @"WalletHistoryScreen"

#define kEY_GA_OrderHistory_Screen           @"OrderHistoryListScreen"
#define kEY_GA_OrderDetail_Screen            @"OrderDetailScreen"
#define kEY_GA_Shipping_Screen               @"ShippingAddressScreen"
#define kEY_GA_AddShipping_Screen            @"AddShippingAddressScreen"
#define kEY_GA_EditProfile_Screen            @"EditProfileScreen"
#define kEY_GA_InviteFriend_Screen           @"InviteFriendScreen"
#define kEY_GA_ChangePassword_Screen         @"ChangePasswordScreen"

#define kEY_GA_Search_Screen                 @"SearchScreen"

#define kEY_GA_SubCategory_Screen            @"SubCategoryScreen"

#define kEY_GA_ProducList_Screen             @"ProductListScreen"
#define kEY_GA_ProducDetail_Screen           @"ProductDetailScreen"
#define kEY_GA_ProducList_Screen             @"ProductListScreen"

#define kEY_GA_HotDeal_Screen                @"HotDealScreen"
#define kEY_GA_DealList_Screen               @"DealListScreen"
#define kEY_GA_DealDetail_Screen             @"DealDetailScreen"


#define kEY_GA_Cart_Screen                   @"CartScreen"
#define kEY_GA_CartShipping_Screen           @"CartShippingScreen"
#define kEY_GA_CartBilling_Screen            @"CartBillingScreen"
#define kEY_GA_AddBilling_Screen             @"AddBillingScreen"
#define kEY_GA_CartDeliveryDetail_Screen     @"CartDeliveryDetailScreen"
#define kEY_GA_CartPaymentMethod_Screen      @"CartPaymentMethodScreen"
#define kEY_GA_CartPaymentSucess_Screen      @"CartPaymentSucessScreen"
#define kEY_GA_CartPaymentFail_Screen      @"CartPaymentFailScreen"

#define kEY_GA_HamburgerMain_Screen          @"HambergerMainScreen"
#define kEY_GA_HamburgerSubcategory_Screen   @"HambergerSubcategoryScreen"

#define kEY_GA_ProvideMobileInfo_Screen      @"ProvideMobileInfoScreen"

#define kEY_GA_Offer_Screen                  @"OfferScreen"
#define kEY_GA_OfferList_Screen              @"OfferListScreen"
#define kEY_GA_MyAddress_Screen              @"MyAddressScreen"

//End Screen

//Start Event

#define kEY_GA_Event_CitySelection           @"Track the button for city selection"
#define kEY_GA_Event_SaveCity                @"Save selected City"

#define kEY_GA_Event_BannerScroller          @"Banner scroll"
#define kEY_GA_Event_BannerSelection         @"Banner Selection"

#define kEY_GA_Event_OpenDrawer              @"open Drawer"
#define kEY_GA_Event_CloseDrawer             @"Close Drawer"
#define kEY_GA_Event_DrawerScroller          @"Drawer Scroll"
#define kEY_GA_Event_DrawerOptionSelect      @"Drawer Options Selected"


#define kEY_GA_Event_TabHome                 @"Bottom Home Button Pressed"
#define kEY_GA_Event_TabProfile              @"Bottom Profile Button Pressed"
#define kEY_GA_Event_TabDeal                 @"Bottom Deal Button Pressed"
#define kEY_GA_Event_TabSearch               @"Bottom Search Button Pressed"
#define kEY_GA_Event_TabCart                 @"Bottom Cart Button Pressed"

#define kEY_GA_Event_CategoryScroller        @"Category Scroll"
#define kEY_GA_Event_CategorySelection       @"Category Selection"
#define kEY_GA_Event_OfferCategorySelection  @"Offer In Category Selection"

#define kEY_GA_Event_DealScroller            @"Deal Scroll"
#define kEY_GA_Event_DealSelection           @"Deal Selection"

#define kEY_GA_Event_SubCategoryScroller     @"Deal Scroll"

#define kEY_GA_Event_SubcategoryScroller     @"Subcategory Scroll"
#define kEY_GA_Event_SubCategorySelection    @"Category Selection"
#define kEY_GA_Event_SubCategoryNext         @"next level of subcategory"


//Rahul code

#define kEY_GA_Event_CategoryOpend         @"Category opened"
#define kEY_GA_Event_CategoryScroller      @"Category Scroll"
#define kEY_GA_Event_CategorySelection     @"Category Selection"
#define kEY_GA_Event_AddCartitems          @"Item added in cart"

#define kEY_GA_Event_DealScroller          @"Deal Scroll"
#define kEY_GA_Event_ProductHavingOffer    @"Product having Offers"

#define kEY_GA_Event_DealCategoryOpened    @"Deal category opened"

#define kEY_GA_Event_ScrollingThroughBroCat @"Scrolling through browse categories"
#define kEY_GA_Event_SelectionOfDealCat     @"Selection of deal category"

#define kEY_GA_Event_ProductListingThroughOffers            @"Productlistng through Offers"
#define kEY_GA_Event_ProductListingThroughSubCategories     @"Productlistng through Subcategories"
#define kEY_GA_Event_ProductListingThroughHomeBanner     @"Productlistng through HomeBanner"

#define kEY_GA_Event_ProductListScrolling                   @"Product list scrolling"

#define kEY_GA_Event_OffersThroughOffersDealsCategory       @"Offers through  Deal Category"
#define kEY_GA_Event_OffersThroughDealCategory              @"Offers through Deal Type Listing"

#define kEY_GA_Event_OffersListScrolling     @"Offers list scrolling"

// end Rahul


#define kEY_GA_Event_OpenSearch              @"Opening of the search option"
#define kEY_GA_Event_SearchQuery             @"Tracking of the Search query"
#define kEY_GA_Event_SearchAddToCart         @"Add to cart event from the search result"

#define kEY_GA_Event_FacebookLogin           @"Login By Facebook"
#define kEY_GA_Event_GoogleLogin             @"Login By Google"
#define kEY_GA_Event_EmailLogin              @"Login By Email"

#define kEY_GA_Event_FacebookRegister        @"Register By Facebook"
#define kEY_GA_Event_GoogleRegister          @"Register By Google"
#define kEY_GA_Event_EmailRegister           @"Register By Email"

#define kEY_GA_Event_CartScroller            @"Scrolling behavior"
#define kEY_GA_Event_CartUpdate              @"Cart Update behavior"
#define kEY_GA_Event_CartPlaceOrder          @"Place order button pressed"

#define kEY_GA_Event_ExistingShippingSelect  @"Existing Shipping Address Selected"
#define kEY_GA_Event_NewShippingSelect       @"New Shipping Address Selected"
#define kEY_GA_Event_ProceedShippingBilling  @"Proceed to billing address selection button selection"
#define kEY_GA_Event_ProceedShipping         @"Proceed to billing address button selection"


#define kEY_GA_Event_ExistingBillingSelect   @"Existing Billing Address Selected"
#define kEY_GA_Event_NewBillingSelect        @"New Billing Address Selected"
#define kEY_GA_Event_ProceedBilling          @"Proceed to delivery details button selection"

#define kEY_GA_Event_DateSelect              @"Date selection"
#define kEY_GA_Event_SlotSelect              @"Slot selection"
#define kEY_GA_Event_ProceedPaymentMethod    @"Proceed to payment method button selection"

#define kEY_GA_Event_PaymentModeSelect       @"Payment mode selected"
#define kEY_GA_Event_Wallet                  @"Wallet"
#define kEY_GA_Event_CashOnDelivery          @"Cash on delivery"
#define kEY_GA_Event_PayU                    @"PayU"
#define kEY_GA_Event_PayTM                   @"PayTM"
#define kEY_GA_Event_Citrus                  @"Citrus Wallet"
#define kEY_GA_Event_CodeApplied             @"Code applied"
#define kEY_GA_Event_PlaceOrder              @"Place Order button selected"

#define kEY_GA_Event_OrderSuccess            @"Order success screen displayed"





//New Event And Category


#define kEY_GA_Category_Category_Interaction                   @"IOS Category Interaction"
#define kEY_GA_Category_Add_To_Cart                            @"IOS Add to Cart"
#define kEY_GA_Category_View_Cart                              @"IOS View Cart"
#define kEY_GA_Category_Proceed_To_Checkout                    @"IOS Proceed to checkout"
#define kEY_GA_Category_Checkout_Funnel                        @"IOS Checkout Funnel"


#define kEY_GA_EventAction_Search_Result                       @"search result"
#define kEY_GA_EventAction_Category_Page                       @"category page"
#define kEY_GA_EventAction_Deal_Page                           @"deal page"
#define kEY_GA_EventAction_Save_More                           @"save more"
#define kEY_GA_EventAction_Product_NameORID                    @"product name/id"
#define kEY_GA_EventAction_Login                               @"Login"
#define kEY_GA_EventAction_Billing                             @"Billing"
#define kEY_GA_EventAction_Shipping                            @"Shipping"
#define kEY_GA_EventAction_Delivery_Slot                       @"Delivery Slot"
#define kEY_GA_EventAction_Payment_Method                      @"Payment Method"


#define kEY_GA_EventLabel_Keyword                              @"keyword"
#define kEY_GA_EventLabel_Category_Name                        @"category name"
#define kEY_GA_EventLabel_Deal_Label                           @"deal label"
#define kEY_GA_EventLabel_Save_Big_Label                       @"save big label"
#define kEY_GA_EventLabel_Product_NameORid                     @"product name/id"
#define kEY_GA_EventLabel_Product_Qty                          @"product qty"
#define kEY_GA_EventLabel_New_Registration                     @"New Registration"
#define kEY_GA_EventLabel_Existing_User                        @"Existing User"
#define kEY_GA_EventLabel_EmailORid                            @"Email/id"


//New Event And Category



//End Event

//QAGRAP Events


#define kEY_QA_EventLabel_Search                               @"iOS Category Interaction - Search"
#define kEY_QA_EventLabel_Category                             @"iOS Category Interaction - Category Page"
#define kEY_QA_EventLabel_Deal                                 @"iOS Category Interaction - Deal Page"
#define kEY_QA_EventLabel_Banner                               @"iOS Category Interaction - Banner"


#define kEY_QA_EventLabel_AddCart_Search                       @"iOS Add to Cart - Search Result"
#define kEY_QA_EventLabel_AddCart_Category                     @"iOS Add to Cart - Category Page"
#define kEY_QA_EventLabel_AddCart_Deal                         @"iOS Add to Cart - Deal Page"
#define kEY_QA_EventLabel_AddCart_Banner                       @"iOS Add to Cart - Banner "
#define kEY_QA_EventLabel_ViewCart                             @"iOS View Cart"

#define kEY_QA_EventLabel_UpdateCart                           @"iOS Update Cart"

#define kEY_QA_EventLabel_ProceedCheckOut                      @"iOS Proceed to checkout"

#define kEY_QA_EventLabel_CheckOutSignUp                       @"iOS Checkout Funnel - Sign up"

#define kEY_QA_EventLabel_CheckOutSignIn                       @"iOS Checkout Funnel - Sign in"

#define kEY_QA_EventLabel_CheckOutShipping                     @"iOS Checkout Funnel - Shipping"

#define kEY_QA_EventLabel_CheckOutDelivery                     @"iOS Checkout Funnel - Delivery Slot"

#define kEY_QA_EventLabel_CheckOutPlaceOrder                   @"iOS Checkout Funnel - Place Order"

#define kEY_QA_EventLabel_CheckOutOrderSuccessFul              @"iOS Checkout Funnel - Order Successful"

#define kEY_QA_EventLabel_CheckOutOrderFailure                 @"iOS Checkout Funnel - Order Failure"

#define kEY_QA_EventLabel_HomeFlaship_Click                    @"iOS Banner Click - Home - Flagship"

#define kEY_QA_EventLabel_HomeBanner_Click                     @"iOS Banner Click - Home - Banner"

#define kEY_QA_EventLabel_CategoryBanner_Click                 @"iOS Banner Click - Category - Banner"

#define kEY_QA_EventLabel_Profile_ViewOrderHistory             @"iOS Profile Activity - View Order History"

#define kEY_QA_EventLabel_Profile_Reorder                      @"iOS Profile Activity - ReOrder"

#define kEY_QA_EventLabel_Profile_ViewMaxCoins                 @"iOS Profile Activity - View Max Coins"

#define kEY_QA_EventLabel_Profile_ViewRefundBalance            @"iOS Profile Activity - View Refund Balance"

#define kEY_QA_EventLabel_Profile_ViewAddresses                @"iOS Profile Activity - View Addresses"

#define kEY_QA_EventLabel_Profile_Share                        @"iOS Profile Activity - Share"



//QAGRAPH Paremeters

#define kEY_QA_EventParmeter_Keyword                           @"Keyword"
#define kEY_QA_EventParmeter_CategoryName                      @"Category name"
#define kEY_QA_EventParmeter_Deallabel                         @"Deal label"
#define kEY_QA_EventParmeter_BannerName                        @"Banner Name"
#define kEY_QA_EventParmeter_UserID                            @"User Id"
#define kEY_QA_EventParmeter_ProductName                       @"Product name"
#define kEY_QA_EventParmeter_ProductCode                       @"Product Code"
#define kEY_QA_EventParmeter_ProductQty                        @"Product Qty"
#define kEY_QA_EventParmeter_ProductSp                         @"Product SP"
#define kEY_QA_EventParmeter_CartId                            @"Cart id"
#define kEY_QA_EventParmeter_TotalQty                          @"Total Qty"
#define kEY_QA_EventParmeter_Subtotal                          @"Subtotal"
#define kEY_QA_EventParmeter_CouponCode                        @"Coupon Code"
#define kEY_QA_EventParmeter_CategoryIds                       @"Category id"
#define kEY_QA_EventParmeter_ProductIds                        @"Product id"

#define kEY_QA_EventParmeter_EmailId                           @"Email id"
#define kEY_QA_EventParmeter_PhoneNumber                       @"Phone Number"
#define kEY_QA_EventParmeter_DeliverySlot                      @"Delivery Slot"
#define kEY_QA_EventParmeter_PaymentOption                     @"Payment Option"
#define kEY_QA_EventParmeter_PaymentOption                     @"Payment Option"


//QAGRAPH Paremeters End



//QAGRAPH Event End

//[rocqAnalytics identity:userModal.firstName properties:@{@"email":userModal.email,@"fname":userModal.firstName,@"userId":userModal.userId}];
#define kEY_RocqAnalytics_User_FirstName            @"fname"
#define kEY_RocqAnalytics_User_Id                   @"userId"
#define kEY_RocqAnalytics_User_Email                @"email"
// End Google Analytic screenName and event name
