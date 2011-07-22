//
//  int_table.h
//  data_m
//
//  Created by Mike Fluff on 01.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface int_table : NSObject {
	IBOutlet NSTableView *inttable;
	NSArray *array;
	NSManagedObjectContext *context;
}

- (IBAction)go:sender;






@end
