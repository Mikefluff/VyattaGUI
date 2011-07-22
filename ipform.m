//
//  ipform.m
//  data_m
//
//  Created by Mike Fluff on 12.04.10.
//  Copyright 2010 Altell ltd. All rights reserved.
//

#import "ipform.h"

@implementation IPFormatter

- (NSString *)stringForObjectValue:(id)obj
{
	unsigned int  ipNumber;
	
	if([obj isKindOfClass:[NSNumber class]])
	{
		ipNumber  = [obj unsignedIntValue];
	}
	else
	{
		ipNumber  = [obj intValue];
	}
	
	return [NSString stringWithFormat: @"%u.%u.%u.%u",
			(ipNumber >> 24) & 0xFF,
			(ipNumber >> 16) & 0xFF,
			(ipNumber >> 8) & 0xFF,
			ipNumber & 0xFF];
}

unsigned long ConvertPart(NSString *part)
{
	if(part)
		return strtoul([part UTF8String], NULL, 0);
	else
		return 0;
}

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string
	  errorDescription:(NSString **)error
{
	//Remove any characters that are not in [0-9xX.]
	NSMutableString *tempString          = [NSMutableString
											stringWithString: string];
	NSCharacterSet  *illegalCharacters    = [[NSCharacterSet
											  characterSetWithCharactersInString:@"0123456789xX."] invertedSet];
	NSRange        illegalCharacterRange = [tempString
											rangeOfCharacterFromSet: illegalCharacters];
	
	while(illegalCharacterRange.location != NSNotFound)
	{
		[tempString deleteCharactersInRange: illegalCharacterRange];
		illegalCharacterRange = [tempString rangeOfCharacterFromSet:
								 illegalCharacters];
	}
	
	string          = tempString;
	
	NSArray *parts  = [string componentsSeparatedByString: @"."];
	
	switch([parts count])
	{
		case 0:
			*obj  = [NSNumber numberWithUnsignedLong: 0];
			return TRUE;
			
		case 1:
			*obj  = [NSNumber numberWithUnsignedLong: ConvertPart([parts
																   objectAtIndex: 0])];
			return TRUE;
			
		case 2:
			*obj  = [NSNumber numberWithUnsignedLong: (((ConvertPart([parts
																	  objectAtIndex: 0]) & 0xFF) << 24) |
													   ((ConvertPart([parts
																	  objectAtIndex: 1]) & 0xFF) << 16))];
			return TRUE;
			
		case 3:
			*obj  = [NSNumber numberWithUnsignedLong: (((ConvertPart([parts
																	  objectAtIndex: 0]) & 0xFF) << 24) |
													   ((ConvertPart([parts
																	  objectAtIndex: 1]) & 0xFF) << 16) |
													   ((ConvertPart([parts
																	  objectAtIndex: 2]) & 0xFF) << 8))];
			return TRUE;
			
		case 4:
			*obj  = [NSNumber numberWithUnsignedLong: (((ConvertPart([parts
																	  objectAtIndex: 0]) & 0xFF) << 24) |
													   ((ConvertPart([parts
																	  objectAtIndex: 1]) & 0xFF) << 16) |
													   ((ConvertPart([parts
																	  objectAtIndex: 2]) & 0xFF) << 8) |
													   (ConvertPart([parts
																	 objectAtIndex: 3]) & 0xFF))];
			return TRUE;
			
		default:
			return FALSE;
	}
}

@end
