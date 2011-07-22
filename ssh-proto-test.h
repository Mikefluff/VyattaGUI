//
//  ssh-proto-test.h
//  data_m
//
//  Created by Mike Fluff on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSHCore.h"
#import "YBGraphView.h"

@interface ssh_proto_test : NSObject <SSHController,YBGraphViewDelegate,YBGraphViewDataSource> {
    NSMutableArray *data;
    YBGraphView *graphview;
    NSMutableArray *indexer;
   // ssh *myssh;
@private
    
}

- (void)processResult:(NSString *)result;
- (void)processActiveResult:(NSArray *)result;
- (void)runTest;

@end
