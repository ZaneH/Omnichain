//
//  LoginTests.m
//  Omnichain
//
//  Created by Zane Helton on 9/22/15.
//  Copyright © 2015 Zane Helton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <KIF/KIF.h>

@interface LoginTests : KIFTestCase

@end

@implementation LoginTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBadLoginShouldPresentError {
	
}

@end
