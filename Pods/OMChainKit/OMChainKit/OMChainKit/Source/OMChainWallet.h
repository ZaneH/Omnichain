//
//  OMChainWallet.h
//  OMChainKit
//
//  Created by Zane Helton on 3/15/15.
//  Copyright (c) 2015 ZaneHelton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "OMChainAddress.h"
#import "OMChainTransaction.h"

@protocol OMChainDelegate;

@interface OMChainWallet : NSObject <NSURLConnectionDelegate>

// typedef definitions. Excuse the excess definitions, it's easier for me to be verbose
typedef void (^SignInSuccess)(OMChainWallet *wallet);
typedef void (^OmnichainFailed)(OMChainWallet *wallet, NSString *error);
typedef void (^SignMessageSuccess)(NSString *address, NSString *message, NSString *signature);
typedef void (^AddressCreateSuccess)(NSString *address);
typedef void (^GetInfoComplete)(NSDictionary *data, NSString *error);
typedef void (^GetBalanceComplete)(NSString *address, double balance, NSString *error);
typedef void (^IsValidAddressComplete)(NSString *address, BOOL isValid, NSString *error);
typedef void (^IsValidSignatureComplete)(NSString *address, NSString *message, NSString *signature, BOOL isVerified, NSString *error);
typedef void (^GetRichListComplete)(NSArray *data, NSString *error);
typedef void (^GetStatsComplete)(NSDictionary *data, NSString *error);
typedef void (^GetCalculatedEarningsComplete)(double hashrate, double difficulty, NSDictionary *data, NSString *error);

typedef void (^RegisterSuccess)();
typedef void (^ChangeEmailSuccess)();
typedef void (^ChangePasswordSuccess)();
typedef void (^SendOmnicoinSuccess)();
typedef void (^GenerateAddressSuccess)(NSString *address);

#pragma mark - Properties

// User Info
/**
 *  The session token after a wallet is signed in
 */
@property (copy) NSString *sessionToken;
/**
 *  The email address assigned to the account (most often is blank)
 */
@property (copy) NSString *emailAddress;
/**
 *  The username of the current wallet user
 */
@property (copy) NSString *username;
/**
 *  The password used to verify an account (hashed with SHA512)
 */
@property (copy) NSString *passwordHash;


// Money Info
/**
 *  The balance of the wallet
 */
@property (assign) double balance;
/**
 *  The balance pending for the account
 */
@property (assign) double pendingBalance;
/**
 *  An array containing all the addresses for an account
 */
@property (nonatomic, strong) NSMutableArray *addresses;
/**
 *  A bool determining if the address is valid or not
 */
@property (assign) BOOL validAddress;


// Stats
/**
 *  Transactions that have been sent (1+ per transaction)
 */
@property (nonatomic) NSInteger transactionsOut;
/**
 *  Transactions that have been recieved (1+ per transaction)
 */
@property (nonatomic) NSInteger transactionsIn;
/**
 *  Total amount of OMC sent out
 */
@property (assign) double totalOut;
/**
 *  Total amount of OMC in
 */
@property (assign) double totalIn;
/**
 *  An array containing the transactions of the user
 */
@property (nonatomic, strong) NSMutableArray *transactions;
/**
 *  The conversion rate for 1 OMC -> USD
 */
@property (assign) double omcUSDValue;
/**
 *  Current version of the API
 */
@property (copy) NSString *version;


// Delegates
/**
 *  Delegate used to call errors, and successes
 */
@property (nonatomic, weak) id<OMChainDelegate> delegate;

#pragma mark -

#pragma mark - Initializers

/**
 *  Initializes a new wallet
 *
 *  @param username A string containing the username of the account
 *  @param password A string containing the plain text password of an account
 *
 *  @return A new wallet object
 */
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(OMChainWallet *wallet))successBlock failure:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

/**
 *  A method that returns a blank Omnicoin wallet
 *
 *  @return An empty wallet
 */
- (instancetype)init;

#pragma mark -

#pragma mark - Configuration Methods

- (void)setTimout:(NSUInteger)timeOut;

#pragma mark -

#pragma mark - Mostly Statistics API Interaction Method Declarations

/**
 *  getinfo: Returns misc information like difficulty, mining speed, and average block time
 */
- (void)omcGetInfoWithCompletionHandler:(void (^)(NSDictionary *info, NSString *error))ch;

/**
 *  getbalance: Returns the value of an Omnicoin address
 *
 *  @param address The address you'd like to value
 */
- (void)omcGetBalanceWithAddress:(NSString *)address
			   completionHandler:(void (^)(NSString *address, double balance, NSString *error))ch;

/**
 *  checkaddress: A BOOL saying whether it's a real address or not
 *
 *  @param address The address you'd like to test
 */
- (void)omcCheckAddressWithAddress:(NSString *)address
				 completionHandler:(void (^)(NSString *address, BOOL isValid, NSString *error))ch;

/**
 *  verifymessage: Returns whether the specified signature is as valid hash for the specified message for the specified address
 *
 *  @param address   The Omnicoin address
 *  @param message   The message that was signed
 *  @param signature The signature generated from signing mesage with address
 */
- (void)omcVerifyMessageWithAddress:(NSString *)address
							message:(NSString *)message
						  signature:(NSString *)signature
				  completionHandler:(void (^)(NSString *address, NSString *message, NSString *signature, BOOL isVerified, NSString *error))ch;

/**
 *  getrichlists: Returns data for generating the richlist on https://omnicha.in/richlist/
 */
- (void)omcGetRichListWithCompletionHandler:(void (^)(NSArray *richList, NSString *error))ch;

/**
 *  getwstats: Returns total users and total balance of all online wallet accounts
 */
- (void)omcGetStatsWithCompletionHandler:(void (^)(NSDictionary *stats, NSString *error))ch;

/**
 *  earningscalc: The earningscalc method retuns the amount of OMC that will be mined with the specified hashrate
 *
 *  @param hashrate The hashrate in MH/s
 */
- (void)omcCalculateEarningsWithHashrate:(double)hashrate
					   completionHandler:(void (^)(double hashrate, double difficulty, NSDictionary *data, NSString *error))ch;

/**
 *  earningscalc: The earningscalc method returns the amount of OMC that will be mined with the specified hashrate and difficulty
 *
 *  @param hashrate   The hashrate in MH/s
 *  @param difficulty The difficulty to base calculations on
 */
- (void)omcCalculateEarningsWithHashrate:(double)hashrate
							  difficulty:(double)difficulty
					   completionHandler:(void (^)(double hashrate, double difficulty, NSDictionary *data, NSString *error))ch;

#pragma mark -

#pragma mark - API Interaction Method Declarations

/**
 *  Fills in the wallet properties
 */
- (void)refreshWalletInfo;

/**
 *  Attempts to sign in with a wallet
 *
 *  @param wallet       Initialized wallet with username and password
 */
- (void)attemptSignInWithSuccess:(void (^)())successBlock
						  failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

/**
 *  Registers a new account with Omnicha.in
 *
 *  @param username        The username to register the account under
 *  @param password        Password in plain text
 *  @param confirmPassword Password again in plain text (optional)
 */
- (void)registerAccountWithUsername:(NSString *)username
						   password:(NSString *)password
					confirmPassword:(NSString *)confirmPassword
							success:(void (^)())successBlock failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

/**
 *  Registers a new account with Omnicha.in
 *
 *  @param username        The username to register the account under
 *  @param password        Password in plain text
 */
- (void)registerAccountWithUsername:(NSString *)username
						   password:(NSString *)password
							success:(void (^)())successBlock
							 failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

/**
 *  Creates an API request with specified values
 *
 *  @param method    The Omnicha.in API method to call
 *  @param params An NSDictionary containing the keys and values to pass to the API
 */
- (void)createAPIRequestWithMethod:(NSString *)method
							params:(NSDictionary *)params;

/**
 *  Changes the users email address
 *
 *  @param email The new email address
 */
- (void)changeEmailForAccountWithNewEmail:(NSString *)email
								  success:(void (^)())successBlock
								   failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

/**
 *  Changes the users password
 *
 *  @param password        Password in plain text
 *  @param confirmPassword Password again in plain text (optional)
 */
- (void)changePasswordForAccountWithNewPassword:(NSString *)password
								confirmPassword:(NSString *)confirmPassword
										success:(void (^)())successBlock
										 failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

/**
 *  Changes the users password
 *
 *  @param password Password in plain text
 */
- (void)changePasswordForAccountWithNewPassword:(NSString *)password
										success:(void (^)())successBlock
										 failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

/**
 *  Signs a message with the specified address
 *
 *  @param address A valid Omnicoin address
 *  @param message The message to sign
 */
- (void)signMessageWithAddress:(NSString *)address message:(NSString *)message
					   success:(void (^)(NSString *address, NSString *message, NSString *signature))successBlock
						failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

/**
 *  Imports a private key into Omnicha.in (currently disabled)
 *
 *  @param privateKey The private key you want to import
 */
/*- (void)importPrivateKeyWithKey:(NSString *)privateKey
						address:(NSString *)address __attribute__((deprecated));*/

/**
 *  Sends Omnicoin to an address
 *
 *  @param address Address to send Omnicoin to
 *  @param amount  The amount of Omnicoin to send to the address
 */
- (void)sendOmnicoinToAddress:(NSString *)address
					   amount:(double)amount success:(void (^)())successBlock
					   failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

/**
 *  Generates a new Omnicoin address
 */
- (void)generateNewAddressWithSuccess:(void (^)(NSString *address))successBlock
							   failed:(void (^)(OMChainWallet *wallet, NSString *error))failureBlock;

#pragma mark -

@end

@protocol OMChainDelegate <NSObject>

@optional
/**
 *  Is called whenever the Omnicha.in API returns an error
 *
 *  @param wallet The wallet the method failed with
 *  @param error  The error code
 */
- (void)omnichainFailedWithWallet:(OMChainWallet *)wallet error:(NSString *)error;

/**
 *  Called whenever the OMChainWallet object is successfully created
 *
 *  @param wallet The wallet the method passed with
 *  @param method Method that succeeded
 */
- (void)omnichainSucceededWithWallet:(OMChainWallet *)wallet method:(NSString *)method __attribute__((deprecated));

/**
 *  Called whenever an address is successfully signed
 *
 *  @param address   Address that was signed
 *  @param message   Message for the address
 *  @param signature The signature that was returned
 */
- (void)signedMessageSuccessfullyWithAddress:(NSString *)address message:(NSString *)message signature:(NSString *)signature __attribute__((deprecated));

/**
 *  Called whenever an address is successfully created
 *
 *  @param address The address that was created
 */
- (void)successfullyCreatedOmnicoinAddressWithAddress:(NSString *)address __attribute__((deprecated));

/**
 *  Called whenever the getinfo method is called successfully
 *
 *  @param data A dictionary containing the response data. Ex. usage: [data valueForKey:@"block_count"];
 */
- (void)gotInfoFromOmnichainSuccessfullyWithData:(NSDictionary *)data __attribute__((deprecated));

/**
 *  Called whenever the delegate recieves knowledge on how much an address contains
 *
 *  @param address The address that the value belongs to
 *  @param balance The value belonging to the address
 */
- (void)gotBalanceFromOmnichainWithAddress:(NSString *)address balance:(double)balance __attribute__((deprecated));

/**
 *  Called whenever the delegate recieves knowledge whether or not the Omnicoin address is valid or not
 *
 *  @param address        Address checked
 *  @param isValidAddress Boolean determining if it's a real address or not
 */
- (void)gotIsValidAddressFromOmnichainWithAddress:(NSString *)address isValidAddress:(BOOL)isValidAddress __attribute__((deprecated));

/**
 *  Determines if a signed address is valid with a message (still have no idea what this is for)
 *
 *  @param address    Address verified
 *  @param message    Message attached
 *  @param signature  Signature generated
 *  @param isVerified Whether or not this is a valid combo
 */
- (void)gotIsValidSignedAddressWithAddress:(NSString *)address message:(NSString *)message signature:(NSString *)signature isVerified:(BOOL)isVerified __attribute__((deprecated));

/**
 *  Gets the list of Omnicha.in's richest users
 *
 *  @param data An array of all the users containing an NSDictionary for each
 */
- (void)gotRichListFromOmnichainWithData:(NSArray *)data __attribute__((deprecated));

/**
 *  Called whenever the delegate knows about the current "wstats"
 *
 *  @param data An NSDictionary containing values for "users" and "balance" (balance of all users)
 */
- (void)gotStatsFromOmnichainWithData:(NSDictionary *)data __attribute__((deprecated));

/**
 *  Called whenever the delegate knows how much a users might earn in a day, week, month, & year
 *
 *  @param hashrate   The hashrate passed in the method
 *  @param difficulty The difficulty passed in the method (can't be returned if not specified)
 *  @param data       Dictionary containing keys for day, week, month, & year
 */
- (void)gotCalculatedEarningsFromOmnichainWithHashrate:(double)hashrate difficulty:(double)difficulty data:(NSDictionary *)data __attribute__((deprecated));

@end