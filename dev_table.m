//
//  dev_table.m
//  data_m
//
//  Created by Mike Fluff on 02.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "dev_table.h"
#import "Device.h"


@implementation dev_table

//@synthesize context;

static dev_table *_sharedInstance;


-(void) reloadTableViewData{
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
	[tableView reloadData];
}



- (int)numberOfRowsInTableView:(NSTableView *)aTable
{
	context = [[[NSDocumentController sharedDocumentController] currentDocument] managedObjectContext];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"ReloadViewControllerTable" object:nil];
	return ([array count]);
}





- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex
{
	
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
	
	Device *obj = [array objectAtIndex:rowIndex];
	
	return obj.id;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notif {
	context = nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadRootViewControllerTable" object:nil];
}

- (NSInteger) getRow
{
	return [tableView selectedRow];
}

+ (dev_table *) sharedInstance
{
	if (!_sharedInstance)
	{
		_sharedInstance = [[dev_table alloc] init];
	}
	return _sharedInstance;
}


@end
