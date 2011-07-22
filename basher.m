//
//  basher.m
//  data_m
//
//  Created by Mike Fluff on 03.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "basher.h"
#import "NSStringArgs.h"

@implementation basher

@synthesize type;

-(id)initWithController:(id <basherProto>)cont addr:(NSString *)addr login:(NSString *)login password:(NSString *)password type:(NSString *)typer
{
	num = 1;
	type = [[NSString alloc] initWithString:typer];
	
	controller = cont;
	
	if ([type isEqualToString:@"shell"])
	{
	
	NSArray *arguments;
	arguments = [[NSArray alloc] initWithObjects:addr,nil];
	[self setShellWrapper:[[AMShellWrapper alloc] initWithController:self inputPipe:nil outputPipe:nil errorPipe:nil workingDirectory:@"." environment:nil arguments:arguments]];
	
	}
	else if ([type isEqualToString:@"ssh"])
	{
	
	myssh = [[ssh alloc] init];
	
	// get the libssh2 version
	[myssh libssh2ver];
	
	// log in to server using public key
	NSInteger err = [myssh initWithHost: [addr UTF8String]
									port: 22
									user: [login UTF8String]
									password: [password UTF8String]];
	

	if(!err)
	{
		return 0;
	}
	else {
		return 1;
	}

	}
	
	else if ([type isEqualToString:@"expect"])
	{
	
		exp = [[Expecter alloc] init];
		[exp initWithHost: [addr UTF8String]
							port: 22
							user: [login UTF8String]
							password: [password UTF8String]];
		return exp;
	}
}


- (void)setAction:(NSString *)act
{
	action = [[NSObject alloc] init];
	action = act;
//    [NSThread detachNewThreadSelector:@selector(execWithController:) toTarget:myssh withObject:action];
}

- (void)runAction
{
    NSArray *arg = [NSArray arrayWithObjects:controller,action,nil];
    [NSThread detachNewThreadSelector:@selector(execWithController:) toTarget:myssh withObject:arg];

}

- (void)startArgProcess:(NSArray *)argument
{
	BOOL error = NO;
	// We first let the controller know that we are starting
	//	[controller processStarted:self];		
	
	
	NSArray *cmds = [self ProcessAction:action withArgs:argument];
	
	
	if ([type isEqualToString:@"shell"])
		
	{
		
	}
	
	else if ([type isEqualToString:@"ssh"])
	{
		for(NSString *cmd in cmds)
		{
			[self startShellProcess:cmd];
		}
	}
	else if ([type isEqualToString:@"expect"])
	{
		for(NSString *cmd in cmds)
		{
		
			
			[exp execCommand:cmd];
		}
			
	}
}

- (void)setDelegate:(id)delegate
{
    controller = delegate;
}

- (NSArray *)ProcessAction:(id)txt withArgs:(NSArray *)argument
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
	
	if([txt isKindOfClass:[NSString class]])
	{
		
	}
	else if([txt isKindOfClass:[NSArray class]])
	{
	for(NSArray *cmds in txt)
	{
		NSString *cmd = [cmds objectAtIndex:0];
		NSInteger params = [[cmds objectAtIndex:1] intValue];
		if (params != 0)
		{
			if (params < 5 )
				
				switch (params)
			{
				case 1: cmd = [NSString setContentWithFormat:cmd,[argument objectAtIndex:0]];
					break;
				case 2: cmd = [NSString setContentWithFormat:cmd,[argument objectAtIndex:0],[argument objectAtIndex:1]];
					break;
				case 3: cmd = [NSString setContentWithFormat:cmd,[argument objectAtIndex:0],[argument objectAtIndex:1],[argument objectAtIndex:2]];
					break;
				case 4: cmd = [NSString setContentWithFormat:cmd,[argument objectAtIndex:0],[argument objectAtIndex:1],[argument objectAtIndex:2],[argument objectAtIndex:3]];
					break;
			}
			
		}	
	
		[arr addObject:cmd];
	}
	}
	return arr;
}
- (id)startSyncProcess:(NSString *)cmd
{
	NSString *result = [myssh execCommand: [cmd UTF8String]];
	return result;
}

- (void)startShellProcess:(NSString *)cmd
{
	
	NSString *result = [myssh execCommand: [[NSString stringWithFormat:@"ps ax | grep -v grep | grep \"%@\"",cmd] UTF8String]];
	//NSLog(@"%@",result);
	if([result rangeOfString:cmd].location == NSNotFound)
	{
	//	cmd = [cmd stringByAppendingString:@" >/dev/null"];
		
		NSArray *arg = [NSArray arrayWithObjects:controller,cmd,nil];
//		id obj = [ssh new];
						[NSThread detachNewThreadSelector:@selector(execWithController:) toTarget:myssh withObject:arg];
	//	[NSThread detachNewThreadSelector:@selector(test) toTarget:obj withObject:self];
//		[myssh performSelectorOnMainThread:@selector(execWithController:) withObject:self waitUntilDone:NO];
		
	}
	else
	{
		NSLog(@"process already started");
	}
	
}	
	
- (void)processResult:(NSString *)result
{
	NSLog(@"%@",result);
    [controller processFinished:result];
}


- (id)startProcess:(NSString *)act
{
	BOOL error = NO;
	// We first let the controller know that we are starting
//	[controller processStarted:self];		
	id result;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSObject *txt = [defaults objectForKey:act];	

	if ([type isEqualToString:@"shell"])
	{
		
		
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
	else if ([type isEqualToString:@"ssh"])
	{
		
		if([txt isKindOfClass:[NSString class]])
			{
				
				result = [self startSyncProcess:txt];
									
				
			}
			else if([txt isKindOfClass:[NSArray class]])
			{
				for(NSString *cmd in txt)
				{
					[self startShellProcess:cmd];
					
				}
			}

	}
	else if ([type isEqualToString:@"expect"])
	{
		
		if([txt isKindOfClass:[NSString class]])
		{
			[exp execCommand:txt];
		}
		else if([txt isKindOfClass:[NSArray class]])
		{
			for(NSString *cmd in txt)
			{
				[exp execCommand:cmd];
								
			}
		}
	}
	return result;
}
			
		
-(BOOL)copyFile:(NSString *)file toDestinition:(NSString *)destinition
{
    if([myssh sendSCPfile:[file UTF8String] dest:[destinition UTF8String]])
        return YES;
    else 
        return NO;
}
		
		

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

- (void)write:(NSString *)string
{
	//	NSString *resultString;
	
	//	[string getCapturesWithRegexAndReferences:@"time=(\\d+\\.\\d+)", @"$1", &resultString,nil];
	
	arr = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@" "] copyItems: YES];
	[controller processFinished:arr];
	for (NSString *str in arr)
		NSLog(@"%@", str);
	
	
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
	//	[progressIndicator startAnimation:self];
	//	[runButton setTitle:@"Stop"];
	//	[address setAction:@selector(stopTask:)];
	//	[runButton setAction:@selector(stopTask:)];
}

// This method is a callback which your controller can use to do other cleanup
// when a process is halted.
- (void)processFinished:(id)sender withTerminationStatus:(int)resultCode
{
	//	[self write:[NSString stringWithFormat:@"\rcommand finished. Result code: %i\r", resultCode]];
	[self setShellWrapper:nil];
	//	[textOutlet scrollRangeToVisible:NSMakeRange([[textOutlet string] length], 0)];
	//	[errorOutlet scrollRangeToVisible:NSMakeRange([[errorOutlet string] length], 0)];
	//	[runButton setEnabled:YES];
	//	[progressIndicator stopAnimation:self];
	[sender release];
	//	[runButton setTitle:@"Go"];
	//	[runButton setAction:@selector(start:)];
	//	[address setAction:@selector(start:)];
}

	

@end
