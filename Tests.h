//
//  Tests.h
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Device, Pairs, Reports;

@interface Tests : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * Type;
@property (nonatomic, retain) NSNumber * Links;
@property (nonatomic, retain) NSSet* Devices;
@property (nonatomic, retain) NSSet* children;
@property (nonatomic, retain) NSSet* Pairs;

@end
