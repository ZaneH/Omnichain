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

- (BOOL)signUpWithUsername:(NSString *)username password:(NSString *)password {
	__block BOOL success;
	[[OMChainWallet alloc] registerAccountWithUsername:username
											  password:password
											   success:^{
												   success = YES;
											   } failed:^(OMChainWallet *wallet, NSString *error) {
												   success = NO;
											   }];
	
	return success;
}

- (BOOL)loginWithUsername:(NSString *)username password:(NSString *)password {
	__block BOOL success;
	userWallet = [[OMChainWallet alloc] initWithUsername:username
												password:password
												 success:^(OMChainWallet *wallet) {
													 success = YES;
												 } failure:^(OMChainWallet *wallet, NSString *error) {
													 success = NO;
													 NSLog(@"%@", error);
												 }];
	
	return success;
}

@end
