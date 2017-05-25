//
//  GMWalletOrderModal.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 15/12/15.
//  Copyright © 2015 Deepak Soni. All rights reserved.
//

#import "GMWalletOrderModal.h"

@interface GMWalletOrderModal()

@property (nonatomic, readwrite, strong) NSMutableArray *walletOrderHistoryArray;

@end

@implementation GMWalletOrderModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"walletOrderHistoryArray"                  : @"log"
             };
}

+ (NSValueTransformer *)orderHistoryArrayJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GMWalletOrderHistoryModal class]];
}

-(void)walletHistoryParseWithDic:(NSMutableDictionary *)dataDic {
    self.walletOrderHistoryArray = [[NSMutableArray alloc]init];
    
    if([dataDic objectForKey:@"log"] && [[dataDic objectForKey:@"log"] isKindOfClass:[NSArray class]]) {
        
        NSArray *historyArray = [dataDic objectForKey:@"log"];
        
        for (int i = 0; i<historyArray.count; i++) {
            
            if([[historyArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]){
                NSMutableDictionary * historyDic = [historyArray objectAtIndex:i];
                
                GMWalletOrderHistoryModal *walletOrderHistoryModal = [[GMWalletOrderHistoryModal alloc]init];
                
                if([historyDic objectForKey:@"action_date"] && NSSTRING_HAS_DATA([historyDic objectForKey:@"action_date"])) {
                    walletOrderHistoryModal.walletDate = [historyDic objectForKey:@"action_date"];
                }
                
                if([historyDic objectForKey:@"comment"] && NSSTRING_HAS_DATA([historyDic objectForKey:@"comment"])) {
                    walletOrderHistoryModal.walletComment = [historyDic objectForKey:@"comment"];
                }
                
                if([historyDic objectForKey:@"order_id"] && NSSTRING_HAS_DATA([historyDic objectForKey:@"order_id"])) {
                    walletOrderHistoryModal.walletOrderId = [historyDic objectForKey:@"order_id"];
                }
                
                if([historyDic objectForKey:@"value_change"] && NSSTRING_HAS_DATA([historyDic objectForKey:@"value_change"])) {
                    walletOrderHistoryModal.walletAmount = [historyDic objectForKey:@"value_change"];
                }
                
                
                [self.walletOrderHistoryArray addObject:walletOrderHistoryModal];
            }
        }
        
    }
    
}

@end

@implementation GMWalletOrderHistoryModal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"walletDate"                     : @"action_date",
             @"walletComment"                  : @"comment",
             @"walletOrderId"                  : @"order_id",
             @"walletAmount"                   : @"value_change",
             };
}

@end

