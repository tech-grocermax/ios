//
//  GMRootPageAPIController.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRootPageAPIController.h"
#import "GMProductModal.h"

@implementation GMRootPageAPIController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalDic = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - fetchProductListingDataForCategory

- (void)fetchProductListingDataForCategory:(NSString*)catID {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:catID forKey:kEY_cat_id];
    
    if ([self.modalDic objectForKey:catID]) {
        GMProductListingBaseModal *baseModal = [self.modalDic objectForKey:catID];
        
        if (baseModal.totalcount == baseModal.productsListArray.count) {
            
            return; // no more api hit
        }
        
        NSInteger pageNumber = (baseModal.productsListArray.count/10) + 1;
        [localDic setObject:@(pageNumber) forKey:kEY_page];
        
    }else{
        [localDic setObject:@"1" forKey:kEY_page];
    }
    
    [[GMOperationalHandler handler] productList:localDic withSuccessBlock:^(id responceData) {
        
        GMProductListingBaseModal *oldModal = [self.modalDic objectForKey:catID];
        
        GMProductListingBaseModal *newModal = responceData;
        if (oldModal.productsListArray.count != 0) {
            newModal.productsListArray = [oldModal.productsListArray arrayByAddingObjectsFromArray:newModal.productsListArray];
        }
        [self.modalDic setObject:newModal forKey:catID];
        
        if ([self.delegate respondsToSelector:@selector(rootPageAPIControllerDidFinishTask:)]) {
            [self.delegate rootPageAPIControllerDidFinishTask:self];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - fetchProductListingDataFor Offers OR Deals

- (void)fetchDealProductListingDataForOffersORDeals:(NSString*)dealID {
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:dealID forKey:kEY_deal_id];
    
    if ([self.modalDic objectForKey:dealID]) {
        GMProductListingBaseModal *baseModal = [self.modalDic objectForKey:dealID];
        
//        if (baseModal.totalcount == baseModal.productsListArray.count) {
//            
//            return; // no more api hit
//        }
        
        NSInteger pageNumber = (baseModal.productsListArray.count/10) + 1;
        [localDic setObject:@(pageNumber) forKey:kEY_page];
        
    }else{
        [localDic setObject:@"1" forKey:kEY_page];
    }
    
    [[GMOperationalHandler handler] dealProductListing:localDic withSuccessBlock:^(id responceData) {
        
        GMProductListingBaseModal *oldModal = [self.modalDic objectForKey:dealID];
        
        GMProductListingBaseModal *newModal = responceData;
        if (oldModal.productsListArray.count != 0) {
            newModal.productsListArray = [oldModal.productsListArray arrayByAddingObjectsFromArray:newModal.productsListArray];
        }
        [self.modalDic setObject:newModal forKey:dealID];
        
        if ([self.delegate respondsToSelector:@selector(rootPageAPIControllerDidFinishTask:)]) {
            [self.delegate rootPageAPIControllerDidFinishTask:self];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}


@end
