//
//  Section.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/1/12.
//
//

#import <Foundation/Foundation.h>

@interface Section : NSObject
{
    NSString *sectionId;
    NSString *displayName;
    NSString *name;
    NSString *url;
    NSString *imageUrl;
    NSString *partner_id;
    NSArray *subSections;
    NSString *uiType;
}

@property (nonatomic, retain) NSString *sectionId;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *partnerId;
@property (nonatomic, retain) NSArray *subSections;
@property (nonatomic, retain) NSString *uiType;

+ (RKObjectMapping *)objectMapping;

@end
