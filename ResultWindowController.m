//
//  ResultWindowController.m
//  data_m
//
//  Created by Mike Fluff on 05.04.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "ResultWindowController.h"


@implementation ResultWindowController

@synthesize managedObjectContext;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
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

- (IBAction)openPairsPanel:(id)sender
{
    [ActiveTestsDrawer toggle:self];
}



- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
