//
//  AccountManager.h
//  Omnichain
//
//  Created by Zane Helton on 9/23/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OMChainKit/OMChainWallet.h>

@interface AccountManager : NSObject

@property (nonatomic, strong) OMChainWallet *userWallet;

+ (instancetype)sharedInstance;

- (NSString *)signUpWithUsername:(NSString *)username password:(NSString *)password;
- (NSString *)loginWithUsername:(NSString *)username password:(NSString *)password;

@end
