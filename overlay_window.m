//
//  overlay_window.m
//  data_m
//
//  Created by Mike Fluff on 04.03.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "overlay_window.h"


@implementation overlay_window


-(id)initWithParentWindow:(NSWindow*)parentWindow
                 withView:(NSView*)subview
{
    NSRect overlayRect = NSMakeRect(parentWindow.frame.origin.x,
                                    parentWindow.frame.origin.y, 
                                    [[parentWindow contentView] frame].size.width,
                                    [[parentWindow contentView] frame].size.height);
    
    self = [super initWithContentRect:overlayRect
                            styleMask:NSBorderlessWindowMask
                              backing:NSBackingStoreBuffered
                                defer:NO];
    if(self != nil)
    {
        // Add the specified subview to our list of subviews
        [[self contentView] addSubview:subview];
		
        // We're translucent, so not opaque
        [self setOpaque:NO];
		
        // Set background to a translucent gray
        [self setBackgroundColor:[NSColor colorWithDeviceRed:0
                                                       green:0
                                                        blue:0
                                                       alpha:0.5]];
        // Start out as "hidden"
        [self setAlphaValue:0.0];
		
        // Add ourself to the parent
        [parentWindow addChildWindow:self
                             ordered:NSWindowAbove];  
    }
    
    return self;
}
- (id) initWithContentRect: (NSRect) contentRect
                 styleMask: (unsigned int) aStyle
                   backing: (NSBackingStoreType) bufferingType
                     defer: (BOOL) flag
{
    if (![super initWithContentRect: contentRect 
						  styleMask: NSBorderlessWindowMask 
							backing: bufferingType 
							  defer: flag]) return nil;
    [self setBackgroundColor: [NSColor colorWithCalibratedWhite:0.5 alpha:0.6]];
    [self setOpaque:NO];
	
    return self;
}

-(void)parentDidResize
{
    NSRect overlayRect = NSMakeRect([self parentWindow].frame.origin.x,
                                    [self parentWindow].frame.origin.y, 
                                    [[[self parentWindow] contentView] frame].size.width,
                                    [[[self parentWindow] contentView] frame].size.height);
	
    [self setFrame:overlayRect display:NO];
}

// By default NSWindows cannot become key. We can.
-(BOOL)canBecomeKeyWindow
{
    return YES;
}


@end
