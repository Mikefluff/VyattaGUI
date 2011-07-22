//
//  dev_table.h
//  data_m
//
//  Created by Mike Fluff on 02.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface dev_table : NSObject {
		IBOutlet NSTableView *tableView;
		NSArray *array;
		NSManagedObjectContext *context;
}

//@property (nonatomic, retain) NSManagedObjectContext *context;
+ (dev_table *) sharedInstance;

@end
