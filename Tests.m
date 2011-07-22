//
//  Tests.m
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tests.h"
#import "Device.h"
#import "Pairs.h"
#import "Reports.h"


@implementation Tests
@dynamic id;
@dynamic Type;
@dynamic Links;
@dynamic Devices;
@dynamic children;
@dynamic Pairs;

- (void)addDevicesObject:(Device *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Devices" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Devices"] addObject:value];
    [self didChangeValueForKey:@"Devices" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeDevicesObject:(Device *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"Devices" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"Devices"] removeObject:value];
    [self didChangeValueForKey:@"Devices" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addDevices:(NSSet *)value {    
    [self willChangeValueForKey:@"Devices" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Devices"] unionSet:value];
    [self didChangeValueForKey:@"Devices" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeDevices:(NSSet *)value {
    [self willChangeValueForKey:@"Devices" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"Devices"] minusSet:value];
    [self didChangeValueForKey:@"Devices" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addChildrenObject:(Reports *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"children"] addObject:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeChildrenObject:(Reports *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"children"] removeObject:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addChildren:(NSSet *)value {    
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"children"] unionSet:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeChildren:(NSSet *)value {
    [self willChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"children"] minusSet:value];
    [self didChangeValueForKey:@"children" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
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
