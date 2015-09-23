//
//  HomeViewController.m
//  Omnichain
//
//  Created by Zane Helton on 9/22/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor+OMCBranding.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize signUpButton, loginButton;

- (void)viewDidLoad {
	[super viewDidLoad];
	
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
