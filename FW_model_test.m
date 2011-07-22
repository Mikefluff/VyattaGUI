//
//  FW_model_test.m
//  data_m
//
//  Created by Mike Fluff on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FW_model_test.h"


@implementation FW_model_test

@synthesize context;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)FillModel
{
    NSManagedObject *firewall = [NSEntityDescription insertNewObjectForEntityForName:@"Firewall_inst" inManagedObjectContext:self.context];
    NSManagedObject *interfaces = [NSEntityDescription insertNewObjectForEntityForName:@"Firewall_inst" inManagedObjectContext:self.context];
    NSManagedObject *networks = [NSEntityDescription insertNewObjectForEntityForName:@"Firewall_inst" inManagedObjectContext:self.context];
    NSManagedObject *services = [NSEntityDescription insertNewObjectForEntityForName:@"Firewall_inst" inManagedObjectContext:self.context];
    [firewall setValue:@"0" forKey:@"id"];
}


- (void)dealloc
{
    [super dealloc];
}

@end
