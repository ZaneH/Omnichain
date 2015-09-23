//
//  SignInViewController.m
//  Omnichain
//
//  Created by Zane Helton on 9/23/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import "SignInViewController.h"
#import "UIColor+OMCBranding.h"
#import "AccountManager.h"

@interface SignInViewController () {
	UIActivityIndicatorView *indicator;
}

@end

@implementation SignInViewController
@synthesize loginButton, cancelButton, usernameTextField, passwordTextField;

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
	
	cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
	[cancelButton setTitleColor:[UIColor mainPurpleColor] forState:UIControlStateNormal];
	
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
		[self signIn];
		[passwordTextField resignFirstResponder];
	}
	return NO;
}

- (IBAction)loginButtonTapped:(UIButton *)sender {
	[self signIn];
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn {
	[loginButton setTitle:@"" forState:UIControlStateNormal];
	[loginButton addSubview:indicator];
	[indicator setHidesWhenStopped:YES];
	[indicator startAnimating];
	
	if ([[AccountManager sharedInstance] signInWithUsername:usernameTextField.text password:passwordTextField.text]) {
		[indicator stopAnimating];
		[loginButton setTitle:@"Login" forState:UIControlStateNormal];
		NSLog(@"Successfully logged in.");
		// TODO: Take to wallets view
	} else {
		[indicator stopAnimating];
		[loginButton setTitle:@"Login" forState:UIControlStateNormal];
		UIAlertController *errorController = [UIAlertController alertControllerWithTitle:@"Sign In Error" message:@"Your username or password is incorrect." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[errorController dismissViewControllerAnimated:YES completion:nil];
		}];
		[errorController addAction:dismissAction];
		[self presentViewController:errorController animated:YES completion:nil];
	}
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
