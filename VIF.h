//
//  VIF.h
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Interface.h"

@class Interface, Pairs;

@interface VIF : Interface {
@private
}
@property (nonatomic, retain) Interface * Interface;
@property (nonatomic, retain) Pairs * Pair;

@end
