//
//  GMAddressModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMAddressModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSArray *addressArray;

@property (nonatomic, readonly, strong) NSArray *billingAddressArray;

@property (nonatomic, readonly, strong) NSArray *shippingAddressArray;
@end


@interface GMAddressModalData : MTLModel <MTLJSONSerializing>

@property(strong, nonatomic) NSString *customer_address_id;

@property(strong, nonatomic) NSString *created_at;

@property(strong, nonatomic) NSString *update_at;

@property(strong, nonatomic) NSString *city;

@property(strong, nonatomic) NSString *contryId;

@property(strong, nonatomic) NSString *firstName;

@property(strong, nonatomic) NSString *lastName;

@property(strong, nonatomic) NSString *latitude;

@property(strong, nonatomic) NSString *logidutude;

@property(strong, nonatomic) NSString *pincode;

@property(strong, nonatomic) NSString *region;

@property(strong, nonatomic) NSString *region_id;

@property(strong, nonatomic) NSString *street;

@property(strong, nonatomic) NSString *telephone;

@property(strong, nonatomic) NSString *userType;

@property(nonatomic) NSNumber *is_default_billing;

@property(nonatomic) NSNumber *is_default_shipping;

@property (nonatomic, strong) NSString *houseNo;

@property (nonatomic, strong) NSString *locality;

@property (nonatomic, strong) NSString *closestLandmark;

@property(nonatomic) BOOL isShippingSelected;

@property(nonatomic) BOOL isBillingSelected;

- (instancetype)initWithUserModal:(GMUserModal *)userModal;

- (void)updateHouseNoLocalityAndLandmarkWithStreet:(NSString *)street;
@end
