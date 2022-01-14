//
//  CanaryHomeworkTests.m
//  CanaryHomeworkTests
//
//  Created by Bryan Cuevas on 1/13/22.
//  Copyright © 2022 Michael Schroeder. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreDataController.h"
#import "APIClient.h"



@interface CanaryHomeworkTests : XCTestCase

@end

@implementation CanaryHomeworkTests

#pragma mark Block Testing
#define TestNeedsToWaitForBlock() __block BOOL blockFinished = NO
#define BlockFinished() blockFinished = YES
#define WaitForBlock() while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !blockFinished)

//Test for getting all devices from API
-(void) testAPIGetAllDevice {
    TestNeedsToWaitForBlock();
    [[APIClient sharedClient] getDeviceWithCompletionBlock:^(BOOL success, id responseObject) {
        XCTAssertTrue(success);
        XCTAssertNotNil(responseObject);
        
        BlockFinished();
    }];
    WaitForBlock();
}
//Test for getting all readings from a device from API
-(void) testAPIGetDeviceReadings {
    TestNeedsToWaitForBlock();
    [[APIClient sharedClient] getDevice:@"2" readingsWithCompletionBlock:^(BOOL success, id responseObject) {
        XCTAssertTrue(success);
        XCTAssertNotNil(responseObject);
        BlockFinished();
    }];
    WaitForBlock();
}

//Test for getting all devices from CoreDataController
-(void) testCoreDataControllerGetDevices{
    TestNeedsToWaitForBlock();
    [[CoreDataController sharedCache] getAllDevices:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        XCTAssertTrue(success);
        XCTAssertTrue(completed);
        XCTAssertTrue(objects.count > 0);
        BlockFinished();
    }];
    WaitForBlock();
}
//Test for getting device readings
-(void) testCoreDataGetDeviceReadings{
    TestNeedsToWaitForBlock();
    [[CoreDataController sharedCache] getReadingsForDevice:@"2" completionBlock:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        XCTAssertTrue(success);
        XCTAssertTrue(completed);
        XCTAssertTrue(objects.count > 0);
        BlockFinished();
    }];
    WaitForBlock();
}

@end
