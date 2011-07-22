//
//  ProgressCell.m
//  data_m
//
//  Created by Mike Fluff on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgressCell.h"


@implementation ProgressCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (id)initProgressCell : (NSProgressIndicator *)aProgressIndicator
{
    if( self = [ super initImageCell:nil ] )
    {
        progressIndicator = [ aProgressIndicator retain ];
        inPROGRESS = YES;
    }
    
    return self;
}

- copyWithZone : (NSZone *)zone
{
    ProgressCell *cell = (ProgressCell *)[ super copyWithZone:zone ];
    cell->progressIndicator = [ progressIndicator retain ];
    return cell;
}

- (void)dealloc
{
    [ progressIndicator release ];
    [ super dealloc ];
}

- (void)setProgressIndicator : (NSProgressIndicator *)aProgressIndicator
{
    if( aProgressIndicator )
    {
        [ progressIndicator release ];
        progressIndicator = [ aProgressIndicator retain ];
    }
}

///////////////////////////////////////////////////////////////////////
//  If you need, you can add - (NSProgressIndicator*) progressIndicator;
///////////////////////////////////////////////////////////////////////

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if ([progressIndicator superview] == nil) {
        [controlView addSubview:progressIndicator];
    }
	
  //  [progressIndicator setDoubleValue:[[self objectValue] doubleValue]];
    
            [progressIndicator setFrame:cellFrame];
        
    
}

- (void)removeProgress
{
   inPROGRESS = NO;
}


@end
