//
//  HomeViewController.m
//  Omnichain
//
//  Created by Zane Helton on 9/22/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor+OMCBranding.h"
#import "AccountManager.h"
#import <SSKeychain/SSKeychain.h>

@interface HomeViewController () {
	UIActivityIndicatorView *_activityIndicatorView;
	UIView *_grayView;
}

@end

@implementation HomeViewController
@synthesize signUpButton, loginButton;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// checks if the user has already signed in AND pressed "Save Password"
	// takes the user to the wallet view controller if an account was found
	if ([SSKeychain accountsForService:@"Omnichain"]) {
		_grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		[_grayView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
		
		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		[_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[_activityIndicatorView startAnimating];
		
		[self.view addSubview:_grayView];
		[self.view addSubview:_activityIndicatorView];
		
		[[AccountManager sharedInstance] loginWithUsername:[[[SSKeychain accountsForService:@"Omnichain"] firstObject] valueForKey:@"acct"]
												  password:[SSKeychain passwordForService:@"Omnichain" account:[[[SSKeychain accountsForService:@"Omnichain"] firstObject] valueForKey:@"acct"]]
												   success:^{
													   [_grayView removeFromSuperview];
													   [_activityIndicatorView removeFromSuperview];
													   [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"myWalletVC"] animated:YES completion:nil];
												   } failure:^(OMChainWallet *wallet, NSString *error) {
													   // maybe the user changed their password
													   // and now the keychain is outdated
													   [_grayView removeFromSuperview];
													   [_activityIndicatorView removeFromSuperview];
												   }];
	}
	
	// customizing the buttons
	signUpButton.layer.cornerRadius = 4;
	
	signUpButton.layer.shadowRadius = 10;
	signUpButton.layer.shadowOpacity = 0.75;
	signUpButton.layer.shadowColor = [UIColor blackColor].CGColor;
	
	// iOS 7 'Floaty Effect'
	UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	UIInterpolatingMotionEffect *verticalMotionEffect   = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	horizontalMotionEffect.minimumRelativeValue = @(-15);
	horizontalMotionEffect.maximumRelativeValue = @(15);
	verticalMotionEffect.minimumRelativeValue   = @(-15);
	verticalMotionEffect.maximumRelativeValue   = @(15);
	[signUpButton setMotionEffects:@[horizontalMotionEffect, verticalMotionEffect]];
	
	signUpButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
	[signUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	signUpButton.backgroundColor = [UIColor mainPurpleColor];
	
	loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
	[loginButton setTitleColor:[UIColor mainPurpleColor] forState:UIControlStateNormal];
}

@end
