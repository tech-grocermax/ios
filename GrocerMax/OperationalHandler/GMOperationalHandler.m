//
//  GMOperationalHandler.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOperationalHandler.h"

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFHTTPRequestOperation.h>

#import "GMApiPathGenerator.h"
#import "GMCategoryModal.h"
#import "GMTimeSlotBaseModal.h"
#import "GMProductModal.h"

#import "GMAddressModal.h"

#import "GMRegistrationResponseModal.h"
#import "GMStateBaseModal.h"
#import "GMLocalityBaseModal.h"
#import "GMUserModal.h"
#import "GMBaseOrderHistoryModal.h"
#import "GMProductDetailModal.h"
#import "GMHotDealBaseModal.h"
#import "GMOffersByDealTypeModal.h"
#import "GMDealCategoryBaseModal.h"
#import "GMProductModal.h"
#import "GMOrderDeatilBaseModal.h"
#import "GMCartDetailModal.h"
#import "GMSearchResultModal.h"
#import "GMGenralModal.h"
#import "GMCoupanCartDetail.h"
#import "GMHomeBannerModal.h"
#import "GMHomeModal.h"
#import "GMWalletOrderModal.h"
#import "MGAppliactionUpdate.h"
#import "GMPaymentWayModal.h"
#import "GMInternalNotificationModal.h"
#import "MGInternalNotificationAlert.h"
#import "GMBannerModal.h"
#import "GMCouponModal.h"
#import "GMMaxCoinBaseModal.h"

static NSString * const kFlagKey                    = @"flag";
static NSString * const kCategoryKey                   = @"Category";
static NSString * const kQuoteId                    = @"QuoteId";
static NSString * const kResultKey                    = @"Result";


static GMOperationalHandler *sharedHandler;

@implementation GMOperationalHandler


#pragma mark - SharedInstance Method

+ (instancetype)handler {
    
    if(!sharedHandler) {
        sharedHandler  = [[[self class] alloc] init];
    }
    return sharedHandler;
}

- (AFHTTPRequestOperationManager *)operationManager {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"device"];
    [manager.requestSerializer setValue:kAppVersion forHTTPHeaderField:keyAppVersion];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if([defaults objectForKey:@"storeId"]) {
        [manager.requestSerializer setValue:[defaults objectForKey:@"storeId"] forHTTPHeaderField:@"storeid"];
    }
    
    NSString *iosUDID = [[GMSharedClass sharedClass] getUDID];
    if(NSSTRING_HAS_DATA(iosUDID)){
        [manager.requestSerializer setValue:iosUDID forHTTPHeaderField:@"ios_uuid"];
    }
    
    if([defaults objectForKey:kEY_notification_token]) {
        [manager.requestSerializer setValue:[defaults objectForKey:kEY_notification_token] forHTTPHeaderField:@"deviceToken"];
    }
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    if(userModal != nil && NSSTRING_HAS_DATA(userModal.userId)) {
        [manager.requestSerializer setValue:userModal.userId forHTTPHeaderField:kEY_userid];
    }
    if(userModal != nil && NSSTRING_HAS_DATA(userModal.email)) {
        [manager.requestSerializer setValue:userModal.email forHTTPHeaderField:kEY_email];
    }
    if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName)) {
        [manager.requestSerializer setValue:userModal.firstName forHTTPHeaderField:kEY_fname];
    }
    
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager.requestSerializer setTimeoutInterval:90];
    return manager;
}

- (NSError *)getSuccessResponse:(NSDictionary *)responseObject {
    
    if(responseObject == nil) {
        return nil;
    }
    
    NSString *flag = responseObject[kFlagKey];
    if(flag.boolValue)
        return nil;
    else
        return [NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : responseObject[kResultKey]}];
}

#pragma mark - Login

/**
 * Function for Check User Login
 * @param GET Var uemail, password
 * @output JSON string
 * mandatory variable  uemail, password
 */

//http://dev.grocermax.com/webservice/new_services/login?uemail=kundan@sakshay.in&password=sakshay

- (void)fgLoginRequestParamsWith:(NSDictionary *)param withSuccessBlock:(void(^)(id data))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator fbregisterPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:[GMRequestParams getUserFBLoginRequestParamsWith:param] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                NSError *error = [self getSuccessResponse:responseObject];
                if(!error) {
                    if([responseObject isKindOfClass:[NSDictionary class]]) {
                        
                        if(successBlock) successBlock(responseObject);
                    }
                } else {
                    if(failureBlock) failureBlock(error);
                }
                
                
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)login:(NSDictionary *)param withSuccessBlock:(void (^)(GMUserModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator userLoginPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *mtlError = nil;
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                
                GMUserModal *userModal = [MTLJSONAdapter modelOfClass:[GMUserModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(userModal); }
            }
            else
                if(failureBlock) failureBlock(error);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)fetchCategoriesFromServerWithSuccessBlock:(void (^)(GMCategoryModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator categoryPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *mtlError = nil;
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                NSString *baseUrl = responseObject[@"urlImg"];
                if(NSSTRING_HAS_DATA(baseUrl))
                    [[GMSharedClass sharedClass] setCategoryImageBaseUrl:baseUrl];
                
                NSDictionary *categoryDict = responseObject[kCategoryKey];
                GMCategoryModal *rootCategoryModal = [MTLJSONAdapter modelOfClass:[GMCategoryModal class] fromJSONDictionary:categoryDict error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(rootCategoryModal); }
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)userLogin:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator userLoginPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                if (responseObject) {
                    
                    if([responseObject isKindOfClass:[NSDictionary class]]) {
                        
                        if(successBlock) successBlock(responseObject);
                    }
                }else {
                    
                    if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
                }
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}


- (void)createUser:(NSDictionary *)param withSuccessBlock:(void (^)(GMRegistrationResponseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator createUserPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *mtlError = nil;
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                GMRegistrationResponseModal *registrationResponse = [MTLJSONAdapter modelOfClass:[GMRegistrationResponseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(registrationResponse); }
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}


- (void)userDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator userDetailPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                NSError *error = [self getSuccessResponse:responseObject];
                if(!error) {
                    if([responseObject isKindOfClass:[NSDictionary class]]) {
                        
                        if(successBlock) successBlock(responseObject);
                    }
                } else {
                    if(failureBlock) failureBlock(error);
                }
                
                
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}



- (void)logOut:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator logOutPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}

- (void)forgotPassword:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator forgotPasswordPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}


- (void)changePassword:(NSDictionary *)param withSuccessBlock:(void(^)(GMRegistrationResponseModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator changePasswordPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                NSError *mtlError = nil;
                
                GMRegistrationResponseModal *registrationResponse = [MTLJSONAdapter modelOfClass:[GMRegistrationResponseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(registrationResponse); }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}


- (void)editProfile:(NSDictionary *)param withSuccessBlock:(void(^)(GMRegistrationResponseModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator editProfilePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                NSError *mtlError = nil;
                
                GMRegistrationResponseModal *registrationResponse = [MTLJSONAdapter modelOfClass:[GMRegistrationResponseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(registrationResponse); }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}

#pragma mark - Add Address Api

- (void)addAddress:(NSDictionary *)param withSuccessBlock:(void (^)(BOOL))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    //    NSString *urlStr = [NSString stringWithFormat:@"%@%@", [GMApiPathGenerator addAddressPath],[GMRequestParams addAndEditAddressParameter:param]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator addAddressPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(HAS_KEY(responseObject, @"AddressId"))  {
                        if(successBlock) successBlock(YES);
                    }
                    else
                        if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : responseObject[kEY_Result]}]);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}

#pragma mark - Edit Address Api

- (void)editAddress:(NSDictionary *)param withSuccessBlock:(void (^)(BOOL))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator editAddressPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(YES);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}

- (void)getAddress:(NSDictionary *)param withSuccessBlock:(void(^)(GMAddressModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getAddressPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                NSError *mtlError = nil;
                
                GMAddressModal *addressModal = [MTLJSONAdapter modelOfClass:[GMAddressModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);}
                else            { if (successBlock) successBlock(addressModal);}
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)deleteAddress:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator deleteAddressPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)getAddressWithTimeSlot:(NSDictionary *)param withSuccessBlock:(void (^)(GMTimeSlotBaseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getAddressWithTimeSlotPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                NSError *mtlError = nil;
                
                GMTimeSlotBaseModal *timeSlotBaseModal = [MTLJSONAdapter modelOfClass:[GMTimeSlotBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                for (GMAddressModalData *addressModal in timeSlotBaseModal.addressesArray) {
                    [addressModal updateHouseNoLocalityAndLandmarkWithStreet:addressModal.street];
                }
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(timeSlotBaseModal); }
                
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
            responseObject = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)category:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator categoryPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)productList:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator productListPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    
                    NSError *mtlError = nil;
                    
                    GMProductListingBaseModal *productListingModal = [MTLJSONAdapter modelOfClass:[GMProductListingBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(productListingModal); }
                    
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)productDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator productDetailPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    
                    GMProductDetailBaseModal *productListingModal = [MTLJSONAdapter modelOfClass:[GMProductDetailBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(productListingModal); }
                    
                    
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)search:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator searchPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    
                    
                    GMSearchResultModal *productListingModal = [MTLJSONAdapter modelOfClass:[GMSearchResultModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(productListingModal); }
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)activeOrder:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator activeOrderPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)orderHistory:(NSDictionary *)param withSuccessBlock:(void(^)(NSArray *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator orderHistoryPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                NSError *error = [self getSuccessResponse:responseObject];
                if(!error) {
                    NSError *mtlError = nil;
                    GMBaseOrderHistoryModal *baseOrderHistoryModal = [MTLJSONAdapter modelOfClass:[GMBaseOrderHistoryModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(baseOrderHistoryModal.orderHistoryArray);}
                }
                else {
                    if(failureBlock) failureBlock(error);
                }
                //
                
                
                
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)getOrderDetail:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getOrderDetailPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    GMOrderDeatilBaseModal *orderDeatilBaseModal = [[GMOrderDeatilBaseModal alloc]initWithDictionary:responseObject];
                    
                    if(successBlock) successBlock(orderDeatilBaseModal);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)addToCart:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator addToCartPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)cartDetail:(NSDictionary *)param withSuccessBlock:(void (^)(GMCartDetailModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator cartDetailPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    GMCartDetailModal *cartDetailModal = [[GMCartDetailModal alloc] initWithCartDetailDictionary:responseObject[@"CartDetail"]];
                    if(HAS_DATA(responseObject, @"session_exp_time_checkout")){
                        [[GMSharedClass sharedClass] saveCartSessionExpireTime:[NSString stringWithFormat:@"%@",responseObject[@"session_exp_time_checkout"]]];
                    }
                    
                    if(successBlock) successBlock(cartDetailModal);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)deleteItem:(NSDictionary *)param withSuccessBlock:(void (^)(GMCartDetailModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator deleteItemPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    GMCartDetailModal *cartDetailModal = [[GMCartDetailModal alloc] initWithCartDetailDictionary:responseObject[@"CartDetail"]];
                    if(successBlock) successBlock(cartDetailModal);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)asetStatus:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator asetStatusPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)checkout:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator checkoutPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
        if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    GMGenralModal *genralModal = [MTLJSONAdapter modelOfClass:[GMGenralModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(genralModal); }
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)addCoupon:(NSDictionary *)param withSuccessBlock:(void(^)(GMCoupanCartDetail *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator addCouponPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(responseObject[@"flag"] && [responseObject[@"flag"] intValue] == 1) {
                        GMCoupanCartDetail *coupanCartDetail = [[GMCoupanCartDetail alloc] initWithCartDetailDictionary:responseObject];
                        if(successBlock) successBlock(coupanCartDetail);            } else {
                            if(failureBlock) failureBlock(nil);
                        }
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)removeCoupon:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator removeCouponPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                if (responseObject) {
                    if([responseObject isKindOfClass:[NSDictionary class]]) {
                        
                        if(successBlock) successBlock(responseObject);
                    }
                }else {
                    
                    if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
                }
            }else {
                if(failureBlock) failureBlock(error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)success:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal* responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator successPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    
                    GMGenralModal *genralModal = [MTLJSONAdapter modelOfClass:[GMGenralModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(genralModal); }
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)fail:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator failPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    
                    GMGenralModal *genralModal = [MTLJSONAdapter modelOfClass:[GMGenralModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(genralModal); }
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}

- (void)successForPayTM:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal* responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator successPathForPayTM]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    
                    GMGenralModal *genralModal = [MTLJSONAdapter modelOfClass:[GMGenralModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(genralModal); }
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)failForPayTM:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal *responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator failPathForPayTM]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    
                    GMGenralModal *genralModal = [MTLJSONAdapter modelOfClass:[GMGenralModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(genralModal); }
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)addTocartGust:(NSDictionary *)param withSuccessBlock:(void (^)(NSString *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator addTocartGustPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *quoteId;
                    if(HAS_KEY(responseObject, kQuoteId)) {
                        
                        quoteId = responseObject[kQuoteId];
                        GMUserModal *userModal = [GMUserModal loggedInUser];
                        if(quoteId && !userModal) {
                            
                            userModal = [[GMUserModal alloc] init];
                            [userModal setQuoteId:quoteId];
                            [userModal persistUser];
                        } else {
                            if(userModal && !NSSTRING_HAS_DATA(userModal.quoteId)) {
                                [userModal setQuoteId:quoteId];
                                [userModal persistUser];
                            }
                        }
                    }
                    if(successBlock) successBlock(quoteId);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)getLocation:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getLocationPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                NSError *mtlError = nil;
                
                GMStateBaseModal *stateBaseModal = [MTLJSONAdapter modelOfClass:[GMStateBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(stateBaseModal);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

#pragma mark - State Api

- (void)getStateWithSuccessBlock:(void (^)(GMStateBaseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator getStatePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *mtlError = nil;
            
            GMStateBaseModal *stateBaseModal = [MTLJSONAdapter modelOfClass:[GMStateBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(stateBaseModal); }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

#pragma mark - Locality Api

- (void)getLocalitiesOfCity:(NSString *)cityId withSuccessBlock:(void (^)(GMLocalityBaseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    //    http://dev.grocermax.com/webservice/new_services/getlocality?cityid=1
    NSString *urlStr = [NSString stringWithFormat:@"%@?cityid=%@", [GMApiPathGenerator getLocalityPath], cityId];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *mtlError = nil;
            
            GMLocalityBaseModal *localityBaseModal = [MTLJSONAdapter modelOfClass:[GMLocalityBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
            
            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
            else            { if (successBlock) successBlock(localityBaseModal); }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)shopbyCategory:(NSDictionary *)param withSuccessBlock:(void(^)(id catArray))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator shopbyCategoryPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if(successBlock) successBlock(responseObject[kEY_category]);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)shopByDealType:(NSDictionary *)param withSuccessBlock:(void (^)(GMHotDealBaseModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator shopByDealTypePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                NSError *mtlError = nil;
                
                GMHotDealBaseModal *hotDealBaseModal = [MTLJSONAdapter modelOfClass:[GMHotDealBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(hotDealBaseModal); }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)dealsByDealType:(NSDictionary *)param withSuccessBlock:(void (^)(id ))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator dealsbydealtypePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                NSError *mtlError = nil;
//
//                GMDealCategoryBaseModal *dealCategoryBaseModal = [MTLJSONAdapter modelOfClass:[GMDealCategoryBaseModal class] fromJSONDictionary:responseObject[@"dealcategory"] error:&mtlError];
//                
//                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
//                else            { if (successBlock) successBlock(dealCategoryBaseModal); }
                
                GMProductListingBaseModal *productListingBaseModal = [[GMProductListingBaseModal alloc] initWithResponseDict:[responseObject objectForKey:@"dealcategory"]];
                
                //                    if (successBlock) successBlock(productListingBaseModal);
                
                
                //                    GMOffersByDealTypeBaseModal *offersByDealTypeBaseModal = [MTLJSONAdapter modelOfClass:[GMOffersByDealTypeBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(productListingBaseModal); }
                
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)dealProductListing:(NSDictionary *)param withSuccessBlock:(void (^)(id data))successBlock failureBlock:(void (^)(NSError *))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator dealProductListingPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                NSError *mtlError = nil;
                
                GMProductListingBaseModal *productListBaseModal = [MTLJSONAdapter modelOfClass:[GMProductListingBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(productListBaseModal); }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)getOfferByDeal:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator offerByDealTypePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    
                    
                    GMProductListingBaseModal *productListingBaseModal = [[GMProductListingBaseModal alloc] initWithResponseDict:[responseObject objectForKey:@"dealcategory"]];
                    
//                    if (successBlock) successBlock(productListingBaseModal);
                    
                    
//                    GMOffersByDealTypeBaseModal *offersByDealTypeBaseModal = [MTLJSONAdapter modelOfClass:[GMOffersByDealTypeBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(productListingBaseModal); }
                    
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)productListAll:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator productListAllPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    GMProductListingBaseModal *productListingBaseModal = [[GMProductListingBaseModal alloc] initWithResponseDict:responseObject];
                    if (successBlock) successBlock(productListingBaseModal);
                    
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)homeBannerList:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator homeBannerPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    
                    GMHomeBannerBaseModal *bannerBaseModal = [MTLJSONAdapter modelOfClass:[GMHomeBannerBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(bannerBaseModal); }
                    
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)getMobileHash:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator hashGenreatePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                if([responseObject objectForKey:@"Result"]) {
                    if (successBlock) successBlock([responseObject objectForKey:@"Result"]);
                } else {
                    if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
                }
                
                
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


- (void)deviceToken:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator sendDeviceToken]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    if (successBlock) successBlock(responseObject);
                }
                    
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

- (void)fetchHomeScreenDataFromServerWithSuccessBlock:(void (^)(GMHomeModal *))successBlock failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator homePagePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *mtlError = nil;
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                
                GMHomeModal *homeModal = [MTLJSONAdapter modelOfClass:[GMHomeModal class] fromJSONDictionary:responseObject error:&mtlError];
                if(NSSTRING_HAS_DATA(homeModal.imageUrl))
                    [[GMSharedClass sharedClass] setCategoryImageBaseUrl:homeModal.imageUrl];
                
                if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                else            { if (successBlock) successBlock(homeModal); }
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


 -(void)reorderItem:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
     
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator reorderPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                
                 if (successBlock) successBlock(responseObject);
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


 -(void)getUserWalletItem:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator walletPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                 if (successBlock) successBlock(responseObject);
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

-(void)decreaseUserWalletBalence:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator decreasewWalletBalancePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                if (successBlock) successBlock(responseObject);
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


-(void)getUserWalletHistory:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator walletHistoryPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
    //        NSError *mtlError = nil;
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                
    //            GMWalletOrderModal *walletOrderModal = [MTLJSONAdapter modelOfClass:[GMWalletOrderModal class] fromJSONDictionary:responseObject error:&mtlError];
                
                GMWalletOrderModal *walletOrderModal = [[GMWalletOrderModal alloc]init];
                [walletOrderModal walletHistoryParseWithDic:responseObject];
                if (successBlock) successBlock(walletOrderModal.walletOrderHistoryArray);
                
    //            
    //            if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
    //            else            { if (successBlock) successBlock(walletOrderModal.walletOrderHistoryArray); }
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}

-(void)getpaymentWay:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator paymentWayPath]];
    AFHTTPRequestOperationManager *manager = [self operationManager];
    
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                
                
                if (successBlock) successBlock(responseObject);
                
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];

}


- (void)loadCitrus:(NSDictionary *)param withSuccessBlock:(void(^)(GMGenralModal* responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator loadCitrus]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSError *mtlError = nil;
                    
                    GMGenralModal *genralModal = [MTLJSONAdapter modelOfClass:[GMGenralModal class] fromJSONDictionary:responseObject error:&mtlError];
                    
                    if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                    else            { if (successBlock) successBlock(genralModal); }
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


- (void)termsAndConditionOrContact:(NSDictionary *)param isTermsAndCondition:(BOOL)isTermsAndCondition withSuccessBlock:(void(^)(NSString * responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator termandCondition]];
    if(isTermsAndCondition) {
        urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator termandCondition]];
    } else {
        urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator contact]];
    }
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    
                    NSString *terms = @"";
                    
                    if(HAS_DATA(responseObject,@"term")){
                        terms = [responseObject objectForKey:@"term"];
                    }
                    if (successBlock) successBlock(terms);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}


//qa.grocermax.com/api/subcategorybanner?cat_id=2621

- (void)subcategoryBanner:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator subcategorybannerPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSMutableArray *responceDataArray = [[NSMutableArray alloc]init];
                    if(HAS_KEY(responseObject, @"subcategorybanner")&& [[responseObject objectForKey:@"subcategorybanner"] isKindOfClass:[NSArray class]]){
                        
                        NSArray *responceArray = [responseObject objectForKey:@"subcategorybanner"];
                        
                        for(int i = 0; i<responceArray.count;i++){
                             GMBannerModal *bannerModal = [[GMBannerModal alloc]initWithBannerItemDict:[responceArray objectAtIndex:i]];
                            [responceDataArray addObject:bannerModal];
                        }
                        
                    }
                     if (successBlock) successBlock(responceDataArray);
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}

- (void)specialdeal:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator specialdealPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    GMProductListingBaseModal *productListingBaseModal = [[GMProductListingBaseModal alloc] initWithResponseDict:responseObject];
                    if(productListingBaseModal.productsListArray.count>0){
                    if (successBlock) successBlock(productListingBaseModal);
                    }else {
                        if(failureBlock) failureBlock(nil);
                        [[GMSharedClass sharedClass] showErrorMessage:@"No product fond"];
                    }
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}



- (void)couponcode:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator couponcodePath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            if (responseObject) {
                
                if([responseObject isKindOfClass:[NSDictionary class]]) {
                    
                    NSMutableArray *couponListArray = [responseObject objectForKey:@"coupon"];
                    NSMutableArray *couponModalArray = [[NSMutableArray alloc]init];
                    
                    for(int i = 0; i<couponListArray.count; i++){
                        GMCouponModal *couponModal = [[GMCouponModal alloc] initWithCouponListDictionary:[couponListArray objectAtIndex:i]];
                        if(NSSTRING_HAS_DATA(couponModal.couponCode)){
                            [couponModalArray addObject:couponModal];
                        }
                    }
                        if (successBlock) successBlock(couponModalArray);
                    
                }
            }else {
                
                if(failureBlock) failureBlock([NSError errorWithDomain:@"" code:-1002 userInfo:@{ NSLocalizedDescriptionKey : GMLocalizedString(@"some_error_occurred")}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
    
}

-(void)getMaxCoinsList:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator maxCoinsPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            //        NSError *mtlError = nil;
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
            
                    NSError *mtlError = nil;
                    NSError *error = [self getSuccessResponse:responseObject];
                    if(!error) {
                        
                        GMMaxCoinBaseModal *genralModal = [MTLJSONAdapter modelOfClass:[GMMaxCoinBaseModal class] fromJSONDictionary:responseObject error:&mtlError];
                        
                        if (mtlError)   { if (failureBlock) failureBlock(mtlError);   }
                        else            { if (successBlock) successBlock(genralModal); }
                    }
                    else
                        if(failureBlock) failureBlock(error);

            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


-(void)sendSubscribersData:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator subscribersPath]];
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager POST:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            //        NSError *mtlError = nil;
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                NSError *error = [self getSuccessResponse:responseObject];
                if(!error) {
                    
                     if (successBlock) successBlock(responseObject);
                }
                else
                    if(failureBlock) failureBlock(error);
                
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
    
}

-(void)getSinglepage:(NSDictionary *)param withSuccessBlock:(void(^)(id responceData))successBlock failureBlock:(void(^)(NSError * error))failureBlock
{
    NSString *urlStr = [NSString stringWithFormat:@"%@", [GMApiPathGenerator pagebannermsgPath]];
    
    
    AFHTTPRequestOperationManager *manager = [self operationManager];
    [manager GET:urlStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![self cheackHeaderData:operation]) {
            //        NSError *mtlError = nil;
            NSError *error = [self getSuccessResponse:responseObject];
            if(!error) {
                
                NSError *error = [self getSuccessResponse:responseObject];
                if(!error) {
                    
                    GMBannerModal *bannerModal = [[GMBannerModal alloc]initWithBannerItemDict:responseObject];
                    ;
                    if (successBlock) successBlock(bannerModal);
                }
                else
                    if(failureBlock) failureBlock(error);
                
            } else {
                if(failureBlock) failureBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failureBlock) failureBlock(error);
    }];
}


#pragma mark -

-(BOOL)cheackHeaderData:(AFHTTPRequestOperation *)operation
{
    NSHTTPURLResponse* resp = [operation response];
    
    if([resp.allHeaderFields objectForKey:KEY_APPLICATION_INTERNAL_NOTIFICATION] && [[resp.allHeaderFields objectForKey:KEY_APPLICATION_INTERNAL_NOTIFICATION] isKindOfClass:[NSString class]])
    {
        
        NSData *data = [[resp.allHeaderFields objectForKey:KEY_APPLICATION_INTERNAL_NOTIFICATION] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *localError = nil;
        NSMutableDictionary *responcedictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];

        if(responcedictionary.count>0) {
        
            GMInternalNotificationModal *internalNotificationModal = [[GMInternalNotificationModal alloc]initWithInternalNotificationItemDict:responcedictionary];
            NSString *messageId = @"";
            
            
            
            if(NSSTRING_HAS_DATA(internalNotificationModal.notificationId)){
                
                messageId = [NSString stringWithFormat:@"%@",internalNotificationModal.notificationId];
                
                if([[GMSharedClass sharedClass] checkInternalNotificationWithMessageId:messageId withFrequency:internalNotificationModal.frequency]){
                    
                    if([GMCityModal selectedLocation] != nil) {
                        NSDate *currentDate = [NSDate date];
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:currentDate forKey:messageId];
                        [MGInternalNotificationAlert showNotificationAlert:internalNotificationModal];
                        [defaults synchronize];
                    }
                    
                }
            }
        }
        
        
        
    }
    
    if([resp.allHeaderFields objectForKey:KEY_APPLICATION_UPDATE])
    {
        
        if([resp.allHeaderFields objectForKey:KEY_APPLICATION_UPDATE])
        {
            if([[resp.allHeaderFields objectForKey:KEY_APPLICATION_UPDATE] isEqualToString:@"1"])
            {
                [APP_DELEGATE HideProcessingView];
                [[GMSharedClass sharedClass] clearLaterUpdate];
                [MGAppliactionUpdate showUpdate:YES message:APPLICATION_UPDATE_HARDCOADED_NOTE];
                return YES;
            }
            else if([[resp.allHeaderFields objectForKey:KEY_APPLICATION_UPDATE] isEqualToString:@"2"])
            {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if([defaults objectForKey:APPLICATION_UPDATE_LATER_VALUE])
                {
                    if([[defaults objectForKey:APPLICATION_UPDATE_LATER_VALUE] integerValue]<[[resp.allHeaderFields objectForKey:KEY_APPLICATION_UPDATE] integerValue])
                    {
                        [[GMSharedClass sharedClass] clearLaterUpdate];
                        [defaults setObject:[NSString stringWithFormat:@"%@",[resp.allHeaderFields objectForKey:KEY_APPLICATION_UPDATE]] forKey:APPLICATION_UPDATE_LATER_VALUE];
                    }
                    else
                    {
                        if([[GMSharedClass sharedClass] checkConditionShowUpdate])
                        {
                            [MGAppliactionUpdate showUpdate:NO message:APPLICATION_UPDATE_HARDCOADED_NOTE];
                        }
                        return NO;
                    }
                }
                else
                {
                    [[GMSharedClass sharedClass] clearLaterUpdate];
                    [defaults setObject:[NSString stringWithFormat:@"%@",[resp.allHeaderFields objectForKey:KEY_APPLICATION_UPDATE]] forKey:APPLICATION_UPDATE_LATER_VALUE];
                }
                [defaults synchronize];
                
                
                if([[GMSharedClass sharedClass] checkConditionShowUpdate])
                {
                    [MGAppliactionUpdate showUpdate:NO message:APPLICATION_UPDATE_HARDCOADED_NOTE];
                }
                return NO;
            }
            else
            {
                [[GMSharedClass sharedClass] clearLaterUpdate];
            }
        }
    }
    return NO;
}

@end
