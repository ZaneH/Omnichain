//
//  ViewController.m
//  Omnichain
//
//  Created by Zane Helton on 9/22/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+OMCBranding.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize signUpButton, loginButton;

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
	
	loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
	[loginButton setTitleColor:[UIColor mainPurpleColor] forState:UIControlStateNormal];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
