//
//  VariableCellColumn.h
//  data_m
//
//  Created by Mike Fluff on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (VariableCellColumnDelegate)
- (id)tableColumn:(NSTableColumn *)column inTableView:(NSTableView *)tableView dataCellForRow:(int)row;
@end

@interface VariableCellColumn : NSTableColumn
@end
