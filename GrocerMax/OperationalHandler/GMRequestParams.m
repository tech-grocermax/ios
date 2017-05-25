//
//  GMRequestParams.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 10/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRequestParams.h"
#import "GMAddressModal.h"
#import "GMCartModal.h"
#import "GMProductModal.h"
#import "GMStateBaseModal.h"



@implementation GMRequestParams

static GMRequestParams *sharedClass;

+ (instancetype)sharedClass {
    
    if(!sharedClass) {
        sharedClass  = [[[self class] alloc] init];
    }
    return sharedClass;
}

#pragma mark -Create Customer

+ (NSMutableDictionary *)getUserFBLoginRequestParamsWith:(NSDictionary*)parameterDic{
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [paramDict setObject:parameterDic[kEY_uemail] forKey:kEY_uemail];
    [paramDict setObject:parameterDic[kEY_quote_id] forKey:kEY_quote_id];
    [paramDict setObject:parameterDic[kEY_fname] forKey:kEY_fname];
    //[paramDict setObject:parameterDic[kEY_lname] forKey:kEY_lname];
    [paramDict setObject:parameterDic[kEY_number] forKey:kEY_number];
    
    return paramDict;
}

- (NSMutableDictionary *)getUserLoginRequestParamsWith:(NSString *)userName password:(NSString *)password{
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [paramDict setObject:userName forKey:kEY_uemail];
    [paramDict setObject:password forKey:kEY_password];
    [paramDict setObject:[self getValidStringObjectFromString:userModal.quoteId] forKey:kEY_quote_id];
    return paramDict;
}


+ (NSString *)userLoginParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_uemail])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_uemail, [parameterDic objectForKey:kEY_uemail]];
        }
        
        if([parameterDic objectForKey:kEY_password])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_password,[parameterDic objectForKey:kEY_password]];
        }
        return parameter;
    }
    
}

+ (NSString *)createUserParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_uemail])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_uemail, [parameterDic objectForKey:kEY_uemail]];
        }
        
        if([parameterDic objectForKey:kEY_password])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_password,[parameterDic objectForKey:kEY_password]];
        }
        
        if([parameterDic objectForKey:kEY_fname])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_fname,[parameterDic objectForKey:kEY_fname]];
        }
        
        if([parameterDic objectForKey:kEY_lname])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_lname,[parameterDic objectForKey:kEY_lname]];
        }
        
        if([parameterDic objectForKey:kEY_number])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_number,[parameterDic objectForKey:kEY_number]];
        }
        if([parameterDic objectForKey:kEY_otp])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_otp,[parameterDic objectForKey:kEY_otp]];
        }
        return parameter;
    }
    
}

+ (NSString *)userDetailParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        
        return parameter;
    }
    
}

+ (NSString *)logoutParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        
        return parameter;
    }
    
}

+ (NSString *)forgotPasswordParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_uemail])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_uemail, [parameterDic objectForKey:kEY_uemail]];
        }
        
        return parameter;
    }
    
}

+ (NSString *)changePasswordParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        if([parameterDic objectForKey:kEY_password])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_password, [parameterDic objectForKey:kEY_password]];
        }
        if([parameterDic objectForKey:kEY_old_password])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_old_password, [parameterDic objectForKey:kEY_old_password]];
        }
        
        return parameter;
    }
    
}

+ (NSString *)editProfileParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        if([parameterDic objectForKey:kEY_uemail])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_uemail, [parameterDic objectForKey:kEY_uemail]];
        }
        if([parameterDic objectForKey:kEY_password])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_password, [parameterDic objectForKey:kEY_password]];
        }
        if([parameterDic objectForKey:kEY_old_password])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_old_password, [parameterDic objectForKey:kEY_old_password]];
        }
        if([parameterDic objectForKey:kEY_fname])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_fname, [parameterDic objectForKey:kEY_fname]];
        }
        if([parameterDic objectForKey:kEY_lname])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_lname, [parameterDic objectForKey:kEY_lname]];
        }
        if([parameterDic objectForKey:kEY_number])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_number, [parameterDic objectForKey:kEY_number]];
        }
        
        return parameter;
    }
    
}

+ (NSString *)addAndEditAddressParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        if([parameterDic objectForKey:kEY_addressid])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_addressid, [parameterDic objectForKey:kEY_addressid]];
        }
        if([parameterDic objectForKey:kEY_fname])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_fname, [parameterDic objectForKey:kEY_fname]];
        }
        if([parameterDic objectForKey:kEY_lname])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_lname, [parameterDic objectForKey:kEY_lname]];
        }
        if([parameterDic objectForKey:kEY_addressline1])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_addressline1, [parameterDic objectForKey:kEY_addressline1]];
        }
        if([parameterDic objectForKey:kEY_addressline2])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_addressline2, [parameterDic objectForKey:kEY_addressline2]];
        }
        if([parameterDic objectForKey:kEY_city])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_city, [parameterDic objectForKey:kEY_city]];
        }
        if([parameterDic objectForKey:kEY_state])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_state, [parameterDic objectForKey:kEY_state]];
        }
        if([parameterDic objectForKey:kEY_pin])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_pin, [parameterDic objectForKey:kEY_pin]];
        }
        if([parameterDic objectForKey:kEY_countrycode])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_countrycode, [parameterDic objectForKey:kEY_countrycode]];
        }
        if([parameterDic objectForKey:kEY_phone])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_phone, [parameterDic objectForKey:kEY_phone]];
        }
        if([parameterDic objectForKey:kEY_default_billing])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_default_billing, [parameterDic objectForKey:kEY_default_billing]];
        }
        if([parameterDic objectForKey:kEY_default_shipping])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_default_shipping, [parameterDic objectForKey:kEY_default_shipping]];
        }
        
        return parameter;
    }
    
}

+ (NSString *)getAddressParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        return parameter;
    }
    
}

+ (NSString *)deleteAddressParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_addressid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_addressid, [parameterDic objectForKey:kEY_addressid]];
        }
        return parameter;
    }
    
}

+ (NSString *)getAddressWithTimeSlotParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        return parameter;
    }
    
}

+ (NSString *)categoryParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_parentid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_parentid, [parameterDic objectForKey:kEY_parentid]];
        }
        return parameter;
    }
    
}

+ (NSString *)productListParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_cat_id])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_cat_id, [parameterDic objectForKey:kEY_cat_id]];
        }
        if([parameterDic objectForKey:kEY_pro_id])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_cat_id, [parameterDic objectForKey:kEY_pro_id]];
        }
        if([parameterDic objectForKey:kEY_page])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_page, [parameterDic objectForKey:kEY_page]];
        }
        return parameter;
    }
    
}

+ (NSString *)productDetailParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_pro_id])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_pro_id, [parameterDic objectForKey:kEY_pro_id]];
        }
        return parameter;
    }
    
}

+ (NSString *)searchParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_keyword])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_keyword, [parameterDic objectForKey:kEY_keyword]];
        }
        if([parameterDic objectForKey:kEY_page])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_page, [parameterDic objectForKey:kEY_page]];
        }
        return parameter;
    }
    
}

+ (NSString *)activeOrderOrOrderHistryParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_email])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_email, [parameterDic objectForKey:kEY_email]];
        }
        return parameter;
    }
    
}

+ (NSString *)getOrderDetailParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_orderid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_orderid, [parameterDic objectForKey:kEY_orderid]];
        }
        return parameter;
    }
    
}

+ (NSString *)addToCartParameter:(NSDictionary *)parameterDic {
    
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_cus_id])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_cus_id, [parameterDic objectForKey:kEY_cus_id]];
        }
        if([parameterDic objectForKey:kEY_quote_id])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_quote_id, [parameterDic objectForKey:kEY_quote_id]];
        }
        if([parameterDic objectForKey:kEY_products])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_products, [parameterDic objectForKey:kEY_products]];
        }
        return parameter;
    }
    
}

+ (NSString *)cartDetailParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        if([parameterDic objectForKey:kEY_quote_id])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_quote_id, [parameterDic objectForKey:kEY_quote_id]];
        }
        if([parameterDic objectForKey:kEY_products])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_products, [parameterDic objectForKey:kEY_products]];
        }
        return parameter;
    }
    
}

+ (NSString *)deleteItemParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        if([parameterDic objectForKey:kEY_productid])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_productid, [parameterDic objectForKey:kEY_productid]];
        }
        if([parameterDic objectForKey:kEY_updateid])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_updateid, [parameterDic objectForKey:kEY_updateid]];
        }
        if([parameterDic objectForKey:kEY_productid])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_productid, [parameterDic objectForKey:kEY_productid]];
        }
        return parameter;
    }
    
}

+ (NSString *)setStatusParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_orderid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_orderid, [parameterDic objectForKey:kEY_orderid]];
        }
        if([parameterDic objectForKey:kEY_status])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_status, [parameterDic objectForKey:kEY_status]];
        }
        if([parameterDic objectForKey:kEY_comment])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_comment, [parameterDic objectForKey:kEY_comment]];
        }
        return parameter;
    }
    
}

+ (NSString *)checkoutParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        if([parameterDic objectForKey:kEY_shipping])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_shipping, [parameterDic objectForKey:kEY_shipping]];
        }
        if([parameterDic objectForKey:kEY_billing])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_billing, [parameterDic objectForKey:kEY_billing]];
        }
        if([parameterDic objectForKey:kEY_quote_id])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_quote_id, [parameterDic objectForKey:kEY_quote_id]];
        }
        if([parameterDic objectForKey:kEY_date])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_date, [parameterDic objectForKey:kEY_date]];
        }
        if([parameterDic objectForKey:kEY_payment_method])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_payment_method, [parameterDic objectForKey:kEY_payment_method]];
        }
        if([parameterDic objectForKey:kEY_shipping_method])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_shipping_method, [parameterDic objectForKey:kEY_shipping_method]];
        }
        if([parameterDic objectForKey:kEY_timeslot])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_timeslot, [parameterDic objectForKey:kEY_timeslot]];
        }
        return parameter;
    }
    
}

+ (NSString *)addOrRemoveCouponParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_userid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_userid, [parameterDic objectForKey:kEY_userid]];
        }
        if([parameterDic objectForKey:kEY_quote_id])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_quote_id, [parameterDic objectForKey:kEY_quote_id]];
        }
        if([parameterDic objectForKey:kEY_couponcode])
        {
            parameter = [NSString stringWithFormat:@"%@&%@=%@",parameter,kEY_couponcode, [parameterDic objectForKey:kEY_couponcode]];
        }
        return parameter;
    }
    
}

+ (NSString *)paymentSuccessOrfailParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_orderid])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_orderid, [parameterDic objectForKey:kEY_orderid]];
        }
        return parameter;
    }
    
}

+ (NSString *)addToCartGustParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_products])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_products, [parameterDic objectForKey:kEY_products]];
        }
        return parameter;
    }
    
}

+ (NSString *)getLocationParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        //need to write code for location parameter;
        return parameter;
    }
    
}

- (NSDictionary *)getAddAddressParameterDictionaryFrom:(GMAddressModalData *)addressModal andIsNewAddres:(BOOL)isNewAddress {
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionary];
    if(!isNewAddress)
        [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.customer_address_id] forKey:kEY_addressid];
    if(NSSTRING_HAS_DATA(userModal.userId))
        [addressDictionary setObject:userModal.userId forKey:kEY_userid];
    [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.firstName] forKey:kEY_fname];
    [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.lastName] forKey:kEY_lname];
    [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.telephone] forKey:kEY_phone];
    [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.city] forKey:kEY_city];
    [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.region] forKey:kEY_state];
    [addressDictionary setObject:[self getValidStringObjectFromString:cityModal.stateId] forKey:kEY_regionId];
    [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.pincode] forKey:kEY_pin];
    [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.houseNo] forKey:kEY_addressline1];
    [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.locality] forKey:kEY_addressline2];
    [addressDictionary setObject:[self getValidStringObjectFromString:addressModal.closestLandmark] forKey:kEY_addressline3];
    [addressDictionary setObject:@"IN" forKey:kEY_countrycode];
    [addressDictionary setObject:addressModal.is_default_shipping forKey:kEY_default_shipping];
    [addressDictionary setObject:addressModal.is_default_billing forKey:kEY_default_billing];
    [addressDictionary setObject:[self getValidStringObjectFromString:cityModal.cityId] forKey:kEY_cityId];
        return addressDictionary;
}

+ (NSString *)shopbyCategoryParameter:(NSDictionary *)parameterDic{
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }else
    {
        return parameter;
    }
}

+ (NSString *)shopByDealTypeParameter:(NSDictionary *)parameterDic{
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_cat_id])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_cat_id, [parameterDic objectForKey:kEY_cat_id]];
        }
        return parameter;
    }
}

+ (NSString *)dealsByDealTypeParameter:(NSDictionary *)parameterDic {
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_deal_type_id])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_deal_type_id, [parameterDic objectForKey:kEY_deal_type_id]];
        }
        return parameter;
    }
}

+ (NSString *)dealProductListingParameter:(NSDictionary *)parameterDic{
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_deal_id])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_deal_id, [parameterDic objectForKey:kEY_deal_id]];
        }
        return parameter;
    }
}

+ (NSString *)offerByDealTypeParameter:(NSDictionary *)parameterDic{
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_cat_id])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_cat_id, [parameterDic objectForKey:kEY_cat_id]];
        }
        return parameter;
    }
}

+ (NSString *)productListAllParameter:(NSDictionary *)parameterDic{
    
    NSString *parameter = @"?";
    if(parameterDic == nil || parameterDic.count==0)
    {
        return @"";
    }
    else
    {
        if([parameterDic objectForKey:kEY_cat_id])
        {
            parameter = [NSString stringWithFormat:@"%@%@=%@",parameter,kEY_cat_id, [parameterDic objectForKey:kEY_cat_id]];
        }
        return parameter;
    }
}

#pragma mark - Helper Methods

- (NSString *)getValidStringObjectFromString:(NSString *)strInput {
    
    if(NSSTRING_HAS_DATA(strInput))
        return strInput;
    else
        return @"";
}

@end
