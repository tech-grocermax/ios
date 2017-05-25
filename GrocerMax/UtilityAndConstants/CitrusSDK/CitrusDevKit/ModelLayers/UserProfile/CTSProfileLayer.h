//
//  CTSProfileLayer.h
//  RestFulltester
//
//  Created by Yadnesh Wankhede on 04/06/14.
//  Copyright (c) 2014 Citrus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTSContactUpdate.h"
#import "CTSProfileContactRes.h"
#import "CTSProfilePaymentRes.h"
#import "CTSPaymentDetailUpdate.h"
#import "CTSRestCoreResponse.h"
#import "CTSRestPluginBase.h"
#import "CTSProfileLayerConstants.h"
#import "CTSCashoutBankAccountResp.h"
#import "CTSCashoutBankAccount.h"
#import "CTSNewContactProfile.h"
#import "CTSUpdateMobileNumberRes.h"
#import "CTSDPResponse.h"
#import "CTSDPMerchantQueryReq.h"

@class CTSProfileLayer;
@protocol CTSProfileProtocol
/**
 *  called when client requests for contact information
 *
 *  @param contactInfo nil in case of error
 *  @param error       nil when successful
 */
@optional
- (void)profile:(CTSProfileLayer*)profile
    didReceiveContactInfo:(CTSProfileContactRes*)contactInfo
                    error:(NSError*)error;
/**
 *  called when client requests for payment information
 *
 *  @param contactInfo nil in case of error
 *  @param error       nil when succesful
 */
@optional
- (void)profile:(CTSProfileLayer*)profile
    didReceivePaymentInformation:(CTSProfilePaymentRes*)contactInfo
                           error:(NSError*)error;
/**
 *  when contact information is updated to server
 *
 *  @param error error if happned
 */
@optional
- (void)profile:(CTSProfileLayer*)profile
    didUpdateContactInfoError:(NSError*)error;

/**
 *  when payment information is updated on server
 *
 *  @param error nil when successful
 */
@optional
- (void)profile:(CTSProfileLayer*)profile
    didUpdatePaymentInfoError:(NSError*)error;

@optional
- (void)profile:(CTSProfileLayer*)profile
  didGetBalance:(CTSAmount *)amount
               error:(NSError*)error;


@optional
- (void)profile:(CTSProfileLayer*)profile
  didAddCashoutAccount:(NSError*)error;


@optional
- (void)profile:(CTSProfileLayer*)profile
didReceiveCashoutAccount:(CTSCashoutBankAccountResp *)cashoutAccount  error:(NSError*)error;


@optional
- (void)profile:(CTSProfileLayer*)profile didGetNewProfile:(CTSNewContactProfile *)profile
          error:(NSError*)error;


@optional
- (void)profile:(CTSProfileLayer*)profile
didDeleteCardWithError:(NSError*)error;


@end


/**
 *  user profile related services
 */
@interface CTSProfileLayer : CTSRestPluginBase {
}
@property(weak) id<CTSProfileProtocol> delegate;
- (instancetype)initWithKeyStore:(CTSKeyStore *)keystoreArg;
typedef void (^ASGetContactInfoCallBack)(CTSProfileContactRes* contactInfo,
                                         NSError* error);

typedef void (^ASGetPaymentInfoCallBack)(CTSProfilePaymentRes* paymentInfo,
                                         NSError* error);

typedef void (^ASUpdatePaymentInfoCallBack)(NSError* error);

typedef void (^ASUpdateContactInfoCallBack)(NSError* error);

typedef void (^ASGetBalanceCallBack)(CTSAmount *amount, NSError* error);

typedef void (^ASActivatePrepaidCallBack)(BOOL isActivated, NSError* error);

typedef void (^ASUpdateCashoutBankAccountCallback)( NSError* error);

typedef void (^ASGetCashoutBankAccountCallback)(CTSCashoutBankAccountResp *bankAccount, NSError* error);

typedef void (^ASNewContactProfileCallback)(CTSNewContactProfile* profile, NSError*error);

typedef void (^ASUpdateMobileNumberCallback)(CTSUpdateMobileNumberRes *updateMobileNumber, NSError* error);

typedef void (^ASDeleteCardCallback)(NSError* error);

typedef void (^ASDPMerchantQueryCallback)(CTSDPResponse*reponse, NSError* error);



//-(instancetype)init __attribute__((unavailable("init not available Please use [CitrusPaymentSDK fetchSharedProfileLayer]")));

+(CTSProfileLayer*)fetchSharedProfileLayer;

/**
 *  update contact related information
 *
 *  @param contactInfo actual information to be updated
 */
- (void)updateContactInformation:(CTSContactUpdate*)contactInfo
           withCompletionHandler:(ASUpdateContactInfoCallBack)callback;



/**
 *  update payment related information
 *
 *  @param paymentInfo payment information
 */
- (void)updatePaymentInformation:(CTSPaymentDetailUpdate*)paymentInfo
           withCompletionHandler:(ASUpdatePaymentInfoCallBack)callback;

/**
 *  to request contact related information
 */
- (void)requestContactInformationWithCompletionHandler:
        (ASGetContactInfoCallBack)callback;

/**
 *  request user's payment information
 */
- (void)requestPaymentInformationWithCompletionHandler:
        (ASGetPaymentInfoCallBack)callback;


-(void)requestGetBalance:(ASGetBalanceCallBack)calback;

-(void)requestActivateAndGetBalance:(ASGetBalanceCallBack)calback;

-(void)requestActivatePrepaidAccount:(ASActivatePrepaidCallBack)callback;

- (void)requestUpdateCashoutBankAccount:(CTSCashoutBankAccount*)bankAccount
           withCompletionHandler:(ASUpdateCashoutBankAccountCallback)callback;

-(void)requestCashoutBankAccountCompletionHandler:(ASGetCashoutBankAccountCallback)callback;

-(void)requestMemberInfoMobile:(NSString *)mobile email:(NSString *)email withCompletionHandler:(ASNewContactProfileCallback)callback;

/**
 @brief            update mobile number.
 @param mobile     Set update mobile number.
 @param callback   Set success/failure callBack.
 @details          Use this method For update new mobile number.
 */
- (void)requestUpdateMobile:(NSString *)mobileNumber WithCompletionHandler:(ASUpdateMobileNumberCallback)callback;


/**
 @brief            delete Saved Card.
 @param lastFourDigits     Last four digits of the saved card.
 @param scheme   correct scheme of the card.
 @details          Use this method For delete saved cards.
 */
-(void)requestDeleteCard:(NSString *)lastFourDigits scheme:(NSString *)scheme withCompletionHandler:(ASDeleteCardCallback)callback;

-(void)requestDeleteCardWithToken:(NSString *)token withCompletionHandler:(ASDeleteCardCallback)callback;

-(void)requestDpMerchantQuery:(CTSDPMerchantQueryReq *)request completionHandler:(ASDPMerchantQueryCallback)callback;


@end
