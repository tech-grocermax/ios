//
//  GMSearchResultModal.h
//  GrocerMax
//
//  Created by Rahul Chaudhary on 27/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMSearchResultModal : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray *productsListArray;
@property (strong, nonatomic) NSArray *categorysListArray;
@property (assign, nonatomic) NSInteger totalcount;

@end