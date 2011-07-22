//
//  VariableCellColumn.m
//  data_m
//
//  Created by Mike Fluff on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableCellColumn.h"


@implementation VariableCellColumn

- (id)dataCellForRow:(NSInteger)row {
    id delegate = [[self tableView] delegate];
    if ([delegate respondsToSelector:@selector(tableColumn:inTableView:dataCellForRow:)]) {
        return [delegate tableColumn:self inTableView:[self tableView] dataCellForRow:row];
    } else {
        return [super dataCellForRow:row];
    }
}
@end
