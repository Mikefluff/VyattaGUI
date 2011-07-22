//
//  Neo_controller.m
//  data_m
//
//  Created by Mike Fluff on 14.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "Neo_controller.h"
#import "Expecter.h"
#import "NSStringArgs.h"



@implementation Neo_controller

-(void)disableManagementInt
{
	[iface startProcess:@"disableManagement"];
}





-(void)startConnectionType:(NSString *)typ
{
	[iface initWithController:self addr:ip type:typ];
}

-(void)setMngIp:(NSString *)ip
{
	NSArray *arguments = [[NSArray alloc] initWithObjects:@"eth0",ip,nil];
	[iface startArgProcess:@"setip" arguments:arguments];
}


-(void)setint:(NSString *)name addr:(NSString *)ip
{
	NSArray *arguments = [[NSArray alloc] initWithObjects:name,ip,nil];
	[iface startArgProcess:@"setint" arguments:arguments];
}	











//this method get physical interfaces number from device
-(int)checkIntNumber
{
	int result;
	[self startConnectionType:@"ssh"];
	result = [[iface startProcess:@"checkIntNumber"] intValue];
	return result;
}
-(BOOL)checkAvaliability
{
	return isAvailable;
}

-(void)pingDevice
{
	pingThread = [[NSThread alloc] initWithTarget:png selector:@selector(runPing) object:nil];
	[pingThread start];
//	[NSThread detachNewThreadSelector:@selector(runPing) toTarget:png withObject:nil];
	//[png runPing];
}




//pingProto support methods
-(void)pingOK
{
	isAvailable = YES;
}
-(void)pingNotOK
{
	isAvailable = NO;
}

- (id)processFinished:(id)sender
{
	
	
}

- (void)dealloc
{
	[pingThread cancel];
}

@end
