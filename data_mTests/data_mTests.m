//
//  data_mTests.m
//  data_mTests
//
//  Created by Mike Savchenko on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "data_mTests.h"
#import <OCMock/OCMock.h>
#import <objc/runtime.h>
#import "MyDocument.h"


@implementation data_mTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testAppDelegate
{
	id appDelegate = [[NSApplication sharedApplication] delegate];
	STAssertTrue([appDelegate isKindOfClass:[NSPersistentDocument class]],
                 @"Cannot find the application delegate.");
}

- (void)testApplicationWillTerminate
{
    MyDocument *appDelegate =
    [[[MyDocument alloc] init] autorelease];
    
    id mockWindowController = [OCMockObject mockForClass:[NSPersistentDocument class]];
    [mockWindowController retain];
    object_setInstanceVariable(appDelegate, "windowController", mockWindowController);
    
    NSUInteger preRetainCount = [mockWindowController retainCount];
    [[mockWindowController expect] close];
    
    [appDelegate applicationWillTerminate:nil];
    
    [mockWindowController verify];
    
    NSUInteger postRetainCount = [mockWindowController retainCount];
    STAssertEquals(postRetainCount, preRetainCount, @"Window controller not released");
    
    id windowController;
    object_getInstanceVariable(appDelegate, "windowController", (void **)&windowController);
    STAssertNil(windowController, @"Window controller property not set to nil");
}

@end
