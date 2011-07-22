//
//  test_setup_controller.h
//  data_m
//
//  Created by Mike Fluff on 03.03.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface test_setup_controller : NSObject <NSTabViewDelegate, NSTableViewDataSource> {
	IBOutlet NSTableView *AvailableDevices;
	IBOutlet NSTableView *UsedDevices;
	IBOutlet NSComboBox *testType;
	IBOutlet NSTextField *testName;
    
	NSMutableArray *availableArray;
	NSMutableArray *usedArray;
    
    IBOutlet NSPanel *panel;
    
    
    NSManagedObjectContext *_moc, *_docMoc;
    
    IBOutlet NSTextField *links;
    IBOutlet NSTextField *pairs;
    
    IBOutlet NSStepper *link_setter;
    IBOutlet NSStepper *pair_setter;
    
    NSInteger neocount;
    NSInteger epcount;
}

- (IBAction) saveTest:(id)sender;
- (IBAction) linksChanged:(id)sender;
- (IBAction)openPanel:(id)sender;

- (void) reloadData;



@end
