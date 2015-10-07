//
//  WalletViewController.m
//  Omnichain
//
//  Created by Zane Helton on 9/27/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import "WalletViewController.h"
#import "AccountManager.h"

@interface WalletViewController ()

@property (nonatomic, weak) IBOutlet UITableView *transactionsTableView;

@end

@implementation WalletViewController
@synthesize transactionsTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
	[transactionsTableView setDelegate:self];
	[transactionsTableView setDataSource:self];
	
	UIBarButtonItem *settingsIcon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonPressed:)];
	[self.navigationItem setLeftBarButtonItem:settingsIcon];
}

- (void)settingsButtonPressed:(UIBarButtonItem *)sender {
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		NSInteger transactionsIn = [[[AccountManager sharedInstance] userWallet] transactionsIn];
		return transactionsIn;
	} else if (section == 1) {
		NSInteger transactionsOut = [[[AccountManager sharedInstance] userWallet] transactionsOut];
		return transactionsOut;
	} else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell" forIndexPath:indexPath];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transactionCell"];
	}
	
	
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Transactions In";
	} else {
		return @"Transactions Out";
	}
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
