//
//  MyPrefsWindowController.m
//  MyCoolProgram
//

#import "MyPrefsWindowController.h"
#import "device_setup_controller.h"
#import "Device.h"


@implementation MyPrefsWindowController


- (void)setupToolbar
{
	[self addView:generalPrefsView label:@"General"];
	[self addView:advancedPrefsView label:@"Advanced"];
}

- (IBAction) closeAddIntWindow:(id)sender {
	NSRect currentViewFrame = NSZeroRect;
	NSRect frame;
	currentViewFrame = [self frameForView:generalPrefsView];
	NSPoint point = NSMakePoint(currentViewFrame.origin.x,currentViewFrame.origin.y);
	
	
	
	// NSArray *arr1 = [self childWindows];
	// if ([arr1 count] == 1)
	 
	 
	 [self.window removeChildWindow:window2];
	 
	 NSRect newWindowFrame = NSMakeRect(currentViewFrame.origin.x,currentViewFrame.origin.y + 459.0,480.0,000.0);
	 
	 NSDictionary *windowResize;
	 windowResize = [NSDictionary dictionaryWithObjectsAndKeys:
	 window2, NSViewAnimationTargetKey,
	 [NSValue valueWithRect: newWindowFrame],
	 NSViewAnimationEndFrameKey,
	 nil];
	 
	 NSDictionary *oldFadeOut = nil;
/*	 if (_extview != nil) {
	 oldFadeOut = [NSDictionary dictionaryWithObjectsAndKeys:
	 _extview, NSViewAnimationTargetKey,
	 NSViewAnimationFadeOutEffect,
	 NSViewAnimationEffectKey, nil];
	 }
	 
	 NSDictionary *newFadeIn;
	 newFadeIn = [NSDictionary dictionaryWithObjectsAndKeys:
	 _extview, NSViewAnimationTargetKey,
	 NSViewAnimationFadeInEffect,
	 NSViewAnimationEffectKey, nil];
	 
	 NSArray *animations;
	 animations = [NSArray arrayWithObjects:
	 windowResize, newFadeIn, oldFadeOut, nil];*/
    
    NSArray *animations;
    animations = [NSArray arrayWithObjects:
                  windowResize, nil];
	 
	 NSViewAnimation *animation;
	 animation = [[NSViewAnimation alloc]
	 initWithViewAnimations: animations];
	 
	 [animation setAnimationBlockingMode: NSAnimationBlocking];
	 [animation setDuration: 0.5]; // or however long you want it for
	 
	 [animation startAnimation]; // because it's blocking, once it returns, we're done
	 
	 [animation release];
	 
	 
	 
	 
	 [window2 close];
	// [self update];
}

- (IBAction) AddDevice:(id)sender
{
//	device_setup_controller *contr = [[device_setup_controller alloc] init];
//	[contr addDevice:[idField stringValue] ip:[NSNumber numberWithInt:([ipAddr intValue])] type:[setType objectValueOfSelectedItem]];
	if([[idField stringValue] isEqualToString:@""])
    {
        
    }
	else if([setType objectValueOfSelectedItem] == nil)
    {
        
    }
    else if([[ipAddr stringValue] isEqualToString:@""])
    {
        
    }
    else
    {
        Device *dev = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:_moc];
	
        dev.id = [idField stringValue];
       
        dev.type = [setType objectValueOfSelectedItem];
        
        NSManagedObject *manageip = [NSEntityDescription insertNewObjectForEntityForName:@"IP" inManagedObjectContext:_moc];
        [manageip setValue:[NSNumber numberWithInt:[ipAddr intValue]] forKey:@"address"];
        dev.manageip = manageip;
        
        dev.login = [login stringValue];
        dev.password = [password stringValue];
	
	/*if ([dev.type isEqualToString:@"Neo"])
	{
		Neo_controller *neo = [[Neo_controller alloc] initWithIp:dev.manageip];
		[neo pingDevice];
		sleep(1);
		if([neo checkAvaliability])
		{
	//	dev.links = [NSNumber numberWithInt:[neo checkIntNumber]] ;
		}
    }*/
	
// check int number
	
	
			[_moc processPendingChanges];
			[dev_table reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
		//	[DevStatus setStringValue:@"Connected"];
			[self closeAddIntWindow:(id)nil];
        [idField setStringValue:@""];
        [setType setStringValue:@""];
        [ipAddr setStringValue:@""];
	}


}

			

- (IBAction) openAddIntWindow:(id)sender {


 NSRect currentViewFrame = NSZeroRect;
 
 currentViewFrame = [self frameForView:generalPrefsView];
 
 
 
 

 
 [window2 setStyleMask:NSBorderlessWindowMask];
 [window2 setFrameOrigin:NSMakePoint(currentViewFrame.origin.x,currentViewFrame.origin.y + 459.0)];
 	[window2 setParentWindow:self.window];
// [self addChildWindow:window2 ordered:1];
	[window2 makeKeyAndOrderFront:self];
	[self.window addChildWindow:window2 ordered:1];
	[window2 makeKeyWindow];

//	[window2 setAlphaValue:0.4];
 //	[window display];
 NSRect newWindowFrame = NSMakeRect(currentViewFrame.origin.x,currentViewFrame.origin.y + 159.0,480.0,300.0);
 
 NSDictionary *windowResize;
 windowResize = [NSDictionary dictionaryWithObjectsAndKeys:
 window2, NSViewAnimationTargetKey,
 [NSValue valueWithRect: newWindowFrame],
 NSViewAnimationEndFrameKey,
 nil];
 
 NSDictionary *oldFadeOut = nil;
/* if (_extview != nil) {
 oldFadeOut = [NSDictionary dictionaryWithObjectsAndKeys:
 _extview, NSViewAnimationTargetKey,
 NSViewAnimationFadeOutEffect,
 NSViewAnimationEffectKey, nil];
 }
 
 NSDictionary *newFadeIn;
 newFadeIn = [NSDictionary dictionaryWithObjectsAndKeys:
 _extview, NSViewAnimationTargetKey,
 NSViewAnimationFadeInEffect,
 NSViewAnimationEffectKey, nil];*/
 
 NSArray *animations;
 animations = [NSArray arrayWithObjects:
 windowResize, nil];
 
 NSViewAnimation *animation;
 animation = [[NSViewAnimation alloc]
 initWithViewAnimations: animations];
 
 [animation setAnimationBlockingMode: NSAnimationBlocking];
 [animation setDuration: 0.5]; // or however long you want it for
 
 [animation startAnimation]; // because it's blocking, once it returns, we're done
 
 [animation release];
	
//[self.window update];
//	[window2 makeKeyAndOrderFront:self];
// }	
 
 //	[window2 display];
}

-processFinished:(id)sender;
{
	if([[sender objectAtIndex:0] isEqualToString:@"renew"])
	{
		[self RenewObjWithdata:[sender objectAtIndex:1]];
	}
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


@end
