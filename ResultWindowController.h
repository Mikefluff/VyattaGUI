//
//  ResultWindowController.h
//  data_m
//
//  Created by Mike Fluff on 05.04.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Test_Activity_Controller.h"

@interface ResultWindowController : NSWindowController {
    NSManagedObjectContext *managedObjectContext, *_docMoc;
    
    IBOutlet NSDrawer *ActiveTestsDrawer;
    
    
    
    
@private
    
}

- (IBAction)openPairsPanel:(id)sender;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
