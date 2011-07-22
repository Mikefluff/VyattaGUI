//
//  PropertyListCategory.m
//  data_m
//
//  Created by Mike Fluff on 4/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PropertyListCategory.h"
#import <objc/runtime.h>

@implementation NSManagedObject (PropertyListCategory)

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}

- (void)myMethod {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithCString:propName];
            NSString *propertyType = [NSString stringWithCString:propType];
            NSLog(@"%@, %@",propertyName, propertyType);
            
        }
    }
    free(properties);
}

@end
