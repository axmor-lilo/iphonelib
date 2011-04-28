/*
 Copyright (c) 2010, Sungjin Han <meinside@gmail.com>
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
  * Neither the name of meinside nor the names of its contributors may be
    used to endorse or promote products derived from this software without
    specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */
//
//  HTTPParam.m
//  iPhoneLib,
//  Helper Functions and Classes for Ordinary Application Development on iPhone
//
//  Created by meinside on 09. 07. 13.
//
//  last update: 11.04.28.
//

#import "HTTPParam.h"

#import "Logging.h"


@implementation HTTPParam

@synthesize paramType;
@synthesize paramValue;
@synthesize paramName;
@synthesize additionalValues;

#pragma mark -
#pragma mark initializers

- (id)initWithName:(NSString*)name value:(NSData*)data
{
	if((self = [super init]))
	{
		self.paramName = name;
		self.paramValue = data;
		additionalValues = [[NSMutableDictionary alloc] init];
	}
	return self;
}

+ (HTTPParam*)plainParamWithName:(NSString*)name value:(NSString*)someValue
{
	HTTPParam* param = [[HTTPParam alloc] initWithName:name value:[someValue dataUsingEncoding:NSUTF8StringEncoding]];
	param.paramType = HTTPUtilParamTypePlain;
	return [param autorelease];
}

+ (HTTPParam*)fileParamWithName:(NSString*)name fillename:(NSString*)filename content:(NSData*)content contentType:(NSString*)contentType
{
	HTTPParam* param = [[HTTPParam alloc] initWithName:name value:content];
	param.paramType = HTTPUtilParamTypeFile;
	[param.additionalValues setValue:filename forKey:PARAM_FILENAME];
	[param.additionalValues setValue:contentType forKey:PARAM_CONTENTTYPE];
	return [param autorelease];
}

#pragma mark -
#pragma mark getter functions

- (BOOL)isFile
{
	return (paramType == HTTPUtilParamTypeFile);
}

- (BOOL)isPlainText
{
	return (paramType == HTTPUtilParamTypePlain);
}

- (NSString*)fileName
{
	return [additionalValues valueForKey:PARAM_FILENAME];
}

- (NSString*)contentType
{
	return [additionalValues valueForKey:PARAM_CONTENTTYPE];
}

- (NSString*)paramStringValue
{
	NSString* stringValue = [[NSString alloc] initWithData:paramValue encoding:NSUTF8StringEncoding];
	return [stringValue autorelease];
}

#pragma mark -
#pragma mark etc.

- (void)dealloc
{
	[paramValue release];
	[additionalValues release];
	
	[super dealloc];
}


#pragma mark -
#pragma mark overriding NSObject's description function

- (NSString *)description
{
	NSMutableString* description = [NSMutableString string];
	[description appendFormat:@"%@ {", [self class]];

	[description appendFormat:@"paramType = %d", paramType];
	[description appendString:@", "];
	[description appendFormat:@"paramName = %@", paramName];
	[description appendString:@", "];
	[description appendFormat:@"paramValue = %@", paramValue];
	[description appendString:@", "];
	[description appendFormat:@"additionalValues = %@", additionalValues];
	if([self isFile])
	{
		[description appendString:@", "];
		[description appendFormat:@"fileName = %@", [self fileName]];
		[description appendString:@", "];
		[description appendFormat:@"contentType = %@", [self contentType]];
	}
	else
	{
		[description appendString:@", "];
		[description appendFormat:@"paramStringValue = %@", [self paramStringValue]];
	}

	[description appendString:@"}"];	
	return description;
}


@end
