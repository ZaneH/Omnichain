//
//  SignUpViewController.m
//  Omnichain
//
//  Created by Zane Helton on 9/23/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import "SignUpViewController.h"
#import "UIColor+OMCBranding.h"
#import "AccountManager.h"

@interface SignUpViewController () {
	UIActivityIndicatorView *indicator;
}

@end

@implementation SignUpViewController
@synthesize usernameTextField, passwordTextField, confirmPasswordTextField, signUpButton, cancelButton;

- (void)viewDidLoad {
    [super viewDidLoad];
	// customizing the buttons
	signUpButton.layer.cornerRadius = 4;
	
	signUpButton.layer.shadowRadius = 10;
	signUpButton.layer.shadowOpacity = 0.75;
	signUpButton.layer.shadowColor = [UIColor blackColor].CGColor;
	
	signUpButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
	[signUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	signUpButton.backgroundColor = [UIColor mainPurpleColor];
	
	cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
	[cancelButton setTitleColor:[UIColor mainPurpleColor] forState:UIControlStateNormal];
	
	// iOS 7 'Floaty Effect'
	UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	UIInterpolatingMotionEffect *verticalMotionEffect   = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	horizontalMotionEffect.minimumRelativeValue = @(-15);
	horizontalMotionEffect.maximumRelativeValue = @(15);
	verticalMotionEffect.minimumRelativeValue   = @(-15);
	verticalMotionEffect.maximumRelativeValue   = @(15);
	[signUpButton setMotionEffects:@[horizontalMotionEffect, verticalMotionEffect]];
	
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
	
	CALayer *confirmPasswordBottomStand = [CALayer layer];
	confirmPasswordBottomStand.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
	confirmPasswordBottomStand.frame = CGRectMake(0, confirmPasswordTextField.frame.size.height - 1, confirmPasswordTextField.frame.size.width, 1);
	[confirmPasswordTextField.layer addSublayer:confirmPasswordBottomStand];
	confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm your password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.5]}];
	confirmPasswordTextField.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
	
	// setup keyboard navigation
	usernameTextField.delegate = self;
	passwordTextField.delegate = self;
	confirmPasswordTextField.delegate = self;
	
	// setup loading indicator
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[indicator setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 30, 5, 30, 30)];
}

- (IBAction)signUpButtonTapped:(UIButton *)sender {
	[self signUp];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([usernameTextField isFirstResponder]) {
		[usernameTextField resignFirstResponder];
		[passwordTextField becomeFirstResponder];
	} else if ([passwordTextField isFirstResponder]) {
		[passwordTextField resignFirstResponder];
		[confirmPasswordTextField becomeFirstResponder];
	} else if ([confirmPasswordTextField isFirstResponder]) {
		[confirmPasswordTextField resignFirstResponder];
		[self signUp];
	}
	return NO;
}

- (void)signUp {
	if (![passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
		// confirmation password and original password don't match
		UIAlertController *passwordMismatchAlertController = [UIAlertController alertControllerWithTitle:@"Password Mismatch"
																								 message:@"Your passwords don't match."
																						  preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * _Nonnull action) {
																  [passwordMismatchAlertController dismissViewControllerAnimated:YES completion:nil];
															  }];
		[passwordMismatchAlertController addAction:dismissAction];
		[self presentViewController:passwordMismatchAlertController animated:YES completion:nil];
	}
	
	[[AccountManager sharedInstance] signUpWithUsername:usernameTextField.text
											   password:passwordTextField.text];
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
