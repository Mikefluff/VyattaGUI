//
//  FW_model_test.h
//  data_m
//
//  Created by Mike Fluff on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FW_model_test : NSObject {
    NSManagedObjectContext *context;
@private
    
}

-(void)FillModel;

@property (nonatomic, retain) NSManagedObjectContext *context;
@end
