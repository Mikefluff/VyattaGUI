//
//  graphDataSource.m
//  data_m
//
//  Created by Mike Fluff on 31.03.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import "graphDataSource.h"


@implementation graphDataSource
@synthesize dataSource;


- (void) initWithId:(NSIndexSet *)gid
{
    graph_ids = [[NSIndexSet alloc] initWithIndexSet:gid]; 
    
    series = [[NSMutableArray alloc] initWithCapacity:100];
    
    
    for(int i=1;i<=100;i++)
    {
        [series addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}

- (NSInteger)numberOfGraphsInGraphView:(YBGraphView *)graph {
    
	return [graph_ids count];
    
}

- (NSArray *)graphView:(YBGraphView *)graph valuesForGraph:(NSInteger)index {
	

//    NSArray *tst = [dataSource getDataForGraph:graph_id];
    
    if(index == 0)
        first = [graph_ids firstIndex];
    else
        first = [graph_ids indexGreaterThanIndex:first];
    
//    NSLog(@"%d",first);
    return [NSArray arrayWithArray:[dataSource getDataForGraph:first]];
}

- (NSArray *)seriesForGraphView:(YBGraphView *)graph {
    
    
	return series;
	
	
}

@end
