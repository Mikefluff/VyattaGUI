//
//  graph_controller.h
//  yuba-test
//
//  Created by Mike Fluff on 24.12.10.
//  Copyright 2010 Altell ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YBGraphView.h"
#import "AMShellWrapper.h"

@interface graph_controller : NSObject <YBGraphViewDataSource, YBGraphViewDelegate, AMShellWrapperController> {
	IBOutlet NSWindow *window;
	IBOutlet NSView *curview;
	IBOutlet YBGraphView *graphView;
	IBOutlet NSTextField *address;
	IBOutlet NSButton *runButton;
	IBOutlet NSProgressIndicator *progressIndicator;
	NSMutableArray *data;
	NSMutableArray *count;
	AMShellWrapper *shellWrapper;
}

@property (nonatomic, retain) NSWindow *window;
@property (nonatomic, retain) NSView *curview;
@property (nonatomic, retain) YBGraphView *graphView;
@property (nonatomic, retain) NSTextField *address;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *count;
- (IBAction) start:sender;
- (IBAction)stopTask:(id)sender;

- (AMShellWrapper *)shellWrapper;
- (void)setShellWrapper:(AMShellWrapper *)newShellWrapper;


// ============================================================
// conforming to the AMShellWrapperController protocol:
// ============================================================

- (void)appendOutput:(NSString *)output;
// output from stdout

- (void)appendError:(NSString *)error;
// output from stderr

- (void)processStarted:(id)sender;
// This method is a callback which your controller can use to do other initialization
// when a process is launched.

- (void)processFinished:(id)sender withTerminationStatus:(int)resultCode;
// This method is a callback which your controller can use to do other cleanup
// when a process is halted.


@end
