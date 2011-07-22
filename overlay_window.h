//
//  overlay_window.h
//  data_m
//
//  Created by Mike Fluff on 04.03.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface overlay_window : NSWindow
	{
	}
	-(id)initWithParentWindow:(NSWindow*)parentWindow withView:(NSView*)subview;
	
	// The NSWindowController of the parent window should implement
	// -windowDidResize: and then invoke this method.
	-(void)parentDidResize;


@end
