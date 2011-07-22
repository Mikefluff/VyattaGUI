//
//  int_table.m
//  data_m
//
//  Created by Mike Fluff on 01.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "int_table.h"
#import "Device.h"
#import "Interface.h"

@implementation int_table







-(void) reloadTableViewData{
//	_context = [[[NSDocumentController sharedDocumentController] currentDocument] managedObjectContext];
//	_context = [[NSApp delegate] managedObjectContext];
	context = [[[NSDocumentController sharedDocumentController] currentDocument] managedObjectContext];
	NSError *error = nil;
	
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription entityForName:@"Device"
											  inManagedObjectContext:context];
	[request setEntity:entity];
	
	// here's where you specify the sort
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"id" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	
	array = [context executeFetchRequest:request error:&error];
	[inttable reloadData];
}


- (int)numberOfRowsInTableView:(NSTableView *)aTable
{
	context = [[[NSDocumentController sharedDocumentController] currentDocument] managedObjectContext];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"ReloadControllerTable" object:nil];
	return ([array count]);
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex
{
	//NSManagedObjectContext *_context = [[[NSDocumentController sharedDocumentController] currentDocument] managedObjectContext];
	NSError *error = nil;
	
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription entityForName:@"Device"
											  inManagedObjectContext:context];
	[request setEntity:entity];
	
	// here's where you specify the sort
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"id" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	
	array = [context executeFetchRequest:request error:&error];
	
	
	
	Device *obj = [array objectAtIndex:0];
	NSSet *ips = [obj valueForKeyPath:@"interface"];
	array = [ips allObjects];
	Interface *obj1 = [[Interface alloc] init];
	
	
	if ([array count] != 0 )
	{
	obj1 = [array objectAtIndex:rowIndex];
		if ([[aTableColumn identifier] isEqualToString:@"id"])
			return obj1.id;
		if ([[aTableColumn identifier] isEqualToString:@"ip"])
			return obj.manageip;
	}
	else 
		return 0;
	
	
	

	
}



// Then:





-(IBAction) go:(id)sender {
//	NSManagedObjectContext *context = [[[NSDocumentController sharedDocumentController] currentDocument] managedObjectContext];
	NSError *error = nil;
	
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription entityForName:@"Device"
											  inManagedObjectContext:context];
	[request setEntity:entity];
	
	// here's where you specify the sort
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"id" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	
	array = [context executeFetchRequest:request error:&error];
	Device *obj = [array objectAtIndex:0];
	NSSet *ips = [obj valueForKeyPath:@"interface"];
	array = [ips allObjects];
	
	[inttable reloadData];
}






@end
