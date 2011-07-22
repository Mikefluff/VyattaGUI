//
//  testBuilder.m
//  data_m
//
//  Created by Mike Fluff on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "testBuilder.h"
#import "PropertyListCategory.h"
#import <ParseKit/ParseKit.h>
#import "PKParseTree.h"
#import "PKRuleNode.h"
#import "PKTokenNode.h"
#import "PKParseTreeAssembler.h"


@implementation testBuilder
@synthesize context;

- (id)init
{
    self = [super init];
    if (self) {
        config = [[NSMutableString alloc] init];
        tabsNum = 0;
        dic = [[NSMutableDictionary alloc] init];
        // Initialization code here.
    }
    
    return self;
}
- (void)clearConfig
{
    config = [[NSMutableString alloc] initWithString:@""];
   
}

- (void)processObject:(NSManagedObject *)obj withName:(NSString *)name
{
    NSString *tab = [self createTabs:tabsNum];
    NSEntityDescription *entity = [obj entity];
    if(name != nil)
    {
        if([[entity attributesByName] count] == 1 && [[entity relationshipsByName] count] == 0)
            [config appendString:[NSString stringWithFormat:@"%@ %@ %@\n",tab,[[entity name] lowercaseString], name]];
        else
            [config appendString:[NSString stringWithFormat:@"%@ %@ %@ {\n",tab,[[entity name] lowercaseString], name]];
                
    }
    else
    {
        [config appendString:[NSString stringWithFormat:@"%@ %@ {\n",tab,[[entity name] lowercaseString]]];
        
    }
    
    if([[entity attributesByName] count] != 0)
    {
        NSDictionary *entDic = [entity attributesByName];
        for(NSString *str in entDic)
        {
            if([obj valueForKey:str] != nil && ![str isEqualToString:@"id"])
            
                [config appendString:[NSString stringWithFormat:@"%@ %@ %@\n",tab,[str lowercaseString],[obj valueForKey:str]]];
                
        }
    }
    if([[entity relationshipsByName] count] !=0)
    {
        NSDictionary *dic = [entity relationshipsByName];
        for(NSString *str in [entity relationshipsByName])
        {
            tabsNum++;
            NSRelationshipDescription *relationship = [dic valueForKey:str];
            if([obj valueForKey:str] != nil)
            {
                NSString *name = nil;
                if([relationship isToMany])
            {
                NSSet *objSet = [obj valueForKey:str];
                
                for(NSManagedObject *objs in objSet)
                {
                    
                    
                    if([[[objs entity] attributesByName] valueForKey:@"id"] != nil)
                        name = [objs valueForKey:@"id"];
                    [self processObject:objs withName:name];
                }
            }  
            else 
            {
                NSManagedObject *objs = [obj valueForKey:str];
                if([[[objs entity] attributesByName] valueForKey:@"id"] != nil)
                    name = [objs valueForKey:@"id"];
                [self processObject:objs withName:name];
            }
                
            }
            tabsNum--;
        }
    }
    if([[entity attributesByName] count] != 1 && [[entity relationshipsByName] count] != 0)
    {    
        [config appendString:[NSString stringWithFormat:@"%@}\n",tab]];
    }
}

- (void)processObject:(NSManagedObject *)obj
{
     [self processObject:obj withName:nil];
}
        
        
- (void)processEntity:(NSString *)entityName
{
    NSMutableString *tab = [[NSMutableString alloc] initWithString:@""];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    if([[entity attributesByName] count] == 1 && [[entity relationshipsByName] count] == 0)
        [config appendString:[NSString stringWithFormat:@"%@ %@\n",tab,entityName]];
    else
        [config appendString:[NSString stringWithFormat:@"%@ %@ {\n",tab,entityName]];
    if([[entity attributesByName] count] != 0)
    {
        for(NSString *str in [entity attributesByName])
            [config appendString:[NSString stringWithFormat:@"%@ %@\n",tab,str]];
             
    }
    if([[entity relationshipsByName] count] !=0)
    {
    for(NSString *str in [entity relationshipsByName])
    {
        
        [self processEntity:str];
    }
    }
    if([[entity attributesByName] count] != 1 && [[entity relationshipsByName] count] != 0)
        [config appendString:@"}\n"];
    [tab appendString:@"\t"];
   // NSLog(@"%@",config);
}
- (void)addChild:(NSManagedObject *)child forParent:(NSManagedObject *)parent
{
    NSMutableSet *children = [parent mutableSetValueForKey:[[child entity] name]]; [children addObject:child];
}

- (NSManagedObject *)prepareData
{
    NSManagedObject *configa = [NSEntityDescription insertNewObjectForEntityForName:@"Config" inManagedObjectContext:self.context];
    NSManagedObject *interface = [NSEntityDescription insertNewObjectForEntityForName:@"Interfaces" inManagedObjectContext:self.context];
    NSManagedObject *vpn = [NSEntityDescription insertNewObjectForEntityForName:@"Vpn" inManagedObjectContext:self.context];
    [configa setValue:interface forKey:@"Interfaces"];
    [configa setValue:vpn forKey:@"Vpn"];
    NSManagedObject *ethernet = [NSEntityDescription insertNewObjectForEntityForName:@"Ethernet" inManagedObjectContext:self.context];
    [ethernet setValue:@"eth0" forKey:@"id"];
    NSManagedObject *description = [NSEntityDescription insertNewObjectForEntityForName:@"Description" inManagedObjectContext:self.context];
    [description setValue:@"test ethernet" forKey:@"id"];
    [ethernet setValue:description forKey:@"descript"];
    [self addChild:ethernet forParent:interface];
    NSManagedObject *address = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:self.context];
    NSManagedObject *address2 = [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:self.context];
    [address setValue:@"192.168.10.2/24" forKey:@"id"];
    [address2 setValue:@"192.168.11.2/24" forKey:@"id"];
  //  [address setValue:@"192.168.10.2/24" forKey:@"value"];
    [self addChild:address forParent:ethernet];
    [self addChild:address2 forParent:ethernet];
    
    NSManagedObject *ipsec = [NSEntityDescription insertNewObjectForEntityForName:@"Ipsec" inManagedObjectContext:self.context];
    [vpn setValue:ipsec forKey:@"Ipsec"];
    
    
    return configa;
}

- (CGFloat)depthForNode:(PKParseTree *)n {
    CGFloat res = 0;
    for (PKParseTree *child in [n children]) {
        CGFloat n = [self depthForNode:child];
        res = n > res ? n : res;
    }
    
    return res + 1;
}

- (id)parseTree:(PKParseTree *)tr key:(NSString *)key
{
   
        for (id child in [tr children])
    {   
        if ([child isKindOfClass:[PKTokenNode class]]) 
        {
          // NSLog(@"%f",[self depthForNode:child]);
            
          //  [dic setValue:[[(PKTokenNode *)child token] stringValue] forKey:key];
           // NSLog(@"%@",[[(PKTokenNode *)child token] stringValue]);
            return [[(PKTokenNode *)child token] stringValue];
            
        }
        else
        {
           // NSLog(@"%f",[self depthForNode:child]);
          //  NSLog(@"%@",[(PKRuleNode *)child name]);
            if([[(PKRuleNode *)child name] isEqualToString:@"array"])
                NSLog(@"%@",[self parseTree:child key:[(PKRuleNode *)child name]]);
            
            [self parseTree:child key:[(PKRuleNode *)child name]];
            return [(PKRuleNode *)child name];
        }
    }
    
    
}

- (void)backParse:(NSString *)grammarString string:(NSString *)inString
{
    PKParseTreeAssembler *as = [[[PKParseTreeAssembler alloc] init] autorelease];
    PKParser *p = [[PKParserFactory factory] parserFromGrammar:grammarString assembler:as preassembler:as];
    p.tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
    p.tokenizer.numberState.allowsHexadecimalNotation = YES;
    PKParseTree *tr = [p parse:inString];
    [self drawTree:tr];
 //   [self parseTree:tr key:nil];
}  

- (NSString *)labelFromNode:(PKParseTree *)n {
    if ([n isKindOfClass:[PKTokenNode class]]) {
        return [[(PKTokenNode *)n token] stringValue];
    } else if ([n isKindOfClass:[PKRuleNode class]]) {
        return [(PKRuleNode *)n name];
    } else {
        return @"root";
    }
}

- (void)drawTree:(PKParseTree *)n {
    if ([n isKindOfClass:[PKTokenNode class]]) {
        [self drawLeafNode:(id)n];
    } else {
        [self drawParentNode:n];
    }
}

- (void)drawParentNode:(PKParseTree *)n {
    // draw own label
   // [self drawLabel:[self labelFromNode:n]];
    
    NSLog(@"%@",[self labelFromNode:n]);
    NSUInteger c = [[n children] count];
   
    if (1 == c) {
        
        [self drawTree:[[n children] objectAtIndex:0]];
    } else {
        for (int i = 0; i < c; i++) {
            
            [self drawTree:[[n children] objectAtIndex:i]];
        }
    }
    
}

- (void)drawLeafNode:(PKTokenNode *)n {
  //  NSLog(@"%@",[self labelFromNode:n]);
   // [self drawLabel:[self labelFromNode:n] atPoint:NSMakePoint(p.x, p.y)];
}



- (NSString *)createTabs:(NSInteger)num
{
    NSMutableString *tabs = [[[NSMutableString alloc] init] autorelease];
    for(int i=0;i<num;i++)
        [tabs appendString:@"\t"];
    return tabs;
}

- (void)runTest
{
    NSString *gram = [[NSString alloc] initWithString:@"@allowsScientificNotation = YES; @start        = array;        array         =  (Empty | property (property)*); object        = '{' S (Empty | array) '}';     property      = name S value S;                     objects = object | object2 | value; object2 = name S object; name  = Word | Number;             value         = 'null' | boolean | number | string | object | object2 | address;          string        = Word;     number        = Number;     boolean       = 'true' | 'false'; ip = number number number; mask = number; address = ip (Empty | '/' mask); "];
    NSString *str = [[NSString alloc] initWithString:@"interfaces { ethernet eth0 { description test } } "];
    
    [self backParse:gram string:str];
 //   NSLog(@"%@",dic);
    [self clearConfig];
    
    NSManagedObject *configa = [self prepareData];
    [self processObject:configa];
    NSLog(@"%@",config);
    
    NSEntityDescription *entity = [configa entity];
    NSDictionary *dic = [entity relationshipsByName];  
    NSLog(@"%@",[[entity propertiesByName] allKeys]);
    NSRelationshipDescription *rel = [dic valueForKey:@"Interfaces"];
    NSEntityDescription *entity2 = [rel destinationEntity];
    NSLog(@"%@",[[entity2 propertiesByName] allKeys]);
   // NSLog(@"%@\n%@",[[entity attributesByName] allKeys],[[entity relationshipsByName] allKeys]);
    
     
    [self clearConfig];
    [self processEntity:@"Interfaces"];
    NSLog(@"%@",config);
    
    NSManagedObject *test3 = [NSEntityDescription insertNewObjectForEntityForName:@"Config" inManagedObjectContext:self.context];
    
    [test3 myMethod];
    [test3 setValue:@"test" forKey:@"id"];
    NSLog(@"%@",[test3 valueForKey:@"id"]);
    
    
    

}


- (void)dealloc
{
    [super dealloc];
}

@end
