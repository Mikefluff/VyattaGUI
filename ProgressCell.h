//
//  ProgressCell.h
//  data_m
//
//  Created by Mike Fluff on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AppKit/Appkit.h>

@interface ProgressCell : NSCell
{
    NSProgressIndicator *progressIndicator;
    BOOL inPROGRESS;
}

- (id)initProgressCell : (NSProgressIndicator *)aProgressIndicator;
- (void)removeProgress;


@end


