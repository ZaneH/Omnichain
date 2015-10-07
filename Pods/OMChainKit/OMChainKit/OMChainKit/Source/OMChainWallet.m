//
//  OMChainWallet.m
//  OMChainKit
//
//  Created by Zane Helton on 3/15/15.
//  Copyright (c) 2015 ZaneHelton. All rights reserved.
//

#import "OMChainWallet.h"

@implementation OMChainWallet {
	NSString *_potentialEmail;
	NSString *_potentialPassword;
	
	NSString *_tempAddress;
	NSString *_tempMessage;
	NSString *_tempSignature;
	
	double _tempHashrate;
	double _tempDifficulty;
	
	NSTimeInterval _timeOutInterval;
	
	OmnichainFailed _failedBlock;
	SignInSuccess _successBlock;
	SignMessageSuccess _signMessageSuccessBlock;
	AddressCreateSuccess _addressCreateSuccessBlock;
	GetInfoComplete _getInfoCompleteBlock;
	GetBalanceComplete _getBalanceCompleteBlock;
	IsValidAddressComplete _isValidAddressCompleteBlock;
	IsValidSignatureComplete _isValidSignatureCompleteBlock;
	GetRichListComplete _getRichListCompleteBlock;
	GetStatsComplete _getStatsCompleteBlock;
	GetCalculatedEarningsComplete _getCalculatedEarningsCompleteBlock;
	
	RegisterSuccess _registerSuccessBlock;
	ChangeEmailSuccess _changeEmailSuccessBlock;
	ChangePasswordSuccess _changePasswordSuccessBlock;
	SendOmnicoinSuccess _sendOmnicoinSuccessBlock;
	GenerateAddressSuccess _generateAddressSuccessBlock;
}

#pragma mark - Initializers

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password {
	self = [super init];
	if (self) {
		self.username = username;
		self.passwordHash = [self createSHA512WithString:password];
		self.transactions = [NSMutableArray new];
		self.addresses = [NSMutableArray new];
		self.transactionsIn = 0;
		self.transactionsOut = 0;
		self.totalIn = 0;
		self.totalOut = 0;
		self.balance = 0;
		self.pendingBalance = 0;
		self.version = 0;
		_timeOutInterval = 60;
	}
	return self;
}

#pragma mark - Get Info Methods

- (void)refreshWalletInfo {
	[self createAPIRequestWithMethod:@"wallet_getinfo"
							  params:@{@"username":self.username,
									   @"password":self.sessionToken}];
}

#pragma mark - Configuration Methods

- (void)setTimout:(NSUInteger)timeOut {
	_timeOutInterval = timeOut;
}

#pragma mark - Mostly Statistics API Interaction Method Declarations

- (void)omcGetInfoWithCompletionHandler:(void (^)(NSDictionary *info, NSString *error))ch {
	_getInfoCompleteBlock = ch;
	[self createAPIRequestWithMethod:@"getinfo"
							  params:@{}];
}

- (void)omcGetBalanceWithAddress:(NSString *)address
			   completionHandler:(void (^)(NSString *address, double balance, NSString *error))ch {
	_tempAddress = address;
	_getBalanceCompleteBlock = ch;
	[self createAPIRequestWithMethod:@"getbalance"
							  params:@{@"address":address}];
}

- (void)omcCheckAddressWithAddress:(NSString *)address
				 completionHandler:(void (^)(NSString *address, BOOL isValid, NSString *error))ch {
	_tempAddress = address;
	_isValidAddressCompleteBlock = ch;
	[self createAPIRequestWithMethod:@"checkaddress"
							  params:@{@"address":address}];
}

- (void)omcVerifyMessageWithAddress:(NSString *)address
							message:(NSString *)message
						  signature:(NSString *)signature
				  completionHandler:(void (^)(NSString *address, NSString *message, NSString *signature, BOOL isVerified, NSString *error))ch {
	_tempAddress = address;
	_tempMessage = message;
	_tempSignature = signature;
	_isValidSignatureCompleteBlock = ch;
	[self createAPIRequestWithMethod:@"verifymessage"
							  params:@{@"address":address,
									   @"message":message,
									   @"signature":signature}];
}

- (void)omcGetRichListWithCompletionHandler:(void (^)(NSArray *richList, NSString *error))ch {
	_getRichListCompleteBlock = ch;
	[self createAPIRequestWithMethod:@"getrichlist"
							  params:@{}];
}

- (void)omcGetStatsWithCompletionHandler:(void (^)(NSDictionary *stats, NSString *error))ch {
	_getStatsCompleteBlock = ch;
	[self createAPIRequestWithMethod:@"getwstats"
							  params:@{}];
}

- (void)omcCalculateEarningsWithHashrate:(double)hashrate
					   completionHandler:(void (^)(double hashrate, double difficulty, NSDictionary *data, NSString *error))ch {
	_tempHashrate = hashrate;
	_getCalculatedEarningsCompleteBlock = ch;
	[self createAPIRequestWithMethod:@"earningscalc"
							  params:@{@"hashrate":[NSNumber numberWithDouble:hashrate]}];
}

- (void)omcCalculateEarningsWithHashrate:(double)hashrate
							  difficulty:(double)difficulty
					   completionHandler:(void (^)(double hashrate, double difficulty, NSDictionary *data, NSString *error))ch {
	_tempHashrate = hashrate;
	_tempDifficulty = difficulty;
	_getCalculatedEarningsCompleteBlock = ch;
	[self createAPIRequestWithMethod:@"earningscalc"
							  params:@{@"hashrate":[NSNumber numberWithDouble:hashrate],
									   @"difficulty":[NSNumber numberWithDouble:difficulty]}];
}

#pragma mark - API Interaction Methods

- (void)attemptSignInWithSuccess:(void (^)())successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	_successBlock = successBlock;
	_failedBlock = failureBlock;
	[self createAPIRequestWithMethod:@"wallet_login"
							  params:@{@"username":self.username,
									   @"password":self.passwordHash}];
}

- (void)registerAccountWithUsername:(NSString *)username password:(NSString *)password success:(void (^)())successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	[self registerAccountWithUsername:username password:password confirmPassword:password success:successBlock failed:failureBlock];
}

- (void)registerAccountWithUsername:(NSString *)username password:(NSString *)password confirmPassword:(NSString *)confirmPassword success:(void (^)())successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	_registerSuccessBlock = successBlock;
	_failedBlock = failureBlock;
	[self createAPIRequestWithMethod:@"wallet_register"
							  params:@{@"username":username,
									   @"password":[self createSHA512WithString:password],
									   @"passwordConfirm":[self createSHA512WithString:confirmPassword]}];
}

- (void)changeEmailForAccountWithNewEmail:(NSString *)email success:(void (^)())successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	_changeEmailSuccessBlock = successBlock;
	_failedBlock = failureBlock;
	_potentialEmail = email;
	[self createAPIRequestWithMethod:@"wallet_changeemail"
							  params:@{@"username":self.username,
									   @"password":self.sessionToken,
									   @"email":email}];
}

- (void)changePasswordForAccountWithNewPassword:(NSString *)password success:(void (^)())successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	[self changePasswordForAccountWithNewPassword:password confirmPassword:password success:successBlock failed:failureBlock];
}

- (void)changePasswordForAccountWithNewPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword success:(void (^)())successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	_changePasswordSuccessBlock = successBlock;
	_failedBlock = failureBlock;
	_potentialPassword = [self createSHA512WithString:password];
	
	// client-side checking
	if ([password isEqualToString:@""] || [confirmPassword isEqualToString:@""]) {
		if (failureBlock) failureBlock(self, @"EMPTY_REQUIRED_FIELDS");
		return;
	}
	if (![password isEqualToString:confirmPassword]) {
		if (failureBlock) failureBlock(self, @"NONMATCHING_PASSWORDS");
		return;
	}
	
	// if everything's alright on the client-side, send the request
	[self createAPIRequestWithMethod:@"wallet_changepassword"
							  params:@{@"username":self.username,
									   @"password":self.sessionToken,
									   @"password_new":[self createSHA512WithString:password],
									   @"password_new_confirm":[self createSHA512WithString:confirmPassword]}];
}

- (void)signMessageWithAddress:(NSString *)address message:(NSString *)message success:(void (^)(NSString *address, NSString *message, NSString *signature))successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	_signMessageSuccessBlock = successBlock;
	_failedBlock = failureBlock;
	_tempAddress = address;
	_tempMessage = message;
	[self createAPIRequestWithMethod:@"wallet_signmessage"
							  params:@{@"username":self.username,
									   @"password":self.sessionToken,
									   @"address":address,
									   @"message":message}];
}

- (void)importPrivateKeyWithKey:(NSString *)privateKey address:(NSString *)address {
	[self createAPIRequestWithMethod:@"wallet_importkey"
							  params:@{@"username":self.username,
									   @"password":self.sessionToken,
									   @"address":address,
									   @"privkey":privateKey}];
}

- (void)sendOmnicoinToAddress:(NSString *)address amount:(double)amount success:(void (^)())successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	_sendOmnicoinSuccessBlock = successBlock;
	_failedBlock = failureBlock;
	[self createAPIRequestWithMethod:@"wallet_send"
							  params:@{@"username":self.username,
									   @"password":self.sessionToken,
									   @"address":address,
									   @"amount":[NSNumber numberWithDouble:amount]}];
}

- (void)generateNewAddressWithSuccess:(void (^)(NSString *address))successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock {
	_generateAddressSuccessBlock = successBlock;
	_failedBlock = failureBlock;
	[self createAPIRequestWithMethod:@"wallet_genaddr"
							  params:@{@"username":self.username,
									   @"password":self.sessionToken}];
}

#pragma mark - Helper Methods

- (NSString *)createSHA512WithString:(NSString *)source {
	const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
	NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
	uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
	CC_SHA512(keyData.bytes, (int)keyData.length, digest);
	NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
	
	// If you have a better method to do this please create a pull request. This is just sad.
	// stringValue returns (null) so this is all I could think of.
	return [[[[out description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
}

- (void)createAPIRequestWithMethod:(NSString *)method params:(NSDictionary *)params {
	NSArray *keys = [params allKeys];
	NSArray *values = [params allValues];
	NSString *requestString = @"";
	for (int keyIndex = 0; keyIndex < keys.count; keyIndex++) {
		requestString = [requestString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", keys[keyIndex], values[keyIndex]]];
	}
	
	NSURL *requestURL = [NSURL URLWithString:[[NSString stringWithFormat:@"https://omnicha.in/api?method=%@%@", method, requestString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSMutableURLRequest *callMethodRequest = [[NSMutableURLRequest alloc]
											  initWithURL:requestURL
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
											  timeoutInterval:_timeOutInterval];
	[callMethodRequest setHTTPMethod:@"GET"];
	[NSURLConnection connectionWithRequest:callMethodRequest delegate:self];
}

- (void)stopCurrentRequest {
	[NSURLConnection cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// sets session token & checks login
	NSString *methodSubString = connection.currentRequest.URL.query.length >= 19 ? [connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, 19)] : @"";
	if ([methodSubString isEqualToString:@"method=wallet_login"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_failedBlock) _failedBlock(self, [jsonObject valueForKey:@"error_info"]);
				[self.delegate omnichainFailedWithWallet:self error:@"wallet_login"];
				return;
			}
			self.sessionToken = [[jsonObject valueForKey:@"response"] valueForKey:@"session"];
			self.version = [jsonObject valueForKey:@"version"];
		} else {
			if (_failedBlock) _failedBlock(self, @"API_CHANGED");
			[self.delegate omnichainFailedWithWallet:self error:@"wallet_login"];
			return;
		}
		[self refreshWalletInfo];
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= 21 ? [connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, 21)] : @"";
	// sets transactions out, total out, transactions in, total in, balance, pending balance, transactions, addresses, & omcUSDValue
	if ([methodSubString isEqualToString:@"method=wallet_getinfo"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_failedBlock) _failedBlock(self, [jsonObject valueForKey:@"error_info"]);
				return;
			}
			
			NSDictionary *response = [jsonObject valueForKey:@"response"];
			
			self.emailAddress = [response valueForKey:@"email"];
			
			self.transactionsOut = [[response valueForKey:@"tx_out"] integerValue];
			self.totalOut = [[response valueForKey:@"total_out"] doubleValue];
			
			self.transactionsIn = [[response valueForKey:@"tx_in"] integerValue];
			self.totalIn = [[response valueForKey:@"total_in"] doubleValue];
			
			self.balance = [[response valueForKey:@"balance"] doubleValue];
			self.pendingBalance = [[response valueForKey:@"pending_balance"] doubleValue];
			
			for (int transactionIndex = 0; transactionIndex < [[response valueForKey:@"transactions"] count]; transactionIndex++) {
				OMChainTransaction *newTransaction = [[OMChainTransaction alloc] init];
				newTransaction.date = [[[response valueForKey:@"transactions"] objectAtIndex:transactionIndex] valueForKey:@"date"];
				newTransaction.confirmations = [[[[response valueForKey:@"transactions"] objectAtIndex:transactionIndex] valueForKey:@"confirmations"] integerValue];
				newTransaction.transactionHash = [[[response valueForKey:@"transactions"] objectAtIndex:transactionIndex] valueForKey:@"tx_hash"];
				newTransaction.valueOfTransaction = [[[[response valueForKey:@"transactions"] objectAtIndex:transactionIndex] valueForKey:@"value"] doubleValue];
				newTransaction.balance = [[[[response valueForKey:@"transactions"] objectAtIndex:transactionIndex] valueForKey:@"balance"] doubleValue];
				
				[self.transactions insertObject:newTransaction atIndex:0];
			}
			
			NSArray *addressesArray = [response valueForKey:@"addresses"];
			for (int addressIndex = 0; addressIndex < [addressesArray count]; addressIndex++) {
				OMChainAddress *newAddress = [[OMChainAddress alloc] init];
				newAddress.address = [[[response valueForKey:@"addresses"] objectAtIndex:addressIndex] valueForKey:@"address"];
				newAddress.privateKey = [[[response valueForKey:@"addresses"] objectAtIndex:addressIndex] valueForKey:@"private_key"];
				
				[self.addresses insertObject:newAddress atIndex:0];
			}
			
			self.omcUSDValue = [[response valueForKey:@"omc_usd_price"] doubleValue];
		} else {
			if (_failedBlock) _failedBlock(self, @"API_CHANGED");
			[self.delegate omnichainFailedWithWallet:self error:@"wallet_getinfo"];
			return;
		}
		if (_successBlock) _successBlock(self);
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= 22 ? [connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, 22)] : @"";
	// creates a user on Omnicha.in
	if ([methodSubString isEqualToString:@"method=wallet_register"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_failedBlock) _failedBlock(self, [jsonObject valueForKey:@"error_info"]);
				return;
			}
		} else {
			if (_failedBlock) _failedBlock(self, @"API_CHANGED");
			[self.delegate omnichainFailedWithWallet:self error:@"API_CHANGED"];
			return;
		}
		if (_registerSuccessBlock) _registerSuccessBlock();
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= 26 ? [connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, 26)] : @"";
	// changes users email address
	if ([methodSubString isEqualToString:@"method=wallet_changeemail"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_failedBlock) _failedBlock(self, [jsonObject valueForKey:@"error_info"]);
				return;
			}
			// if there's an error don't update the email, otherwise do update the email address
			self.emailAddress = _potentialEmail;
		} else {
			if (_failedBlock) _failedBlock(self, @"API_CHANGED");
			[self.delegate omnichainFailedWithWallet:self error:@"wallet_changeemail"];
			return;
		}
		if (_changeEmailSuccessBlock) _changeEmailSuccessBlock();
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= 28 ? [connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, 28)] : @"";
	// changes the users password
	if ([methodSubString isEqualToString:@"method=wallet_changepassword"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_failedBlock) _failedBlock(self, [jsonObject valueForKey:@"error_info"]);
				return;
			}
			// if there's an error don't update the password, otherwise do update the password
			self.passwordHash = _potentialPassword;
		} else {
			if (_failedBlock) _failedBlock(self, @"API_CHANGED");
			[self.delegate omnichainFailedWithWallet:self error:@"changepassword"];
			return;
		}
		if (_changePasswordSuccessBlock) _changePasswordSuccessBlock();
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= 25 ? [connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, 25)] : @"";
	// signs a message to an address (I have no idea what this is tbh, but it was in the API and I needed to add it)
	if ([methodSubString isEqualToString:@"method=wallet_signmessage"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_failedBlock) _failedBlock(self, [jsonObject valueForKey:@"error_info"]);
				return;
			}
		} else {
			if (_failedBlock) _failedBlock(self, @"API_CHANGED");
			[self.delegate omnichainFailedWithWallet:self error:@"wallet_signmessage"];
			return;
		}
		if (_signMessageSuccessBlock) _signMessageSuccessBlock(_tempAddress, _tempMessage, [[jsonObject valueForKey:@"response"] valueForKey:@"signature"]);
		return;
	}
	
	// Disabled for now (not my decision)
	/*methodSubString = connection.currentRequest.URL.query.length >= 23 ? [connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, 23)] : @"";
	// imports a previously generated address into Omnicha.in
	if ([methodSubString isEqualToString:@"method=wallet_importkey"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				//_failedBlock(self, [jsonObject valueForKey:@"error_info"]);
				return;
			}
		} else {
			//_failedBlock(self, @"API_CHANGED");
			return;
		}
		// depreciated delegate inside a depreciated API...
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
		[self.delegate omnichainSucceededWithWallet:self method:@"wallet_importkey"];
#pragma GCC diagnostic pop
		return;
	}*/
	
	methodSubString = connection.currentRequest.URL.query.length >= 21 ? [connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, 21)] : @"";
	// generates a new address on Omnicha.in
	if ([methodSubString isEqualToString:@"method=wallet_genaddr"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_generateAddressSuccessBlock) _generateAddressSuccessBlock(nil);
				return;
			}
		} else {
			if (_generateAddressSuccessBlock) _generateAddressSuccessBlock(nil);
			[self.delegate omnichainFailedWithWallet:self error:@"wallet_genaddr"];
			return;
		}
		if (_generateAddressSuccessBlock) _generateAddressSuccessBlock([[jsonObject valueForKey:@"response"] valueForKey:@"address"]);
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= 14 ? [connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, 14)] : @"";
	// returns misc information like difficulty, mining speed, and average block time
	if ([methodSubString isEqualToString:@"method=getinfo"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_getInfoCompleteBlock) _getInfoCompleteBlock(nil, [jsonObject valueForKey:@"error_info"]);
				[self.delegate omnichainFailedWithWallet:self error:@"getinfo"];
				return;
			}
			NSDictionary *infoDictionary = @{@"block_count":[NSNumber numberWithInteger:[[[jsonObject valueForKey:@"response"] valueForKey:@"block_count"] integerValue]],
											 @"difficulty":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"difficulty"] doubleValue]],
											 @"netmhps":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"netmhps"] doubleValue]],
											 @"seconds_since_block":[NSNumber numberWithInteger:[[[jsonObject valueForKey:@"response"] valueForKey:@"seconds_since_block"] integerValue]],
											 @"avg_block_time_1":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"avg_block_time_1"] doubleValue]],
											 @"avg_block_time_24":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"avg_block_time_24"] doubleValue]],
											 @"total_mined_omc":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"total_mined_omc"] doubleValue]],
											 @"omc_btc_price":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"omc_btc_price"] doubleValue]],
											 @"omc_usd_price":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"omc_usd_price"] doubleValue]],
											 @"market_cap":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"market_cap"] doubleValue]],
											 @"block_reward":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"block_reward"] doubleValue]]};
			if (_getInfoCompleteBlock) _getInfoCompleteBlock(infoDictionary, nil);
			return;
		} else {
			if (_getInfoCompleteBlock) _getInfoCompleteBlock(nil, [jsonObject valueForKey:@"error_info"]);
			[self.delegate omnichainFailedWithWallet:self error:@"getinfo"];
			return;
		}
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= @"method=getbalance".length ?
		[connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, @"method=getbalance".length)] : @"";
	// gets the balance of said wallet
	if ([methodSubString isEqualToString:@"method=getbalance"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_getBalanceCompleteBlock) _getBalanceCompleteBlock(nil, 0, [jsonObject valueForKey:@"error_info"]);
				[self.delegate omnichainFailedWithWallet:self error:@"getbalance"];
				return;
			}
			if (_getBalanceCompleteBlock) _getBalanceCompleteBlock(_tempAddress, [[[jsonObject valueForKey:@"response"] valueForKey:@"balance"] doubleValue], nil);
			return;
		} else {
			if (_getBalanceCompleteBlock) _getBalanceCompleteBlock(nil, 0, [jsonObject valueForKey:@"error_info"]);
			[self.delegate omnichainFailedWithWallet:self error:@"getbalance"];
			return;
		}
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= @"method=checkaddress".length ?
		[connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, @"method=checkaddress".length)] : @"";
	// checks if said address belongs to a valid wallet
	if ([methodSubString isEqualToString:@"method=checkaddress"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_isValidAddressCompleteBlock) _isValidAddressCompleteBlock(nil, 0, [jsonObject valueForKey:@"error_info"]);
				[self.delegate omnichainFailedWithWallet:self error:@"checkaddress"];
				return;
			}
			if (_isValidAddressCompleteBlock) _isValidAddressCompleteBlock(_tempAddress, [[[jsonObject valueForKey:@"response"] valueForKey:@"isvalid"] boolValue], nil);
			return;
		} else {
			if (_isValidAddressCompleteBlock) _isValidAddressCompleteBlock(nil, 0, [jsonObject valueForKey:@"error_info"]);
			[self.delegate omnichainFailedWithWallet:self error:@"checkaddress"];
			return;
		}
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= @"method=verifymessage".length ?
		[connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, @"method=verifymessage".length)] : @"";
	// checks if said address belongs to a valid wallet
	if ([methodSubString isEqualToString:@"method=verifymessage"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_isValidSignatureCompleteBlock) _isValidSignatureCompleteBlock(nil, nil, nil, 0, nil);
				[self.delegate omnichainFailedWithWallet:self error:@"verifymessage"];
				return;
			}
			if (_isValidSignatureCompleteBlock) _isValidSignatureCompleteBlock(_tempAddress, _tempMessage, _tempSignature, [[[jsonObject valueForKey:@"response"] valueForKey:@"isvalid"] boolValue], nil);
			return;
		} else {
			if (_isValidSignatureCompleteBlock) _isValidSignatureCompleteBlock(nil, nil, nil, 0, [jsonObject valueForKey:@"error_info"]);
			[self.delegate omnichainFailedWithWallet:self error:@"verifymessage"];
			return;
		}
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= @"method=getrichlist".length ?
	[connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, @"method=getrichlist".length)] : @"";
	// checks if said address belongs to a valid wallet
	if ([methodSubString isEqualToString:@"method=getrichlist"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_getRichListCompleteBlock) _getRichListCompleteBlock(nil, [jsonObject valueForKey:@"error_info"]);
				[self.delegate omnichainFailedWithWallet:self error:@"getrichlist"];
				return;
			}
			// making the rich list ( dictionaries inside an array )
			NSMutableArray *richList = [NSMutableArray new];
			for (int personIndex = 0; personIndex < [[[jsonObject valueForKey:@"response"] valueForKey:@"richlist"] count]; personIndex++) {
				NSDictionary *tempPersonDictionary = @{@"address":[[[[jsonObject valueForKey:@"response"] valueForKey:@"richlist"] objectAtIndex:personIndex] valueForKey:@"address"],
												 @"balance":[NSNumber numberWithDouble:[[[[[jsonObject valueForKey:@"response"] valueForKey:@"richlist"] objectAtIndex:personIndex] valueForKey:@"balance"] doubleValue]],
												 @"percent":[NSNumber numberWithDouble:[[[[[jsonObject valueForKey:@"response"] valueForKey:@"richlist"] objectAtIndex:personIndex] valueForKey:@"percent"] doubleValue]],
												 @"rank":[NSNumber numberWithInteger:[[[[[jsonObject valueForKey:@"response"] valueForKey:@"richlist"] objectAtIndex:personIndex] valueForKey:@"rank"] integerValue]],
												 @"usd_value":[NSNumber numberWithDouble:[[[[[jsonObject valueForKey:@"response"] valueForKey:@"richlist"] objectAtIndex:personIndex] valueForKey:@"usd_value"] doubleValue]],
												 @"vanity_name":[[[[jsonObject valueForKey:@"response"] valueForKey:@"richlist"] objectAtIndex:personIndex] valueForKey:@"vanity_name"]};
				[richList addObject:tempPersonDictionary];
			}
			if (_getRichListCompleteBlock) _getRichListCompleteBlock([NSArray arrayWithArray:richList], nil);
			return;
		} else {
			if (_getRichListCompleteBlock) _getRichListCompleteBlock(nil, [jsonObject valueForKey:@"error_info"]);
			[self.delegate omnichainFailedWithWallet:self error:@"getrichlist"];
			return;
		}
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= @"method=getwstats".length ?
	[connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, @"method=getwstats".length)] : @"";
	// checks if said address belongs to a valid wallet
	if ([methodSubString isEqualToString:@"method=getwstats"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_getStatsCompleteBlock) _getStatsCompleteBlock(nil, [jsonObject valueForKey:@"error_info"]);
				[self.delegate omnichainFailedWithWallet:self error:@"getwstats"];
				return;
			}
			NSDictionary *statsDictionary = @{@"users":[NSNumber numberWithInteger:[[[jsonObject valueForKey:@"response"] valueForKey:@"users"] integerValue]],
											  @"balance":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"balance"] doubleValue]]};
			if (_getStatsCompleteBlock) _getStatsCompleteBlock(statsDictionary, nil);
			return;
		} else {
			if (_getStatsCompleteBlock) _getStatsCompleteBlock(nil, [jsonObject valueForKey:@"error_info"]);
			[self.delegate omnichainFailedWithWallet:self error:@"getwstats"];
			return;
		}
		return;
	}
	
	methodSubString = connection.currentRequest.URL.query.length >= @"method=earningscalc".length ?
	[connection.currentRequest.URL.query substringWithRange:NSMakeRange(0, @"method=earningscalc".length)] : @"";
	// checks if said address belongs to a valid wallet
	if ([methodSubString isEqualToString:@"method=earningscalc"]) {
		NSError *error = nil;
		id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		// check if json is valid
		if (!error) {
			// check if request is valid
			if ([[jsonObject valueForKey:@"error"] boolValue] == 1) {
				if (_getCalculatedEarningsCompleteBlock) _getCalculatedEarningsCompleteBlock(0, 0, nil, [jsonObject valueForKey:@"error_info"]);
				[self.delegate omnichainFailedWithWallet:self error:@"earningscalc"];
				return;
			}
			NSDictionary *estimationDictionary = @{@"daily":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"daily"] doubleValue]],
											  @"weekly":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"weekly"] doubleValue]],
											  @"monthly":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"monthly"] doubleValue]],
											  @"yearly":[NSNumber numberWithDouble:[[[jsonObject valueForKey:@"response"] valueForKey:@"yearly"] doubleValue]]};
			if (_getCalculatedEarningsCompleteBlock) _getCalculatedEarningsCompleteBlock(_tempHashrate, _tempDifficulty, estimationDictionary, nil);
			return;
		} else {
			if (_getCalculatedEarningsCompleteBlock) _getCalculatedEarningsCompleteBlock(0, 0, nil, [jsonObject valueForKey:@"error_info"]);
			[self.delegate omnichainFailedWithWallet:self error:@"earningscalc"];
			return;
		}
		return;
	}
}

@end
