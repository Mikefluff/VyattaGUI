//
//  MyDocument.m
//  data_m
//
//  Created by Mike Fluff on 08.04.10.
//  Copyright Altell ltd 2010 . All rights reserved.
//

#import "ssh-proto-test.h"

#import "MyDocument.h"
#import "ImageTextCell.h"
#import "Device.h"
#import "Interface.h"

#import "Endpoint_controller.h"
#import "NSStringArgs.h"
#import "MyPrefsWindowController.h"

#import "testBuilder.h"
#import "Test_Activity_Controller.h"
#import "YBGraphView.h"
#import "SourceListItem.h"


@implementation MyDocument

@synthesize managedObjectContext;
@synthesize window, splitView, leftButton, rightButton, leftView, rightView;

- (id)init 
{
    self = [super init];
    if (self != nil) {
        // initialization code
        wc1 = 
        [[TestWindowController alloc] initWithWindowNibName:@"tests"];
        
       
    }
    return self;
}



- (void)repositionBottomBarButtons
{
	// we don't actually have to do anything for the left-most button and the left pane
	// because we've got it pegged in IB to maintain it's position in relation to the
	// window's bottom and left bounds
	
	// first tell the superview that it will need to redraw the frame we'll be moving
	NSRect oldFrame = [rightButton frame];
	[[rightButton superview] setNeedsDisplayInRect:oldFrame];
	
	NSPoint newOrigin = rightView.frame.origin;
	
	NSRect newFrame = NSMakeRect(newOrigin.x, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
	[rightButton setFrame:newFrame];
	[rightButton setNeedsDisplay:YES];
}
// gets call after the NSSplitView is resized OR after the divider(s) are moved
- (void)splitViewDidResizeSubviews:(NSNotification *)aNotification
{
	[self repositionBottomBarButtons];
}



- (NSString *)windowNibName 
{
    return @"MyDocument";
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"neotest.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


- (void)processFinished:(id)sender
{
	
//	NSMutableArray *test = [[NSMutableArray alloc] init];
//	test = sender;
//	NSManagedObjectContext *context = [self managedObjectContext];
	
//	for(NSString *interf in test)
//	{
//		Interface *inter = [NSEntityDescription insertNewObjectForEntityForName:@"Interface" inManagedObjectContext:context];
//		inter.id = interf; 
	//[interface stringValue];
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
//	}
//	[context processPendingChanges];
}

- (IBAction)openPreferencesWindow:(id)sender
{
	
	[[MyPrefsWindowController sharedPrefsWindowController] showWindow:nil];
}

-(IBAction) openTests:(id)sender
{

	
	
	if (nil == wc1) {
        
        wc1 = 
        [[NSWindowController alloc] initWithWindowNibName:@"tests"];
        
    }
	
    [wc1 showWindow:self];
}

-(IBAction) openResults:(id)sender
{
	
	
    if (nil == wc2) {

    wc2 = 
    [[ResultWindowController alloc] initWithWindowNibName:@"results"];
    
    }
    
    [wc2 showWindow:self];
   
}




-(IBAction) go:(id)sender {
    
 	testBuilder *tst = [[testBuilder alloc] init];
    tst.context = [self managedObjectContext];
    [tst runTest];
/*    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reports" inManagedObjectContext:[self managedObjectContext]];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
	
	NSError *error = nil;
	
	NSArray *array = [[NSArray alloc] init];
	array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    
    for(id obj in array)
    {
        NSLog(@"%@",[obj valueForKey:@"id"]);
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Results" inManagedObjectContext:[self managedObjectContext]];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Report.id = %@",[obj valueForKey:@"id"]];
    [request setPredicate:predicate];
        NSError *error = nil;
	
	NSArray *array = [[NSArray alloc] init];
	array = [[self managedObjectContext] executeFetchRequest:request error:&error];
        for (id obj in array)
            NSLog(@"%@",[[obj valueForKey:@"Report"] valueForKey:@"id"]);
    }
    
    /* Endpoint_controller *endpoint = [[Endpoint_controller alloc] init];
    [endpoint initWithIp:@"192.168.1.1"];
    [endpoint startEndpointPerfClient];*/
   // [test runTest];
   // [wind update];
    
     // Test_Activity_Controller *tst = [[Test_Activity_Controller alloc] initWithTest:@"test"];
    
    
//	[curview addSubview:graphView];
	/*	const char *hostName = [@"192.168.200.1"
							cStringUsingEncoding:NSASCIIStringEncoding];
	SCNetworkConnectionFlags flags = 0;
	if (SCNetworkCheckReachabilityByName(hostName, &flags) && flags > 0) {
		NSLog(@"Host is reachable: %d", flags);
	}
	else {
		NSLog(@"Host is unreachable");
	}
	*/
//	[self setShellWrapper:[[AMShellWrapper alloc] initWithController:self inputPipe:nil outputPipe:nil errorPipe:nil workingDirectory:@"." environment:nil arguments:@"ping"]];
	
//	Endpoint_controller *ep = [[Endpoint_controller alloc] init];
	//	[ep startEndpointPerfServer:@"192.168.200.1"];
//	[ep startEndpointPerfClient:@"192.168.200.1" withArgs:[NSArray arrayWithObjects:@"192.168.10.2",nil]];
	/*	[ep startEndpointPerfClient:@"192.168.200.1" withArgs:[NSArray arrayWithObjects:@"192.168.10.1",nil]];
	 */
//	neo = [[Neo_controller alloc] initWithIp:@"192.168.200.1"];
//	[neo pingDevice];
	
	 
	
	
	
//	NSManagedObjectContext *context = [self managedObjectContext];
//	Device *deva = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
//	if([idField stringValue] != nil)
//	{
	//	deva.id = [idField stringValue];
	 
//	NSLog(@"%@", [idField stringValue]);
	//	deva.type = [setType objectValueOfSelectedItem];
//		deva.manageip = [NSNumber numberWithInt:([ipAddr intValue])];
//	}
	
//	[context processPendingChanges];
	//[idField setStringValue:@""];
//	NSString *add = [NSString stringWithString:@"192.168.200.1"];
	//	[self setifaces:[[basher alloc] initWithController:self addr:add]];
	
	
	
	
//	basher *iface = [[basher alloc] initWithController:self action:@"showconfig" addr:add type:@"expect"];

	
	// create an ssh object
//	ssh *myssh = [[ssh alloc] init];
	
	// get the libssh2 version
//	[myssh libssh2ver];
	
	// log in to server using public key
//	NSInteger te = [myssh initWithHost: "192.168.200.1"
//				   port: 22
//				   user: "admin"
//					password: "admin"];
	
	// execute a command on the remote server
	
//	if (te == 0)
//	{
//	NSString *result = [myssh execCommand: "show interfaces"];
//	NSLog(@"%@", result);
//	}
//	NSLog(@"%@", [myssh receiveSCP: "/etc/config/config.boot"]);
	
	//	NSString *ip = [self stringForObjectValue:deva.manageip];
//	NSLog(@"%@ %d", ip, deva.manageip);
/*	NSError *error = nil;
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Device" inManagedObjectContext:context];
	[request setEntity:entity];
	
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"id" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	
	
	array = [context executeFetchRequest:request error:&error];
	Device *obj = [array objectAtIndex:0];
	
	NSString *string = [obj id];
	NSLog(@"%@", string); 
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadViewControllerTable" object:nil];
//	[context deleteObject:obj];
	
//	[context release];*/
 	
}

- (NSString *)stringForObjectValue:(id)obj
{
	unsigned int  ipNumber;
	
	if([obj isKindOfClass:[NSNumber class]])
	{
		ipNumber  = [obj unsignedIntValue];
	}
	else
	{
		ipNumber  = [obj intValue];
	}
	
	return [NSString stringWithFormat: @"%u.%u.%u.%u",
			(ipNumber >> 24) & 0xFF,
			(ipNumber >> 16) & 0xFF,
			(ipNumber >> 8) & 0xFF,
			ipNumber & 0xFF];
}

-(void)pingOK:(NSString *)string
{
	NSLog(@"%@",string);
}


-(IBAction) addInt:(id)sender {
//	NSManagedObjectContext *context = [self managedObjectContext];
//	Interface *inter = [NSEntityDescription insertNewObjectForEntityForName:@"Interface" inManagedObjectContext:context];
//	inter.id = [interface stringValue];
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
//	inter.device = obj;
	
//	NSString *ip = [self stringForObjectValue:inter.ip];
//	NSLog(@"%@ %d", ip, inter.ip);
//	[context processPendingChanges];
	
}




#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	
	[super dealloc];
}

-(void) reloadTableViewData {
//	[self go:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadControllerTable" object:nil];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    int state;
    
    int answer = NSRunAlertPanel(@"Close",@"Are you Certain?",
                                 @"Close",@"Cancel", nil);
    if(answer == NSAlertDefaultReturn)
       
    {
    
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    if (saveError != nil) 
    {
        NSLog(@"[%@ saveContext] Error saving context: Error = %@, details = %@",[self class], saveError,saveError.userInfo);
        state = NSTerminateCancel;
    }
     state = NSTerminateNow;
    }
    else state = NSTerminateCancel;
    return state;
}



- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
//	[[self windowForSheet] setContentBorderThickness:24.0 forEdge:NSMinYEdge];
	
    
    [selectedItemLabel setStringValue:@"(none)"];
	
	sourceListItems = [[NSMutableArray alloc] init];
	
	//Set up the "Library" parent item and children
	SourceListItem *toolsItem = [SourceListItem itemWithTitle:@"TOOLS" identifier:@"tools"];
	SourceListItem *musicItem = [SourceListItem itemWithTitle:@"Network" identifier:@"network"];
	[musicItem setIcon:[NSImage imageNamed:@"music.png"]];
	SourceListItem *moviesItem = [SourceListItem itemWithTitle:@"Tests" identifier:@"tests"];
	[moviesItem setIcon:[NSImage imageNamed:@"movies.png"]];
	SourceListItem *podcastsItem = [SourceListItem itemWithTitle:@"Results" identifier:@"results"];
	[podcastsItem setIcon:[NSImage imageNamed:@"podcasts.png"]];
	[podcastsItem setBadgeValue:10];
	SourceListItem *audiobooksItem = [SourceListItem itemWithTitle:@"Logs" identifier:@"logs"];
	[audiobooksItem setIcon:[NSImage imageNamed:@"audiobooks.png"]];
	[toolsItem setChildren:[NSArray arrayWithObjects:musicItem, moviesItem, podcastsItem,
							  audiobooksItem, nil]];
	
	//Set up the "Playlists" parent item and children
	SourceListItem *devicesItem = [SourceListItem itemWithTitle:@"DEVICES" identifier:@"devices"];
	SourceListItem *playlist1Item = [SourceListItem itemWithTitle:@"Neo1" identifier:@"neo1"];
	
	//Create a second-level group to demonstrate
	SourceListItem *playlist2Item = [SourceListItem itemWithTitle:@"Neo2" identifier:@"neo2"];
	SourceListItem *playlist3Item = [SourceListItem itemWithTitle:@"Neo3" identifier:@"neo3"];
	[playlist1Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlist2Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlist3Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	
	SourceListItem *playlistGroup = [SourceListItem itemWithTitle:@"Neo4" identifier:@"neo4"];
	SourceListItem *playlistGroupItem1 = [SourceListItem itemWithTitle:@"Firewall" identifier:@"childplaylist"];
    SourceListItem *playlistGroupItem2 = [SourceListItem itemWithTitle:@"Vpn" identifier:@"childplaylist"];
    SourceListItem *playlistGroupItem3 = [SourceListItem itemWithTitle:@"Interfaces" identifier:@"childplaylist"];
    SourceListItem *playlistGroupItem4 = [SourceListItem itemWithTitle:@"Protocols" identifier:@"childplaylist"];
    
	[playlistGroup setIcon:[NSImage imageNamed:@"playlistFolder.png"]];
	[playlistGroupItem1 setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlistGroup setChildren:[NSArray arrayWithObjects:playlistGroupItem1,playlistGroupItem2,playlistGroupItem3,playlistGroupItem4,nil]];
	
	[devicesItem setChildren:[NSArray arrayWithObjects:playlist1Item, playlist2Item,
								playlist3Item, playlistGroup, nil]];
	
    SourceListItem *monitoringItem = [SourceListItem itemWithTitle:@"MONITORING" identifier:@"monitoring"];
    
    
	[sourceListItems addObject:toolsItem];
	[sourceListItems addObject:devicesItem];
    [sourceListItems addObject:monitoringItem];
	
	[sourceList reloadData];

	
	
	
	
//	NSTableColumn* column = [[tableView tableColumns] objectAtIndex:0];
	
//	ImageTextCell* cell = [[[ImageTextCell alloc] init] autorelease];	
//	[column setDataCell: cell];		
	
	
	
//	Firewall_test *test = [[Firewall_test alloc] init];
//	[test generateConfig:100];
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"ReloadRootViewControllerTable" object:nil];	
	array = [[NSArray alloc] init];
//	NSUserDefaults *commands = [NSUserDefaults standardUserDefaults];
//	NSString *cmdstring = [[NSString alloc] initWithString:@"show interfaces"];
//	[commands setObject:cmdstring forKey:@"intlist"];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:@"show interfaces" forKey:@"intlist"];	
	[defaults setObject:@"iperf -s -D" forKey:@"iperf"];
	[defaults setObject:@"show interfaces ethernet | grep eth | wc -l" forKey:@"checkIntNumber"];
	[defaults setObject:[NSArray arrayWithObjects:
						 [NSArray arrayWithObjects:@"iperf -c %@ -t 10 -i 1 -y C",@"1",nil],nil] forKey:@"iperfc"];
	[defaults setObject:[NSArray arrayWithObjects:
						 [NSArray arrayWithObjects:@"merge %@",@"1",nil],nil] forKey:@"loadconfig"];
	
	
	/*	
	
	[defaults setObject:[NSArray arrayWithObjects:
						 [NSArray arrayWithObjects:@"set interfaces ethernet %@ address %@/24",@"2",nil],nil] forKey:@"setInt"];
	
	
	NSArray *cmds = [[NSArray alloc] initWithObjects:@"set interfaces management false",0,nil];
	[defaults setObject:cmds forKey:@"disableManagement"];
	
	
	Neo_controller *neo = [[Neo_controller alloc] initWithIp:@"192.168.200.1"];
	[neo loadconfig:@"test"]; */
	
	//	dev_table.context = [self managedObjectContext];
	
    // user interface preparation code
	
	
	
	
	
}

#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems objectAtIndex:index];
	}
	else {
		return [[item children] objectAtIndex:index];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];
}


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
	[item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return [item hasBadge];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [item badgeValue];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return [m autorelease];
	}
	return nil;
}

#pragma mark -
#pragma mark Source List Delegate Methods

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
//	if([[group identifier] isEqualToString:@"library"])
//		return YES;
	
	return NO;
}


- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
	
	NSArray *subviews = [rightView subviews];
	if([subviews count] > 0)
		[[subviews objectAtIndex:0] removeFromSuperview];
	
	//Set the label text to represent the new selection
	if([selectedIndexes count]>1)
		[selectedItemLabel setStringValue:@"(multiple)"];
	else if([selectedIndexes count]==1) {
		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		if([identifier isEqualToString:@"tests"])
		{
			TestWindowController *testWind = 
			[[[TestWindowController alloc] initWithWindowNibName:@"tests"] autorelease];
			[[testWind window] close];
			NSView *testView = [[testWind window] contentView];
			
            NSView* v = testView;
            NSRect vframe = [v frame];
            [v setHidden:YES];
            [v setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            
            NSView* tmp_superview = [[[NSView alloc] initWithFrame:vframe] autorelease];
            [tmp_superview addSubview:v];
            [tmp_superview setAutoresizesSubviews:YES];
            [tmp_superview setFrame:[rightView frame]];
            
            [v removeFromSuperview];
            [rightView addSubview:v];
            [testView setHidden:NO];
			
            NSArray *arr = [toolbar visibleItems];
            [toolbar removeItemAtIndex:0];
            
		}
		else if([identifier isEqualToString:@"results"])
		{
			ResultWindowController *resWind = [[[ResultWindowController alloc] initWithWindowNibName:@"results"] autorelease];
			NSView *resView = [[resWind window] contentView];
			[[resWind window] close];
            
            NSView* v = resView;
            NSRect vframe = [v frame];
            [v setHidden:YES];
            [v setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            
            NSView* tmp_superview = [[[NSView alloc] initWithFrame:vframe] autorelease];
            [tmp_superview addSubview:v];
            [tmp_superview setAutoresizesSubviews:YES];
            [tmp_superview setFrame:[rightView frame]];
            
            [v removeFromSuperview];
            [rightView addSubview:v];
            [resView setHidden:NO];
			
		}
			
		[selectedItemLabel setStringValue:identifier];
	}
	else {
		[selectedItemLabel setStringValue:@"(none)"];
	}
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}








@end
