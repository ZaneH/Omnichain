# OMChainKit v0.8.0 [![Build Status](https://travis-ci.org/ZaneH/OMChainKit.svg?branch=master)](https://travis-ci.org/ZaneH/OMChainKit)
An API wrapper for https://omnicha.in/api

## Documentation

### Cocoadocs
OMChainWallet is the only class you need to look at for functional methods. The other classes might as well be structs.
http://cocoadocs.org/docsets/OMChainKit/1.2.1/Classes/OMChainWallet.html

## Installing the Project

### Cocoapods
1. Install Cocoapod `pod 'OMChainKit'`
2. Run `pod install`

### Manual Install
1. Download the .zip file from GitHub
2. Open the `Source` folder and drag all the files into your Xcode project

## Getting Started
Creating a new `OMChainWallet` object is easy! Simply import your header file, conform your class to the `OMChainDelegate` and add:
```objc
OMChainWallet *wallet = [[OMChainWallet alloc] initWithUsername:@"username" password:@"password" success:nil failed:nil];
```
From there you can send whatever messages you need to your newly created `wallet` object. Make sure your `wallet` object is initialized with a username and password before you start sending `wallet_*` messages; not doing so will result in a crash. To avoid this, put all the code you want to run inside the `success block`.

##Example
In this example, I will sign into a fake account and change its email address:
```objc
OMChainWallet *exampleWallet = [[OMChainWallet alloc] initWithUsername:@"username" password:@"password" success:^(OMChainWallet *wallet) {
	[exampleWallet changeEmailForAccountWithNewEmail:@"username@domain.com" success:^{
		NSLog(@"Success!");
	} failed:nil];
} failure:nil];
```
-
In this example, I will sign into a fake account. If the sign in is successfull it'll retrieve the Omnicha.in rich list, if retrieving the rich list fails, the message "Failed getting the rich list." is logged, otherwise it'll log the contents of the rich list. If the sign in fails, it'll check if the error was "BAD_LOGIN" and if it was it'll log "Username or password incorrect."
```objc
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
```
