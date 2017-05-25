//
//  GMRootPageAPIController.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GMRootPageAPIController;

@protocol GMRootPageAPIControllerDelegate <NSObject>

-(void)rootPageAPIControllerDidFinishTask:(GMRootPageAPIController*)controller;

@end

@interface GMRootPageAPIController : NSObject

@property (strong, nonatomic) NSMutableDictionary *modalDic;
@property (weak, nonatomic) id<GMRootPageAPIControllerDelegate> delegate;


#pragma mark - for Productlisting

- (void)fetchProductListingDataForCategory:(NSString*)catID;

- (void)fetchDealProductListingDataForOffersORDeals:(NSString*)dealID;

@end
