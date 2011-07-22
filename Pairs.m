//
//  Pairs.m
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Pairs.h"
#import "Reports.h"
#import "Results.h"
#import "Tests.h"
#import "VIF.h"


@implementation Pairs
@dynamic id;
@dynamic enabled;
@dynamic Report;
@dynamic Results;
@dynamic VIF;
@dynamic Test;

- (void)addReportObject:(Reports *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Report" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Report"] addObject:value];
    [self didChangeValueForKey:@"Report" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeReportObject:(Reports *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Report" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Report"] removeObject:value];
    [self didChangeValueForKey:@"Report" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addReport:(NSSet *)value {    
    [self willChangeValueForKey:@"Report" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Report"] unionSet:value];
    [self didChangeValueForKey:@"Report" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeReport:(NSSet *)value {
    [self willChangeValueForKey:@"Report" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Report"] minusSet:value];
    [self didChangeValueForKey:@"Report" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addResultsObject:(Results *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Results"] addObject:value];
    [self didChangeValueForKey:@"Results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeResultsObject:(Results *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Results"] removeObject:value];
    [self didChangeValueForKey:@"Results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addResults:(NSSet *)value {    
    [self willChangeValueForKey:@"Results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Results"] unionSet:value];
    [self didChangeValueForKey:@"Results" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeResults:(NSSet *)value {
    [self willChangeValueForKey:@"Results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Results"] minusSet:value];
    [self didChangeValueForKey:@"Results" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}




@end
