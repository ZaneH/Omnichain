//
//  LoginTests.m
//  Omnichain
//
//  Created by Zane Helton on 9/23/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import <KIF/KIF.h>

@interface LoginTests : KIFTestCase

@end

@implementation LoginTests

- (void)testBadLoginShouldAlertUser {
	// I don't know if I have to wait here, but better safe than sorry
	[tester waitForTappableViewWithAccessibilityLabel:@"Login"];
	[tester tapViewWithAccessibilityLabel:@"Login"];
	
	[tester enterText:@"blank" intoViewWithAccessibilityLabel:@"Login user name"];
	[tester enterText:@"blank" intoViewWithAccessibilityLabel:@"Login password"];
	[tester tapViewWithAccessibilityLabel:@"Login" traits:UIAccessibilityTraitButton];
	
	[tester waitForViewWithAccessibilityLabel:@"Username or password is incorrect."];
	[tester tapViewWithAccessibilityLabel:@"Dismiss"];
}

- (void)testSignUpMismatchedPasswordsShouldAlertUser {
	[tester tapViewWithAccessibilityLabel:@"Back"];
	[tester tapViewWithAccessibilityLabel:@"Sign up"];
	
	[tester enterText:@"test_name" intoViewWithAccessibilityLabel:@"Sign up user name"];
	[tester enterText:@"test_password" intoViewWithAccessibilityLabel:@"Sign up password"];
	[tester enterText:@"test_drowssap" intoViewWithAccessibilityLabel:@"Sign up confirm password"];
	[tester tapViewWithAccessibilityLabel:@"Sign Up" traits:UIAccessibilityTraitButton];
	
	[tester waitForViewWithAccessibilityLabel:@"Password Mismatch"];
	[tester tapViewWithAccessibilityLabel:@"Dismiss"];
}

- (void)testBlankFieldShouldAlertUser {
	// login
	[tester clearTextFromViewWithAccessibilityLabel:@"Login user name"];
	[tester clearTextFromViewWithAccessibilityLabel:@"Login password"];
	[tester tapViewWithAccessibilityLabel:@"Login" traits:UIAccessibilityTraitButton];
	[tester waitForViewWithAccessibilityLabel:@"One or more fields have been left empty."];
	[tester tapViewWithAccessibilityLabel:@"Dismiss"];
	
	// transition from login to sign up
	[tester tapViewWithAccessibilityLabel:@"Back"];
	[tester tapViewWithAccessibilityLabel:@"Sign up" traits:UIAccessibilityTraitButton];
	
	// sign up
	[tester clearTextFromViewWithAccessibilityLabel:@"Sign up user name"];
	[tester clearTextFromViewWithAccessibilityLabel:@"Sign up password"];
	[tester clearTextFromViewWithAccessibilityLabel:@"Sign up confirm password"];
	[tester tapViewWithAccessibilityLabel:@"Sign Up" traits:UIAccessibilityTraitButton];
	
	[tester waitForViewWithAccessibilityLabel:@"One or more fields have been left empty."];
	[tester tapViewWithAccessibilityLabel:@"Dismiss"];
}

- (void)testTakenUsernameShouldAlertUser {
	[tester clearTextFromAndThenEnterText:@"blank" intoViewWithAccessibilityLabel:@"Sign up user name"];
	[tester clearTextFromAndThenEnterText:@"blank-password" intoViewWithAccessibilityLabel:@"Sign up password"];
	[tester clearTextFromAndThenEnterText:@"blank-password" intoViewWithAccessibilityLabel:@"Sign up confirm password"];
	[tester tapViewWithAccessibilityLabel:@"Sign Up" traits:UIAccessibilityTraitButton];
	
	[tester waitForViewWithAccessibilityLabel:@"This username has already been taken."];
	[tester tapViewWithAccessibilityLabel:@"Dismiss"];
}

@end
