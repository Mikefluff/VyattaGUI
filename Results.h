//
//  Results.h
//  data_m
//
//  Created by Mike Fluff on 4/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pairs, Reports;

@interface Results : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * data;
@property (nonatomic, retain) Pairs * Pair;
@property (nonatomic, retain) Reports * Report;

@end
