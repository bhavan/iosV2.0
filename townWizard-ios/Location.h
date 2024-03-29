//
//  Location.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/24/12.
//
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *city;

@end
