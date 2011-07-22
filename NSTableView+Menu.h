//
//  NSTableView+Menu.h
//  data_m
//
//  Created by Mike Fluff on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ContextMenuDelegate <NSObject>
- (NSMenu*)tableView:(NSTableView*)aTableView menuForRows:(NSIndexSet*)rows;
@end

@interface NSTableView (ContextMenu)

@end