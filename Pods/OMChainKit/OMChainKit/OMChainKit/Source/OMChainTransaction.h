//
//  OMChainTransaction.h
//  OMChainKit
//
//  Created by Zane Helton on 3/15/15.
//  Copyright (c) 2015 ZaneHelton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMChainTransaction : NSObject

/**
 *  Timestamp of transaction
 */
@property (copy) NSString *date;
/**
 *  Number of confirmations
 */
@property (nonatomic) NSInteger confirmations;
/**
 *  Transaction hash
 */
@property (copy) NSString *transactionHash;
/**
 *  Value of the transaction in OMC
 */
@property (nonatomic) NSInteger valueOfTransaction;
/**
 *  Account balance after transaction in OMC
 */
@property (assign) double balance;

@end
