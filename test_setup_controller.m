//
//  test_setup_controller.m
//  data_m
//
//  Created by Mike Fluff on 03.03.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "test_setup_controller.h"
#import "Device.h"
#import "Interface.h"
#import "Tests.h"
#import "Pairs.h"

neocount = 1;
epcount = 1;


@implementation test_setup_controller


#define MyPrivateTableViewDataType @"MyPrivateTableViewDataType"

- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
	if (aTableView == AvailableDevices) 
    {
        return [availableArray count];
    }
    
        
	if (aTableView == UsedDevices) return [usedArray count];
	return 0; // just in case
}
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *) aTableColumn row:(int)rowIndex
{  
	if (aTableView == AvailableDevices) 
    {
        Device * zData = [availableArray objectAtIndex:rowIndex];
        return zData.id;
    } 
	if (aTableView == UsedDevices) {
        Device * zData = [usedArray objectAtIndex:rowIndex];
        return zData.id;
    }
	return 0;
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex {
	
    if (aTableView == AvailableDevices) {
		NSObject * zData = [availableArray objectAtIndex:rowIndex];
	//	zData.nsStr   = (NSString *)anObject;
        [usedArray replaceObjectAtIndex:rowIndex withObject:zData];
	} // end if
	
}

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
	if (tv == AvailableDevices)
	{
		NSData *zNSIndexSetData = 
		[NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
		[pboard declareTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType]
					   owner:self];
		[pboard setData:zNSIndexSetData forType:MyPrivateTableViewDataType];
		return YES;
        
	}
}
- (NSDragOperation)tableView:(NSTableView*)tv 
                validateDrop:(id )info 
                 proposedRow:(NSInteger)row 
       proposedDropOperation:(NSTableViewDropOperation)op {
	// Add code here to validate the drop
	return NSDragOperationEvery;
}
- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
 {
	
	NSPasteboard* pboard = [info draggingPasteboard];
	NSData* rowData = [pboard dataForType:MyPrivateTableViewDataType];
	NSIndexSet* rowIndexes = 
	[NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	NSInteger dragRow = [rowIndexes firstIndex];
	
	// Move the specified row to its new location...
	// if we remove a row then everything moves down by one
	// so do an insert prior to the delete
	// --- depends which way were moving the data!!!
	if (dragRow < row) {
		[usedArray insertObject:
		 [availableArray objectAtIndex:dragRow] atIndex:row];
		[availableArray removeObjectAtIndex:dragRow];
		[AvailableDevices noteNumberOfRowsChanged];
		[UsedDevices reloadData];
		
		return YES;
		
	}
	Device * zData = [availableArray objectAtIndex:dragRow];
	[availableArray removeObjectAtIndex:dragRow];
	[usedArray insertObject:zData atIndex:row];
	[AvailableDevices noteNumberOfRowsChanged];
	[UsedDevices reloadData];
	
	return YES;
}

- (void)AvailableaddRow:(NSDictionary *)item {
	[availableArray addObject:item];
	[AvailableDevices reloadData];
}
- (void)UsedaddRow:(NSDictionary *)item
{
	[usedArray addObject:item];
	[UsedDevices reloadData];
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (_moc == nil)
    {
        _moc = [[NSManagedObjectContext alloc] init];
        _moc =  [[NSApp delegate] managedObjectContext];
    }
    return _moc;
}
- (IBAction) linksChanged:(id)sender
{
    [links setIntegerValue:[link_setter integerValue]];
}

- (IBAction)openPanel:(id)sender {
    if([availableArray count] == 0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:@"No any devices avalible"];
        [alert setAlertStyle:NSWarningAlertStyle]; 
        [alert runModal];
    }
    else
    {
        [panel makeKeyAndOrderFront:self];
    }
}
- (IBAction) pairsChanged:(id)sender
{
    [pairs setIntegerValue:[pair_setter integerValue]];
}

- (IBAction) saveTest:(id)sender
{
    
	if([[testName stringValue] isEqualToString:@""])
    {
        
    }
    else if([[testType objectValueOfSelectedItem] isEqualToString:@""])
        {
        
        }
	else if([link_setter integerValue] == 0)
    {
        
    }
    else if([pair_setter integerValue] == 0)
    {
    
    }
    else if([usedArray count] == 0)
    {
    
    }
    else
    {
    Tests *test = [NSEntityDescription insertNewObjectForEntityForName:@"Tests" inManagedObjectContext:[self managedObjectContext]];
    test.id = [testName stringValue];
	test.Type = [testType objectValueOfSelectedItem];
    test.Links = [NSNumber numberWithInt:[link_setter integerValue]];
    //test.Pairs = [NSNumber numberWithInt:[pair_setter integerValue]];
   // NSMutableSet *devices = [[[NSMutableSet alloc] init] autorelease];
    for(Device *dev in usedArray)
    {
        if([[dev valueForKey:@"type"] isEqualToString:@"Endpoint"])
        {
            if(epcount % 2)
            {
                dev.isServer = [NSNumber numberWithInt:YES];
            }
            epcount++;
        }
        else if([[dev valueForKey:@"type"] isEqualToString:@"Neo"])
        {
            if(neocount % 2)
            {
                dev.isServer = [NSNumber numberWithInt:YES];
            }
            neocount++;
        }

    }
    NSSet *devices = [NSSet setWithArray:usedArray];
	[test setValue:devices forKey:@"Devices"];
    NSMutableSet *pairss = [[NSMutableSet alloc] initWithCapacity:[pair_setter integerValue]];
        for(int i=1;i<=[pair_setter integerValue];i++)
        {
            Pairs *pair = [NSEntityDescription insertNewObjectForEntityForName:@"Pairs" inManagedObjectContext:[self managedObjectContext]];
            pair.id = [NSString stringWithFormat:@"Pair %d",i];
            pair.enabled = [NSNumber numberWithInt:YES];
            [pairss addObject:pair];
        }
    [test setValue:pairss forKey:@"Pairs"];
    [_moc processPendingChanges];
    [panel close];
    [testName setStringValue:@""];
    [testType setStringValue:@""];
    [links setStringValue:@""];
    [pairs setStringValue:@""];
    [link_setter setIntegerValue:0];
    [pair_setter setIntegerValue:0];
    }
}


- (void) reloadData
{
 /*  NSFetchRequest *request = [[NSFetchRequest alloc] init]; [request setEntity:[NSEntityDescription entityForName:@"Device" inManagedObjectContext:[self managedObjectContext]]];
 //   NSLog(@"%@",test_string);
    NSError *error = nil; 
    availableArray = [_moc executeFetchRequest:request error:&error]; 
    if (error) {
        [NSApp presentError:error]; return;
    }*/
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; [request setEntity:[NSEntityDescription entityForName:@"Device" inManagedObjectContext:[self managedObjectContext]]];
    NSError *error = nil; 
    NSArray *dataArray = [NSMutableArray arrayWithArray:[_moc executeFetchRequest:request error:&error]]; 
    availableArray = [[NSMutableArray alloc] init];
    for(Device *dev in dataArray)
    {
        [availableArray addObject:dev];
    }
    if (error) {
        [NSApp presentError:error]; 
    }
    NSLog(@"%d",[availableArray count]);
    [AvailableDevices reloadData];
}



- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"ReloadData" object:nil];
    
    
      
    
	usedArray = [[NSMutableArray alloc] init];
	
    [AvailableDevices registerForDraggedTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType] ];
	[UsedDevices registerForDraggedTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType] ];
    [pairs setIntegerValue:[pair_setter integerValue]];
    [links setIntegerValue:[link_setter integerValue]];
}
@end
