//
//  Interface.h
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Device, VIF;

@interface Interface : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * netmask;
@property (nonatomic, retain) NSNumber * mac;
@property (nonatomic, retain) NSNumber * ip;
@property (nonatomic, retain) Device * device;
@property (nonatomic, retain) NSSet* vifs;

@end
