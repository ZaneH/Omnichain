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

- (NSString *)signUpWithUsername:(NSString *)username password:(NSString *)password {
	__block NSString *_error = nil;
	[[OMChainWallet alloc] registerAccountWithUsername:username
											  password:password
											   success:^{
												   // there is no error, leave it nil
											   } failed:^(OMChainWallet *wallet, NSString *error) {
												   // there is an error, set `_error` equal to the error
												   _error = error;
											   }];
	
	return _error;
}

- (NSString *)loginWithUsername:(NSString *)username password:(NSString *)password {
	__block NSString *_error = nil;
	userWallet = [[OMChainWallet alloc] initWithUsername:username
												password:password
												 success:^(OMChainWallet *wallet) {
													 [wallet attemptSignInWithSuccess:^{
														 // until this method is called, not much is made of the wallet
														 [userWallet refreshWalletInfo];
													 } failed:^(OMChainWallet *wallet, NSString *error) {
														 // there is an error, set `_error` equal to the error
														 _error = error;
													 }];
												 } failure:^(OMChainWallet *wallet, NSString *error) {
													 // there is an error, set `_error` equal to the error
													 _error = error;
												 }];
	
	return _error;
}

@end
