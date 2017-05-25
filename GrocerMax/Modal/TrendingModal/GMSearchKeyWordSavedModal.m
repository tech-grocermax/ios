//
//  GMSearchKeyWordSavedModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 05/05/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMSearchKeyWordSavedModal.h"

static NSString * const kSavedTrendingKey                   = @"SavedTrending";

static GMSearchKeyWordSavedModal *searchKeyWordSavedModal;


@implementation GMSearchKeyWordSavedModal




+ (instancetype)loadSavedTrendingModal{
    
    searchKeyWordSavedModal = [self unarchiveRootCategory];
    return searchKeyWordSavedModal;
}

+ (GMSearchKeyWordSavedModal *)unarchiveRootCategory {
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"searchKeyWordSavedModal"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        GMSearchKeyWordSavedModal *searchKeyWordSavedModal  = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        return searchKeyWordSavedModal;
    }
    return nil;
}


- (instancetype)initWithSavedTrendingModalArray:(NSMutableArray *)savedTrendingModalArray {
    
    if(self = [super init]) {
        _savedTrendingModalArray = savedTrendingModalArray;
    }
    return self;
}

- (void)archiveavedTrendingModal{
    
    NSString *archivePath = [grocerMaxDirectory stringByAppendingPathComponent:@"searchKeyWordSavedModal"];
    BOOL success = [NSKeyedArchiver archiveRootObject:self toFile:archivePath];
    searchKeyWordSavedModal = nil;
    DLOG(@"archived : %d",success);
}

#pragma mark - Encoder/Decoder Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.savedTrendingModalArray forKey:kSavedTrendingKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if((self = [super init])) {
        
        self.savedTrendingModalArray = [aDecoder decodeObjectForKey:kSavedTrendingKey];
    }
    return self;
}



@end
