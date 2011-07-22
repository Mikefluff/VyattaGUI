//
//  Reports.h
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pairs, Results, Tests;

@interface Reports : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSSet* Results;
@property (nonatomic, retain) NSSet* Pairs;
@property (nonatomic, retain) Tests * parent;

@end
