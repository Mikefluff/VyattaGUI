//
//  Pairs.h
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Reports, Results, Tests, VIF;

@interface Pairs : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSSet* Report;
@property (nonatomic, retain) NSSet* Results;
@property (nonatomic, retain) VIF * VIF;
@property (nonatomic, retain) Tests * Test;

@end
