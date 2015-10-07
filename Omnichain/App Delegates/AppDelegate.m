//
//  AppDelegate.m
//  Omnichain
//
//  Created by Zane Helton on 9/22/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+OMCBranding.h"
#import "AccountManager.h"
#import <SSKeychain/SSKeychain.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[[UITextField appearance] setTintColor:[UIColor mainPurpleColor]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18.0f]}];
	[SSKeychain deletePasswordForService:@"Omnichain" account:[[[SSKeychain accountsForService:@"Omnichain"] objectAtIndex:0] valueForKey:@"acct"]];
	return YES;
}

@end
