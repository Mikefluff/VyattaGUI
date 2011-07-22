//
//  device_setup_controller.m
//  data_m
//
//  Created by Mike Fluff on 03.03.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "device_setup_controller.h"
#import "Device.h"
#import "MyDocument.h"

@implementation device_setup_controller

- (void)addDevice:(NSString *)dev_id ip:(NSNumber *)ip type:(NSString *)dev_type {
	NSManagedObjectContext *context =  [[NSApp delegate] managedObjectContext];
	Device *dev = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
	
	dev.id = dev_id;
	dev.type = dev_type;
	dev.manageip = ip;

	//	inter.ip = [NSNumber numberWithInt:([intAddr intValue])];
	//	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Device" inManagedObjectContext:context];
	//	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	//	[request setEntity:entity];
	
	//	NSError *error = nil;
	
	//	NSArray *array = [[NSArray alloc] init];
	//	array = [context executeFetchRequest:request error:&error];
//	array = [Devices selectedObjects];
//	Device *obj = [[Device alloc] init];
	//	NSString *test = obj.id;
//	for(obj in array)
//		inter.device = obj;
	
	//	NSString *ip = [self stringForObjectValue:inter.ip];
	//	NSLog(@"%@ %d", ip, inter.ip);
	[context processPendingChanges];
	
}


@end
