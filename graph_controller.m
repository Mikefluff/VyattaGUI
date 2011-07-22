//
//  graph_controller.m
//  yuba-test
//
//  Created by Mike Fluff on 24.12.10.
//  Copyright 2010 Altell ltd. All rights reserved.
//

#import "graph_controller.h"



@implementation graph_controller

@synthesize graphView, curview, window, data, count;

- (AMShellWrapper *)shellWrapper
{
	return shellWrapper;
}

- (void)setShellWrapper:(AMShellWrapper *)newShellWrapper
{
	id old = nil;
	
	if (newShellWrapper != shellWrapper) {
		old = shellWrapper;
		shellWrapper = [newShellWrapper retain];
		[old release];
	}
}




- (NSInteger)numberOfGraphsInGraphView:(YBGraphView *)graph {

	return 2;

}

- (NSArray *)graphView:(YBGraphView *)graph valuesForGraph:(NSInteger)index {
	
//	NSString *returnString = [NSString stringWithFormat:@"%d", data];
	
//	self.list1 = [[NSArray alloc] initWithObjects:@"10",returnString,@"30",@"4",@"5",nil];
	
//	data = data + 5;
	
//	list1 = [NSArray arrayWithArray:data];
    return data;
	
}

- (NSArray *)seriesForGraphView:(YBGraphView *)graph {

//	self.list2 = [[NSArray alloc] initWithObjects:@"1s",@"2s",@"3s",@"4s",@"5s",nil];
	
//	list2 = [NSArray arrayWithArray:count];
//	return list2;
	return count;
	
	
}


- (void)awakeFromNib {

	NSLog(@"test");
	data = [[NSMutableArray alloc] init];
	count = [[NSMutableArray alloc] init];

}

- (IBAction) start:(id)sender {
	[curview addSubview:graphView];
	NSArray *arguments;
//	arguments = [[address stringValue] componentsSeparatedByString:@" "];
	arguments = [[NSArray alloc] initWithObjects:@"/sbin/ping",[address stringValue],nil];
	[self setShellWrapper:[[AMShellWrapper alloc] initWithController:self inputPipe:nil outputPipe:nil errorPipe:nil workingDirectory:@"." environment:nil arguments:arguments]];
	
	NS_DURING
	if (shellWrapper) {
		[shellWrapper setOutputStringEncoding:NSASCIIStringEncoding];
		[shellWrapper startProcess];
	}
	NS_HANDLER
	NSLog(@"Caught %@: %@", [localException name], [localException reason]);
	[self processLaunchException:localException];
	NS_ENDHANDLER	
}

- (IBAction)stopTask:(id)sender
{
	[shellWrapper stopProcess];
	data = [[NSMutableArray alloc] init];
	count = [[NSMutableArray alloc] init];
}



- (void)write:(NSString *)string
{
	NSString *resultString;
	
	[string getCapturesWithRegexAndReferences:@"time=(\\d+\\.\\d+)", @"$1", &resultString,nil];
	
	[data addObject:resultString];
	NSString *index = [NSString stringWithFormat:@"%d", [data count]];
	[count addObject:index];
	
		
	
	[graphView draw];
	[window display];
}
	



// ============================================================
// conforming to the AMShellWrapperController protocol:
// ============================================================

// output from stdout
- (void)appendOutput:(NSString *)output
{
	[self write:output];
}

// output from stderr
- (void)appendError:(NSString *)error
{
//	[errorOutlet setString:[[errorOutlet string] stringByAppendingString:error]];
}

// This method is a callback which your controller can use to do other initialization
// when a process is launched.
- (void)processStarted:(id)sender
{
	[progressIndicator startAnimation:self];
	[runButton setTitle:@"Stop"];
	[address setAction:@selector(stopTask:)];
	[runButton setAction:@selector(stopTask:)];
}

// This method is a callback which your controller can use to do other cleanup
// when a process is halted.
- (void)processFinished:(id)sender withTerminationStatus:(int)resultCode
{
//	[self write:[NSString stringWithFormat:@"\rcommand finished. Result code: %i\r", resultCode]];
	[self setShellWrapper:nil];
//	[textOutlet scrollRangeToVisible:NSMakeRange([[textOutlet string] length], 0)];
//	[errorOutlet scrollRangeToVisible:NSMakeRange([[errorOutlet string] length], 0)];
	[runButton setEnabled:YES];
	[progressIndicator stopAnimation:self];
	[sender release];
	[runButton setTitle:@"Go"];
	[runButton setAction:@selector(start:)];
	[address setAction:@selector(start:)];
}











@end
