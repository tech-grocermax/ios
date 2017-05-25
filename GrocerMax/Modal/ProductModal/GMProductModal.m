//
//  GMProductModal.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductModal.h"

static NSString * const kCurrencyCodeKey                        = @"currencycode";
static NSString * const kProductImageKey                        = @"Image";
static NSString * const kNameKey                                = @"Name";
static NSString * const kPriceKey                               = @"Price";
static NSString * const kProductionKey                          = @"productid";
static NSString * const kPromotionLevelKey                      = @"promotion_level";
static NSString * const kP_BrandKey                             = @"p_brand";
static NSString * const kP_NameKey                              = @"p_name";
static NSString * const kP_PackKey                              = @"p_pack";
static NSString * const kSalePriceKey                           = @"sale_price";
static NSString * const kStatusKey                              = @"Status";
static NSString * const kProductQuantityKey                     = @"productQuantity";
static NSString * const kProductAddedQuantityKey                = @"productAddedQuantity";

static NSString * const kProductProduct_countKey                     = @"product_count";
static NSString * const kProductDeal_type_idKey                     = @"deal_type_id";
static NSString * const kProductPromo_idKey                     = @"promo_id";
static NSString * const kProductRankKey                     = @"rank";


@implementation GMProductListingBaseModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"productsListArray"  : @"Product",
             @"totalcount"         : @"Totalcount",
             @"flag"               : @"flag"
             };
}

+ (NSValueTransformer *)productsListArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMProductModal class]];
}

#pragma mark -

- (instancetype)initWithResponseDict:(NSDictionary *)responseDict {
    
    if(self = [super init]) {
        
        if(HAS_KEY(responseDict, @"hotproduct")) {
            
            NSMutableArray *productItemsArr = [NSMutableArray array];
            NSArray *items = responseDict[@"hotproduct"];
            
            for (NSDictionary *productDict in items) {
                GMCategoryModal *productModal = [[GMCategoryModal alloc] initWithProductListDictionary:productDict];
                [productItemsArr addObject:productModal];
            }
            _hotProductListArray = productItemsArr;
        }
        
        if(HAS_KEY(responseDict, @"ProductList")) {
            
            NSMutableArray *productItemsArr = [NSMutableArray array];
            NSArray *items = responseDict[@"ProductList"];
            
            for (NSDictionary *productDict in items) {
                GMCategoryModal *productModal = [[GMCategoryModal alloc] initWithProductListDictionary:productDict];
                [productItemsArr addObject:productModal];
            }
            _productsListArray = productItemsArr;
        }else if(HAS_KEY(responseDict, @"Product")) {
            
            NSDictionary *product = responseDict[@"Product"];
//            if(product.count>0) {
            if(HAS_KEY(product, @"items")) {
            
                
                NSMutableArray *productItemsArr = [NSMutableArray array];
                NSArray *items = product[@"items"];
                
                for (NSDictionary *productDict in items) {
                    
                     NSError *mtlError = nil;
                    
                    GMProductModal *productModal = [MTLJSONAdapter modelOfClass:[GMProductModal class] fromJSONDictionary:productDict error:&mtlError];
                    [productItemsArr addObject:productModal];
                }
                _productsListArray = productItemsArr;
            }
//            }
            _totalcount = _productsListArray.count;
        }else if(HAS_KEY(responseDict, @"category")) {
            
            NSMutableArray *productItemsArr = [NSMutableArray array];
            NSArray *items = responseDict[@"category"];
            
            for (NSDictionary *productDict in items) {
                GMCategoryModal *productModal = [[GMCategoryModal alloc] initWithProductListDictionary:productDict];
                [productItemsArr addObject:productModal];
            }
            _productsListArray = productItemsArr;
        }
        
        if(HAS_DATA(responseDict, @"Totalcount"))
            _totalcount = [responseDict[@"Totalcount"] integerValue];
        
        if(HAS_DATA(responseDict, @"flag"))
            _flag = [responseDict[@"flag"] boolValue];
        
    }
    
    return self;
}


@end

@implementation GMProductModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"currencycode"       : @"currencycode",
             @"image"              : @"Image",
             @"name"               : @"Name",
             @"Price"              : @"Price",
             @"productid"          : @"productid",
             @"promotion_level"    : @"promotion_level",
             @"p_brand"            : @"p_brand",
             @"p_name"             : @"p_name",
             @"p_pack"             : @"p_pack",
             @"sale_price"         : @"sale_price",
             @"Status"             : @"Status",
             @"noOfItemInStock"    : @"webqty",
             @"categoryIdArray"    : @"categoryid",
             @"product_count"      : @"product_count",
             @"deal_type_id"       : @"deal_type_id",
             @"promo_id"           : @"promo_id",
             @"rank"               : @"rank",
             @"row_total"               : @"row_total"
             };
}

//+ (NSValueTransformer *)categoryidArrayJSONTransformer {
//    
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[NSString class]];
//}

- (instancetype)initWithProductItemDict:(NSDictionary *)productDict {
    
    if(self = [super init]) {
        
        if(HAS_DATA(productDict, @"p_brand"))
            _p_brand = productDict[@"p_brand"];
        
        if(HAS_DATA(productDict, @"p_name"))
            _p_name = productDict[@"p_name"];
        
        if(HAS_DATA(productDict, @"p_pack"))
            _p_pack = productDict[@"p_pack"];
        
        if(HAS_DATA(productDict, @"mrp"))
            _Price = productDict[@"mrp"];
        
        if(HAS_DATA(productDict, @"product_thumbnail"))
            _image = productDict[@"product_thumbnail"];
        
        if(HAS_DATA(productDict, @"name"))
            _name = productDict[@"name"];
        
        if(HAS_DATA(productDict, @"product_id"))
            _productid = productDict[@"product_id"];
        
        if(HAS_DATA(productDict, @"sku"))
            _sku = productDict[@"sku"];
        
        if(HAS_DATA(productDict, @"promotion_level"))
            _promotion_level = productDict[@"promotion_level"];
        
        if(HAS_DATA(productDict, @"no_discount"))
            _noDiscount = productDict[@"no_discount"];
        
        if(HAS_DATA(productDict, @"price"))
            _sale_price = productDict[@"price"];
        
        if(HAS_KEY(productDict, @"qty"))
            _productQuantity = [NSString stringWithFormat:@"%@", productDict[@"qty"]];
        if(HAS_KEY(productDict, @"webqty"))
            _noOfItemInStock = [NSString stringWithFormat:@"%@", productDict[@"webqty"]];
        
        if(HAS_DATA(productDict, @"Status"))
            _Status = productDict[@"Status"];
        
        if(HAS_DATA(productDict, @"product_count"))
            _product_count = [productDict[@"product_count"] integerValue];
        
        if(HAS_DATA(productDict, @"deal_type_id"))
            _deal_type_id= productDict[@"deal_type_id"];
        
        if(HAS_DATA(productDict, @"promo_id"))
            _deal_type_id= productDict[@"promo_id"];
        if(HAS_DATA(productDict, @"rank"))
            _rank= productDict[@"rank"];
        if(HAS_DATA(productDict, @"row_total"))
            _row_total= productDict[@"row_total"];
        
        
    }
    return self;
}

- (instancetype)initWithProductModal:(GMProductModal *)productModal {
    
    if(self = [super init]) {
        
        _p_brand = productModal.p_brand;
        _p_pack = productModal.p_pack;
        _Price = productModal.Price;
        _image = productModal.image;
        _name = productModal.name;
        _productid = productModal.productid;
        _sku = productModal.sku;
        _promotion_level = productModal.promotion_level;
        _noDiscount = productModal.noDiscount;
        _sale_price = productModal.sale_price;
        _productQuantity = productModal.productQuantity;
        _product_count = productModal.product_count;
        _deal_type_id = productModal.deal_type_id;
        _promo_id = productModal.promo_id;
        _rank = productModal.rank;
        _addedQuantity = productModal.addedQuantity;
    }
    return self;
}

#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.currencycode forKey:kCurrencyCodeKey];
    [aCoder encodeObject:self.image forKey:kProductImageKey];
    [aCoder encodeObject:self.name forKey:kNameKey];
    [aCoder encodeObject:self.Price forKey:kPriceKey];
    [aCoder encodeObject:self.productid forKey:kProductionKey];
    [aCoder encodeObject:self.promotion_level forKey:kPromotionLevelKey];
    [aCoder encodeObject:self.p_brand forKey:kP_BrandKey];
    [aCoder encodeObject:self.p_name forKey:kP_NameKey];
    [aCoder encodeObject:self.p_pack forKey:kP_PackKey];
    [aCoder encodeObject:self.sale_price forKey:kSalePriceKey];
    [aCoder encodeObject:self.Status forKey:kStatusKey];
    [aCoder encodeObject:self.productQuantity forKey:kProductQuantityKey];
    [aCoder encodeObject:self.addedQuantity forKey:kProductAddedQuantityKey];
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%ld",(long)_product_count] forKey:kProductProduct_countKey];
    
    [aCoder encodeObject:_deal_type_id forKey:kProductDeal_type_idKey];
    
    [aCoder encodeObject:_promo_id forKey:kProductPromo_idKey];
    [aCoder encodeObject:_rank forKey:kProductRankKey];
    
    
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.currencycode = [aDecoder decodeObjectForKey:kCurrencyCodeKey];
        self.image = [aDecoder decodeObjectForKey:kProductImageKey];
        self.name = [aDecoder decodeObjectForKey:kNameKey];
        self.Price = [aDecoder decodeObjectForKey:kPriceKey];
        self.productid = [aDecoder decodeObjectForKey:kProductionKey];
        self.promotion_level = [aDecoder decodeObjectForKey:kPromotionLevelKey];
        self.p_brand = [aDecoder decodeObjectForKey:kP_BrandKey];
        self.p_name = [aDecoder decodeObjectForKey:kP_NameKey];
        self.p_pack = [aDecoder decodeObjectForKey:kP_PackKey];
        self.sale_price = [aDecoder decodeObjectForKey:kSalePriceKey];
        self.Status = [aDecoder decodeObjectForKey:kStatusKey];
        self.productQuantity = [aDecoder decodeObjectForKey:kProductQuantityKey];
        self.addedQuantity = [aDecoder decodeObjectForKey:kProductAddedQuantityKey];
        
        self.product_count = [[aDecoder decodeObjectForKey:kProductProduct_countKey] integerValue];
        self.deal_type_id = [aDecoder decodeObjectForKey:kProductDeal_type_idKey];
        self.promo_id = [aDecoder decodeObjectForKey:kProductPromo_idKey];
        
        self.rank = [aDecoder decodeObjectForKey:kProductRankKey];
        
        
        
    }
    return self;
}


@end
