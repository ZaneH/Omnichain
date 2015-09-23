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

- (void)signUpWithUsername:(NSString *)username password:(NSString *)password success:(void (^)())successBlock failure:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)())successBlock failure:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

- (void)stopCurrentRequest;

@end
