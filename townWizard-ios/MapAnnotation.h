//
//  MapAnnotation.h
//  30A
//
//  Created by MAC1 on 16/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


// types of annotations for which we will provide annotation views. 
typedef enum {
	MapAnnotationTypePin = 0,
	MapAnnotationTypeImage = 1
} MapAnnotationType;


@interface MapAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D	_coordinate;
	MapAnnotationType		_annotationType;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property MapAnnotationType annotationType;
@property (nonatomic, readonly,copy) NSString * title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate 
                   title:(NSString*)sTitle 
          annotationType:(MapAnnotationType)annotationType;

@end
