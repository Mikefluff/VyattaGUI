//
//  nswind.m
//  view-methods
//
//  Created by Mike Fluff on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "nswind.h"


@implementation nswind

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


@end
