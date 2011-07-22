//
//  TestWindowController.m
//  data_m
//
//  Created by Mike Fluff on 04.03.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "TestWindowController.h"



@implementation TestWindowController


@synthesize managedObjectContext, testsTable, toolbar;

- (IBAction)startTest:(id)sender {
    
    [TAC initWithTest:[tests selectedObjects]]; 
    TAC.TestIndex = [NSNumber numberWithInt:[tests selectionIndex]];
    
    [TAC startTests];
    
  //  [[testsTable tableColumnWithIdentifier:@"Status"] setDataCell:[[ProgressCell alloc] init]];
    [TAC setDelegate:self];
    
    [testsTable reloadData];
   // [[self managedObjectContext] processPendingChanges];
    
}



- (IBAction)stopTest:(id)sender {
  //  NSLog(@"%lu",[tests retainCount]);
    [TAC stopTests];
 //   [[[testsTable tableColumnWithIdentifier:@"Status"] dataCell] removeProgress];
    sleep(1);
    [testsTable reloadData];
    
}

- (IBAction)openTestsPanel:(id)sender {
   // [testsArrayController selection];
    // [TAC prepareContent:[tests selection]];
    [ActiveTestsDrawer toggle:self];
}


- (NSManagedObjectContext *)managedObjectContext
{
	if (managedObjectContext == nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        managedObjectContext =  [[NSApp delegate] managedObjectContext];
    }
    return managedObjectContext;
}

-(BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem
{
    BOOL enable = YES;
    if ([[toolbarItem itemIdentifier] isEqual:@"start"]) {
        // We will return YES (enable the save item)
        // only when the document is dirty and needs saving
        if([TAC.testThread isExecuting])
        {
            enable = NO;
        }
        else
        {
            enable = YES;
        }
    } else if ([[toolbarItem itemIdentifier] isEqual:@"stop"]) {
        // always enable print for this window
        if([TAC.testThread isExecuting])
        {
            enable = YES;
        }
        else
        {
            enable = NO;
            [TAC.progress removeFromSuperview];
           
        }
    }
    return enable;
}


- (void)awakeFromNib
{
    // Transfer Table
    
   
    
    
    
}


@end
