//
//  MyPrefsWindowController.h
//  MyCoolProgram
//

#import <Cocoa/Cocoa.h>
#import "DBPrefsWindowController.h"
#import "Neo_controller.h"
#import "Endpoint_controller.h"
#import "test_setup_controller.h"

@interface MyPrefsWindowController : DBPrefsWindowController <DeviceControllerProtocol> {
	IBOutlet NSView *generalPrefsView;
	IBOutlet NSView *advancedPrefsView;
	IBOutlet NSWindow *window2;
	

	IBOutlet NSTableView *dev_table;
	IBOutlet NSTextField *idField;
	IBOutlet NSTextField *ipAddr;
    IBOutlet NSTextField *login;
    IBOutlet NSTextField *password;
    
    
	IBOutlet NSComboBox *setType;
	
    
	
	IBOutlet NSArrayController *Devices;
	
	IBOutlet NSTextField *DevStatus;
	
	NSManagedObjectContext *_moc, *_docMoc;
	NSManagedObject *obj;
    
    IBOutlet test_setup_controller *test_controller;
    
}

- (IBAction) openAddIntWindow:(id)sender;
- (IBAction) AddDevice:(id)sender;
- (IBAction) closeAddIntWindow:(id)sender;

//protocols methods

-processFinished:(id)sender;


@end
