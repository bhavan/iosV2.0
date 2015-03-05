//
//  Event.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Event : NSObject

@property (nonatomic, assign) NSInteger eventID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSNumber *featured;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;

- (NSString *) eventDateString;

- (NSComparisonResult)compareByDate:(Event *)event;

@end
