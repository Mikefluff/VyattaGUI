//
//  Device.m
//  data_m
//
//  Created by Mike Fluff on 21.04.11.
//  Copyright (c) 2011 Altell ltd. All rights reserved.
//

#import "Device.h"
#import "Interface.h"
#import "Tests.h"


@implementation Device
@dynamic manageip;
@dynamic id;
@dynamic links;
@dynamic type;
@dynamic isServer;
@dynamic login;
@dynamic password;
@dynamic interface;
@dynamic tests;



- (void)addInterfaceObject:(Interface *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"interface" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"interface"] addObject:value];
    [self didChangeValueForKey:@"interface" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeInterfaceObject:(Interface *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"interface" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"interface"] removeObject:value];
    [self didChangeValueForKey:@"interface" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addInterface:(NSSet *)value {    
    [self willChangeValueForKey:@"interface" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"interface"] unionSet:value];
    [self didChangeValueForKey:@"interface" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeInterface:(NSSet *)value {
    [self willChangeValueForKey:@"interface" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"interface"] minusSet:value];
    [self didChangeValueForKey:@"interface" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
