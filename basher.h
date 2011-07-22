//
//  basher.h
//  data_m
//
//  Created by Mike Fluff on 03.02.11.
//  Copyright 2011 Altell ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMShellWrapper.h"
#import "SSHCore.h"
#import "Expecter.h"


@protocol basherProto

- (void)processFinished:(id)sender;

@end


@interface basher : NSObject <AMShellWrapperController,SSHController> {
	AMShellWrapper *shellWrapper;
	NSMutableArray *arr;
	id<basherProto>controller;
	NSString *type;
	ssh *myssh;
	Expecter *exp;
	id action;
	int num;
}

@property (nonatomic,retain) NSString *type;

-(id)initWithController:(id <basherProto>)cont addr:(NSString *)addr login:(NSString *)login password:(NSString *)password type:(NSString *)typer;
- (id)startProcess:(NSString *)act;
- (void)checkProcess:(NSString *)act;
- (void)setAction:(NSString *)act;
- (void)startArgProcess:(NSArray *)argument;
- (void)processResult:(NSString *)result;
-(BOOL)copyFile:(NSString *)file toDestinition:(NSString *)destinition;

- (void)runAction;

@end

