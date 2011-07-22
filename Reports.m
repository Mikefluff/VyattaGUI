//
//  Reports.m
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Reports.h"
#import "Pairs.h"
#import "Results.h"
#import "Tests.h"


@implementation Reports
@dynamic date;
@dynamic id;
@dynamic Results;
@dynamic Pairs;
@dynamic parent;

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


- (void)addPairsObject:(Pairs *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Pairs" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Pairs"] addObject:value];
    [self didChangeValueForKey:@"Pairs" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePairsObject:(Pairs *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Pairs" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Pairs"] removeObject:value];
    [self didChangeValueForKey:@"Pairs" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPairs:(NSSet *)value {    
    [self willChangeValueForKey:@"Pairs" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Pairs"] unionSet:value];
    [self didChangeValueForKey:@"Pairs" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePairs:(NSSet *)value {
    [self willChangeValueForKey:@"Pairs" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Pairs"] minusSet:value];
    [self didChangeValueForKey:@"Pairs" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
