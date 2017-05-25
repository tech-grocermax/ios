//
//  GMSearchKeyWordSavedModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 05/05/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMSearchKeyWordSavedModal : NSObject

@property (nonatomic, strong) NSMutableArray *savedTrendingModalArray;


- (instancetype)initWithSavedTrendingModalArray:(NSMutableArray *)savedTrendingModalArray;

+ (instancetype)loadSavedTrendingModal;

- (void)archiveavedTrendingModal;

@end
