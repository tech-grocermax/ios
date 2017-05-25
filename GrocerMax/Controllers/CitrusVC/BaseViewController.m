//
//  BaseViewController.m
//  CubeDemo
//
//  Created by Vikas Singh on 8/25/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import "BaseViewController.h"
#import "TestParams.h"
#import "MerchantConstants.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeLayers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initializers

// Initialize the SDK layer viz CTSAuthLayer/CTSProfileLayer/CTSPaymentLayer
-(void)initializeLayers{
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    CTSKeyStore *keyStore = [[CTSKeyStore alloc] init];
    keyStore.signinId = SignInId;
    keyStore.signinSecret = SignInSecretKey;
    keyStore.signUpId = SubscriptionId;
    keyStore.signUpSecret = SubscriptionSecretKey;
    keyStore.vanity = VanityUrl;
    
//      [CitrusPaymentSDK initializeWithKeyStore:keyStore environment:CTSEnvProduction];
      [CitrusPaymentSDK initializeWithKeyStore:keyStore environment:CTSEnvProduction];

    
    
    authLayer = [CTSAuthLayer fetchSharedAuthLayer];
    proifleLayer = [CTSProfileLayer fetchSharedProfileLayer];
    paymentLayer = [CTSPaymentLayer fetchSharedPaymentLayer];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    contactInfo = [[CTSContactUpdate alloc] init];
    if(NSSTRING_HAS_DATA(userModal.firstName)) {
        contactInfo.firstName = userModal.firstName;
    } else {
//        contactInfo.firstName = TEST_FIRST_NAME;
    }
    
    if(NSSTRING_HAS_DATA(userModal.lastName)) {
        contactInfo.lastName = userModal.lastName;
    } else {
//        contactInfo.lastName = TEST_LAST_NAME;
    }
    
    if(NSSTRING_HAS_DATA(userModal.email)) {
        contactInfo.email = userModal.email;
    } else {
//                contactInfo.email = TEST_EMAIL;
    }
    
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        contactInfo.mobile = userModal.mobile;
    } else {
//        contactInfo.mobile = TEST_MOBILE;
    }
    
    
    addressInfo = [[CTSUserAddress alloc] init];
    addressInfo.city = TEST_CITY;
    addressInfo.country = TEST_COUNTRY;
    addressInfo.state = TEST_STATE;
    addressInfo.street1 = TEST_STREET1;
    addressInfo.street2 = TEST_STREET2;
    addressInfo.zip = TEST_ZIP;
    
    customParams = @{
                     @"USERDATA2":@"MOB_RC|9988776655",
                     @"USERDATA10":@"test",
                     @"USERDATA4":@"MOB_RC|test@gmail.com",
                     @"USERDATA3":@"MOB_RC|4111XXXXXXXX1111",
                     };
}

-(void)initializeLayers:(GMAddressModalData*)addressModalData{
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    CTSKeyStore *keyStore = [[CTSKeyStore alloc] init];
    keyStore.signinId = SignInId;
    keyStore.signinSecret = SignInSecretKey;
    keyStore.signUpId = SubscriptionId;
    keyStore.signUpSecret = SubscriptionSecretKey;
    keyStore.vanity = VanityUrl;
    
    //      [CitrusPaymentSDK initializeWithKeyStore:keyStore environment:CTSEnvProduction];
    [CitrusPaymentSDK initializeWithKeyStore:keyStore environment:CTSEnvSandbox];
    
    
    
    authLayer = [CTSAuthLayer fetchSharedAuthLayer];
    proifleLayer = [CTSProfileLayer fetchSharedProfileLayer];
    paymentLayer = [CTSPaymentLayer fetchSharedPaymentLayer];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    contactInfo = [[CTSContactUpdate alloc] init];
    if(NSSTRING_HAS_DATA(userModal.firstName)) {
        contactInfo.firstName = userModal.firstName;
    } else {
        //        contactInfo.firstName = TEST_FIRST_NAME;
    }
    
    if(NSSTRING_HAS_DATA(userModal.lastName)) {
        contactInfo.lastName = userModal.lastName;
    } else {
        //        contactInfo.lastName = TEST_LAST_NAME;
    }
    
    if(NSSTRING_HAS_DATA(userModal.email)) {
        contactInfo.email = userModal.email;
    } else {
        //                contactInfo.email = TEST_EMAIL;
    }
    
    if(NSSTRING_HAS_DATA(userModal.mobile)) {
        contactInfo.mobile = userModal.mobile;
    } else {
        //        contactInfo.mobile = TEST_MOBILE;
    }
    
    
    addressInfo = [[CTSUserAddress alloc] init];
    
    
    if(NSSTRING_HAS_DATA(addressModalData.city)) {
        addressInfo.city = addressModalData.city;
    } else {
//        addressInfo.city = TEST_CITY;
    }
    
    if(NSSTRING_HAS_DATA(addressModalData.contryId)) {
        addressInfo.country = addressModalData.contryId;
    } else {
//        addressInfo.country = TEST_COUNTRY;
    }
    
    if(NSSTRING_HAS_DATA(addressModalData.region)) {
        addressInfo.state = addressModalData.region;
    } else {
//        addressInfo.state = TEST_STATE;
    }
    
    if(NSSTRING_HAS_DATA(addressModalData.street)) {
        addressInfo.street1 = addressModalData.street;
        addressInfo.street2 = addressModalData.street;
    } else {
//        addressInfo.street1 = TEST_STREET1;
//        addressInfo.street2 = TEST_STREET2;
    }
    
    if(NSSTRING_HAS_DATA(addressModalData.pincode)) {
        addressInfo.zip = addressModalData.pincode;
    } else {
//        addressInfo.zip = TEST_ZIP;
    }
    
    
    
    customParams = @{
                     @"USERDATA2":@"MOB_RC|9988776655",
                     @"USERDATA10":@"test",
                     @"USERDATA4":@"MOB_RC|test@gmail.com",
                     @"USERDATA3":@"MOB_RC|4111XXXXXXXX1111",
                     };
}

@end
