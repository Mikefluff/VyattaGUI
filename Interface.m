//
//  Interface.m
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Interface.h"
#import "Device.h"
#import "VIF.h"


@implementation Interface
@dynamic id;
@dynamic netmask;
@dynamic mac;
@dynamic ip;
@dynamic device;
@dynamic vifs;


- (void)addVifsObject:(VIF *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"vifs" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"vifs"] addObject:value];
    [self didChangeValueForKey:@"vifs" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeVifsObject:(VIF *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"vifs" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"vifs"] removeObject:value];
    [self didChangeValueForKey:@"vifs" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addVifs:(NSSet *)value {    
    [self willChangeValueForKey:@"vifs" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"vifs"] unionSet:value];
    [self didChangeValueForKey:@"vifs" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeVifs:(NSSet *)value {
    [self willChangeValueForKey:@"vifs" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"vifs"] minusSet:value];
    [self didChangeValueForKey:@"vifs" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
