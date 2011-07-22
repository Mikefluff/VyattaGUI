//
//  Device.h
//  data_m
//
//  Created by Mike Fluff on 21.04.11.
//  Copyright (c) 2011 Altell ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Interface, Tests;

@interface Device : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * manageip;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * links;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * isServer;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSSet* interface;
@property (nonatomic, retain) Tests * tests;



@end
