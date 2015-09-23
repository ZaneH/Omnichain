//
//  LoginViewController.m
//  Omnichain
//
//  Created by Zane Helton on 9/23/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+OMCBranding.h"
#import "AccountManager.h"

@interface LoginViewController () {
	UIActivityIndicatorView *indicator;
}

@end

@implementation LoginViewController
@synthesize loginButton, usernameTextField, passwordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
	// customizing the buttons
	loginButton.layer.cornerRadius = 4;
	
	loginButton.layer.shadowRadius = 10;
	loginButton.layer.shadowOpacity = 0.75;
	loginButton.layer.shadowColor = [UIColor blackColor].CGColor;
	
	loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
	[loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	loginButton.backgroundColor = [UIColor mainPurpleColor];

	// iOS 7 'Floaty Effect'
	UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	UIInterpolatingMotionEffect *verticalMotionEffect   = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	horizontalMotionEffect.minimumRelativeValue = @(-15);
	horizontalMotionEffect.maximumRelativeValue = @(15);
	verticalMotionEffect.minimumRelativeValue   = @(-15);
	verticalMotionEffect.maximumRelativeValue   = @(15);
	[loginButton setMotionEffects:@[horizontalMotionEffect, verticalMotionEffect]];
	
	// customizing the text fields
	CALayer *usernameBottomStand = [CALayer layer];
	usernameBottomStand.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
	usernameBottomStand.frame = CGRectMake(0, usernameTextField.frame.size.height - 1, usernameTextField.frame.size.width, 1);
	[usernameTextField.layer addSublayer:usernameBottomStand];
	usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your username" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.5]}];
	usernameTextField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
	
	CALayer *passwordBottomStand = [CALayer layer];
	passwordBottomStand.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
	passwordBottomStand.frame = CGRectMake(0, passwordTextField.frame.size.height - 1, passwordTextField.frame.size.width, 1);
	[passwordTextField.layer addSublayer:passwordBottomStand];
	passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.5]}];
	passwordTextField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
	
	// setup keyboard navigation
	usernameTextField.delegate = self;
	passwordTextField.delegate = self;
	
	// setup loading indicator
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[indicator setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 30, 5, 30, 30)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([usernameTextField isFirstResponder]) {
		[usernameTextField resignFirstResponder];
		[passwordTextField becomeFirstResponder];
	} else if ([passwordTextField isFirstResponder]) {
		[passwordTextField resignFirstResponder];
		[self login];
	}
	return NO;
}

- (IBAction)loginButtonTapped:(UIButton *)sender {
	[self login];
}

- (void)login {
	[loginButton setTitle:@"" forState:UIControlStateNormal];
	[loginButton addSubview:indicator];
	[indicator setHidesWhenStopped:YES];
	[indicator startAnimating];
	
	[[AccountManager sharedInstance] loginWithUsername:usernameTextField.text
											  password:passwordTextField.text
											   success:^{
												   [indicator stopAnimating];
												   [loginButton setTitle:@"Login" forState:UIControlStateNormal];
												   // TODO: Take to wallet view
											   } failure:^(OMChainWallet *wallet, NSString *error) {
												   [indicator stopAnimating];
												   [loginButton setTitle:@"Login" forState:UIControlStateNormal];
												   
												   UIAlertController *errorController = [UIAlertController alertControllerWithTitle:@"Sign In Error" message:error preferredStyle:UIAlertControllerStyleAlert];
												   UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
													   [errorController dismissViewControllerAnimated:YES completion:nil];
												   }];
												   [errorController addAction:dismissAction];
												   [self presentViewController:errorController animated:YES completion:nil];
											   }];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[AccountManager sharedInstance] stopCurrentRequest];
}

@end
