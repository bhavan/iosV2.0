//
//  MapAnnotation.m
// 30A
//
//  Created by MAC1 on 16/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate = _coordinate;
@synthesize annotationType = _annotationType;
@synthesize title = _titleLabel;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate 
                   title:(NSString*)sTitle 
          annotationType:(MapAnnotationType)annotationType;
{
	self = [super init];
	
	_coordinate = coordinate;
	_annotationType = annotationType;
	_titleLabel = [sTitle retain];
	
	return self;
}

- (void) dealloc
{
	[_titleLabel release];
	[super dealloc];
}

@end
