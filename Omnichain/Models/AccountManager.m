//
//  AccountManager.m
//  Omnichain
//
//  Created by Zane Helton on 9/23/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager
@synthesize userWallet;

+ (instancetype)sharedInstance {
	static AccountManager *_sharedInstance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[self alloc] init];
	});
	
	return _sharedInstance;
}

- (void)signUpWithUsername:(NSString *)username password:(NSString *)password success:(void (^)())successBlock failure:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	[[OMChainWallet alloc] registerAccountWithUsername:username
											  password:password
											   success:^{
												   successBlock();
											   } failed:^(OMChainWallet *wallet, NSString *error) {
												   failureBlock(wallet, error);
											   }];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)())successBlock failure:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	userWallet = [[OMChainWallet alloc] initWithUsername:username password:password];
	[userWallet attemptSignInWithSuccess:^{
		successBlock();
	} failed:^(OMChainWallet *wallet, NSString *error) {
		failureBlock(wallet, error);
	}];
}

- (void)stopCurrentRequest {
	[userWallet stopCurrentRequest];
}

@end
