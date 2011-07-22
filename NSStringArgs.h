//
//  NSStringArgs.h
//  ssh-obj
//
//  Created by Mike Fluff on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSStringPerso)
+ (NSString *)setContentWithFormat:(NSString *)formatString arguments:(NSArray *)arguments;
+ (NSString *)setContentWithFormat:(NSString *)formatString, ...;
+ (NSString *)MyStringWithRandomUppercaseLetter:(int)len;


-(NSArray *)csvRows;
-(NSString *) shuffledString;
@end
