//
//  Video.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 10/2/12.
//
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) NSString *url;

- (NSURL *)thumbURL;

@end
