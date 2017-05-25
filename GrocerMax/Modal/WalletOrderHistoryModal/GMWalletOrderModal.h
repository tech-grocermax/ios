//
//  GMWalletOrderModal.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 15/12/15.
//  Copyright © 2015 Deepak Soni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMWalletOrderModal : MTLModel <MTLJSONSerializing>


@property (nonatomic, readonly, strong) NSMutableArray *walletOrderHistoryArray;

-(void )walletHistoryParseWithDic:(NSMutableDictionary *)dataDic;

@end


@interface GMWalletOrderHistoryModal : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *walletDate;

@property (nonatomic, strong) NSString *walletComment;

@property (nonatomic, strong) NSString *walletOrderId;

@property (nonatomic, strong) NSString *walletAmount;

@end