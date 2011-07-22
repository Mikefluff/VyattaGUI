//
//  TestWindowController.h
//  data_m
//
//  Created by Mike Fluff on 04.03.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Test_Activity_Controller.h"
#import "VariableCellColumn.h"

@interface TestWindowController : NSWindowController {
	
	
    
    NSManagedObjectContext *managedObjectContext, *_docMoc;
    IBOutlet NSArrayController *tests;
    IBOutlet Test_Activity_Controller *TAC;
    
    IBOutlet NSDrawer *ActiveTestsDrawer;
    
    IBOutlet NSTableView *testsTable;
    
    
    IBOutlet NSToolbarItem *start;
    IBOutlet NSToolbarItem *stop;
    IBOutlet NSToolbar *toolbar;
  
}

- (IBAction)startTest:(id)sender;
- (IBAction)openTestsPanel:(id)sender;
- (IBAction)stopTest:(id)sender;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet NSTableView *testsTable;
@property (nonatomic, retain) IBOutlet NSToolbar *toolbar;


@end
