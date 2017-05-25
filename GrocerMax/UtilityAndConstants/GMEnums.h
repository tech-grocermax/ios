//
//  GMEnums.h
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#ifndef GrocerMax_GMEnums_h
#define GrocerMax_GMEnums_h

typedef NS_ENUM(NSInteger, GMGenderType) {
    GMGenderTypeMale,
    GMGenderTypeFemale
};


typedef NS_ENUM(NSInteger, GMRootPageViewControllerType) {
    GMRootPageViewControllerTypeProductlisting,
    GMRootPageViewControllerTypeProductlistingCategory,
    GMRootPageViewControllerTypeOffersByDealTypeListing,
    GMRootPageViewControllerTypeDealCategoryTypeListing
};

typedef NS_ENUM(NSInteger, GMProductListingFromType) {
    GMProductListingFromTypeCategory,
    GMProductListingFromTypeOffer_OR_Deal
};

//This enum used only for GA traking;
typedef NS_ENUM(NSInteger, GMProductListingFromTypeForGA) {
    GMProductListingFromTypeCategoryGA,
    GMProductListingFromTypeSearchGA,
    GMProductListingFromTypeDealGA,
    GMProductListingFromTypeSaveMoreGA
};

typedef NS_ENUM(NSInteger, GMProductSortType) {
    GMProductListingSortTypePopularity = 0,
    GMProductListingSortTypeDiscounts,
    GMProductListingSortTypeTitle_A_to_Z,
    GMProductListingSortTypeTitle_Z_to_A,
    GMProductListingSortTypePrice_Low_To_High,
    GMProductListingSortTypePrice_High_To_Low
};



#endif
