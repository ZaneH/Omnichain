# OMChainKit [![Build Status](https://travis-ci.org/ZaneH/OMChainKit.svg?branch=master)](https://travis-ci.org/ZaneH/OMChainKit)
An API wrapper for https://omnicha.in/api

## Installing the Project

### Cocoapods
1. Install Cocoapod
```
pod 'OMChainKit'
```

2. Run `pod install`

### Manual Install
1. Download the .zip file from GitHub

2. Open the `Source` folder and drag all the files into your Xcode project

## Getting Started
Creating a new `OMChainWallet` object is easy! Simply import your header file, conform your class to the `OMChainDelegate` and add:

    OMChainWallet *wallet = [[OMChainWallet alloc] initWithUsername:@"username" password:@"password" success:nil failed:nil];

From there you can send whatever messages you need to your newly created `wallet` object. Make sure your `wallet` object is initialized with a username and password before you start sending `wallet_*` messages; not doing so will result in a crash. To avoid this, put all the code you want to run inside the `success block`.

##Example
In this example, I will sign into a fake account and change its email address:

	OMChainWallet *exampleWallet = [[OMChainWallet alloc] initWithUsername:@"username" password:@"password" success:^(OMChainWallet *wallet) {
		[exampleWallet changeEmailForAccountWithNewEmail:@"username@domain.com" success:^{
			NSLog(@"Success!");
		} failed:nil];
	} failure:nil];

-
In this example, I will sign into a fake account. If the sign in is successfull it'll retrieve the Omnicha.in rich list, if retrieving the rich list fails, the message "Failed getting the rich list." is logged, otherwise it'll log the contents of the rich list. If the sign in fails, it'll check if the error was "BAD_LOGIN" and if it was it'll log "Username or password incorrect."

	OMChainWallet *exampleWallet = [[OMChainWallet alloc] initWithUsername:@"username" password:@"password" success:^(OMChainWallet *wallet) {
		[_exampleWallet omcGetRichListWithCompletionHandler:^(NSArray *richList, NSString *error) {
			if (error) {
				NSLog(@"Failed getting the rich list.");
				return;
			}
			NSLog(@"%@", richList.description);
		}];
	} failure:^(OMChainWallet *wallet, NSString *error) {
		if ([error isEqualToString:@"BAD_LOGIN"]) {
			NSLog(@"Username or password incorrect.");
		}
	}];

## Delegates
> **`- (void)omnichainFailedWithWallet:(OMChainWallet *)wallet error:(NSString *)error`**: Called whenever something fails. Check error for what API request is failing.

## Current Methods
#### OMChainWallet
> **`- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password delegate:(id<OMChainDelegate>)delegate`**: Used to create a new `OMChainWallet` object. The delegate is a required argument because of how imporant delegates are to this wrapper. Username and password should both be passed in plain text.

-

> **`- (instancetype)init`**: Creates an empty wallet with all values initialized.

-

> **`- (void)setTimout:(NSUInteger)timeOut`**: Sets the timeout value for NSMutableURLRequest.

-

> **`- (void)getWalletInfo`**: Updates all the wallet info. ([wallet_getinfo](https://omnicha.in/api#wallet_getinfo-docs))

-

> **`- (void)registerAccountWithUsername:(NSString *)username password:(NSString *)password confirmPassword:(NSString *)confirmPassword`**: Registers a new account with Omnicha.in using password confirmation. ([wallet_register](https://omnicha.in/api#wallet_register-docs))

-

> **`- (void)registerAccountWithUsername:(NSString *)username password:(NSString *)password`**: Registers a new account with Omnicha.in without using password confirmation. ([wallet_changepassword](https://omnicha.in/api#wallet_changepassword-docs))

-

> **`- (void)createAPIRequestWithMethod:(NSString *)method params:(NSDictionary *)params`**: Creates a custom API call with custom parameters. Helpful for calling API calls not yet implemented in the wrapper.

-

> **`- (void)changeEmailForAccountWithNewEmail:(NSString *)email`**:  ([wallet_changeemail](https://omnicha.in/api#wallet_changeemail-docs))

-

> **`- (void)changePasswordForAccountWithNewPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword`**: Changes the password on the account using a confirmation password. ([wallet_changepassword](https://omnicha.in/api#wallet_changepassword-docs))

-

> **`- (void)changePasswordForAccountWithNewPassword:(NSString *)password`**: Changes the password on the account without using a confirmation password. ([wallet_changepassword](https://omnicha.in/api#wallet_changepassword-docs))

-

> **`- (void)signMessageWithAddress:(NSString *)address message:(NSString *)message`**: Signs a message to an address, check the delegate call for more details. ([wallet_signmessage](https://omnicha.in/api#wallet_signmessage-docs))

-

> **`- (void)sendOmnicoinToAddress:(NSString *)address amount:(double)amount`**: Send Omnicoins to a specified address with a specified amount. Check the delegate call for more details. ([wallet_send](https://omnicha.in/api#wallet_send-docs))

-

> **`- (void)generateNewAddress`**: Creates a new address on Omnicha.in. Limited to 1/minute. Check delegate call for more details. ([wallet_genaddr](https://omnicha.in/api#wallet_genaddr-docs))

-

> **`- (void)omcGetInfo`**: Returns misc information like difficulty, mining speed, and average block time ([getinfo](https://omnicha.in/api#getinfo-docs))

-

> **`- (void)omcGetBalanceWithAddress:(NSString *)address`**: Returns the value of an Omnicoin address ([getbalance](https://omnicha.in/api#getbalance-docs))

-

> **`- (void)omcCheckAddressWithAddress:(NSString *)address`**: A BOOL saying whether it's a real address or not ([checkaddress](https://omnicha.in/api#checkaddress-docs))

-

> **`- (void)omcVerifyMessageWithAddress:(NSString *)address message:(NSString *)message signature:(NSString *)signature`**: Returns whether the specified signature is as valid hash for the specified message for the specified address ([verifymessage](https://omnicha.in/api#verifymessage-docs))

-

> **`- (void)omcGetRichList`**: Returns data for generating the richlist on https://omnicha.in/richlist/ ([getrichlist](https://omnicha.in/api#getrichlist-docs))

-

> **`- (void)omcGetStats`**: Returns total users and total balance of all online wallet accounts ([getwstats](https://omnicha.in/api#getwstats-docs))

-

> **`- (void)omcCalculateEarningsWithHashrate:(double)hashrate`**: Retuns the amount of OMC that will be mined with the specified hashrate ([earningscalc](https://omnicha.in/api#earningscalc-docs))

-

> **`- (void)omcCalculateEarningsWithHashrate:(double)hashrate difficulty:(double)difficulty`**: The earningscalc method returns the amount of OMC that will be mined with the specified hashrate and difficulty ([earningscalc](https://omnicha.in/api#earningscalc-docs))
