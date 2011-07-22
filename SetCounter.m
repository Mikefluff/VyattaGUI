//
//  SetCounter.m
//  data_m
//
//  Created by Mike Fluff on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetCounter.h"


@implementation SetCounter

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (Class)transformedValueClass
{
    return [NSNumber self];
}

+ (BOOL) allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    return [NSNumber numberWithInt:[value count]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
