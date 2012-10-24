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
@property (nonatomic, assign) BOOL featured;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;

@end
