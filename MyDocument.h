//
//  MyDocument.h
//  data_m
//
//  Created by Mike Fluff on 08.04.10.
//  Copyright Altell ltd 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import "basher.h"
#import "Expecter.h"
#import "Firewall_test.h"
#import "pinger.h"
#import "Neo_controller.h"
#import "YBGraphView.h"
#import "ssh-proto-test.h"
#import "TestWindowController.h"
#import "ResultWindowController.h"
#import "PXSourceList.h"
#import "CoreData+ActiveRecordFetching.h"


@interface MyDocument : NSPersistentDocument <PXSourceListDelegate, PXSourceListDataSource> {
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	ssh_proto_test *test;
	
	IBOutlet PXSourceList *sourceList;
	IBOutlet NSTextField *selectedItemLabel;
	
	
	IBOutlet NSToolbar *toolbar;
    
    
    NSWindow *window;
	NSSplitView *splitView;
	NSButton *leftButton;
	NSButton *rightButton;
	NSView *leftView;
	NSView *rightView;
    
	
	NSMutableArray *sourceListItems;
	
	NSWindowController* wc1;
	NSWindowController* wc2;
	
	
	@private NSArray *array;
	
}


- (IBAction)go:sender;

- (IBAction)addInt:sender;
- (IBAction)openPreferencesWindow:(id)sender;
- (IBAction) openTests:(id)sender;
- (IBAction) openResults:(id)sender;



@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSSplitView *splitView;
@property (assign) IBOutlet NSButton *leftButton;
@property (assign) IBOutlet NSButton *rightButton;
@property (assign) IBOutlet NSView *leftView;
@property (assign) IBOutlet NSView *rightView;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSString *)applicationDocumentsDirectory;
- (void)pingOK:(NSString *)string;



@end
