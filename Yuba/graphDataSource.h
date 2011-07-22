//
//  graphDataSource.h
//  data_m
//
//  Created by Mike Fluff on 31.03.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBGraphView.h"



@protocol GraphsDataSource

-(NSArray *)getDataForGraph:(NSInteger)graph;

@end


@interface graphDataSource : NSObject <YBGraphViewDelegate,YBGraphViewDataSource> {
    id dataSource;
    NSIndexSet *graph_ids;
    NSMutableArray *series;
    int first;
}

@property (nonatomic, retain) id dataSource;


- (void) initWithId:(NSIndexSet *)gid;



@end
