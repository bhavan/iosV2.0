//
//  FacebookHelper.h
//  GenericApp
//
//  Created by John Doe on 2/9/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

@protocol FacebookHelperDelegate;

@interface FacebookHelper : NSObject <FBSessionDelegate>
{
	Facebook* facebook;
	id <FacebookHelperDelegate> delegate;
}

@property (nonatomic,retain) Facebook* facebook;
@property (nonatomic,retain) NSString * appId; 
@property (nonatomic, retain) id <FacebookHelperDelegate> delegate;

- (void) authorizePermissions:(NSArray*)permissions for:(id <FacebookHelperDelegate>)theDelegate;
- (void) dialog:(NSString *)action
      andParams:(NSMutableDictionary *)params
    andDelegate:(id <FBDialogDelegate>)theDelegate;

@end

@protocol FacebookHelperDelegate <NSObject>
@optional
- (void) facebookPermissionGranted;
- (void) facebookPermissionNotGranted;
@end


