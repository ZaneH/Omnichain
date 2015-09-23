//
//  OMChainAddress.h
//  OMChainKit
//
//  Created by Zane Helton on 3/15/15.
//  Copyright (c) 2015 ZaneHelton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMChainAddress : NSObject

/**
 *  The address of the Omnicoin address
 */
@property (copy) NSString *address;
/**
 *  The private key of the Omnicoin address
 */
@property (copy) NSString *privateKey;

@end
