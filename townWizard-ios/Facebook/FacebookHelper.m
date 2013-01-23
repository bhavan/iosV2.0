//
//  FacebookHelper.m
//  GenericApp
//
//  Created by John Doe on 2/9/11.
//  Copyright 2011 TownWizard. All rights reserved.
//

#import "FacebookHelper.h"
#import "Facebook.h"

@implementation FacebookHelper
@synthesize appId=_appId;
@synthesize delegate;

-(NSString *)appId
{
    if (!_appId)
        return @"";
    else return _appId;
}

- (id) init
{
	if (self = [super init])
    {
		//appId = [[[GenericAppAppDelegate sharedDelegate].appConfig configForKey:@"facebook_app_id"] retain];
        
        //appId for testing:
         self.appId = @"107352225952816";
        
		self.facebook = [[[Facebook alloc] init] autorelease];
		self.facebook.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessToken"];
        
		self.facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"ExpirationDate"];
	}
	
	return self;
}

- (void) authorizePermissions:(NSArray*)permissions for:(id <FacebookHelperDelegate>)theDelegate
{
	if ([facebook isSessionValid] == NO)
    {
		delegate = theDelegate;
		[self.facebook authorize:self.appId permissions:permissions delegate:self];
	}
	else {
		[theDelegate facebookPermissionGranted];
	}
}

#pragma mark FBSessionDelegate

- (void) fbDidLogin
{
	[[NSUserDefaults standardUserDefaults] setObject:self.facebook.accessToken
                                              forKey:@"AccessToken"];
	[[NSUserDefaults standardUserDefaults] setObject:self.facebook.expirationDate
                                              forKey:@"ExpirationDate"];
    if ([delegate respondsToSelector:@selector(facebookPermissionGranted)])
        [delegate facebookPermissionGranted];
    
    [TestFlight passCheckpoint:@"facebook login successful"];
}

- (void) fbDidNotLogin:(BOOL)cancelled
{
    if ([delegate respondsToSelector:@selector(facebookPermissionNotGranted)])
        [delegate facebookPermissionNotGranted];
    
    [TestFlight passCheckpoint:@"facebook login failed"];
}

- (void) dialog:(NSString *)action andParams:(NSMutableDictionary *)params
    andDelegate:(id <FBDialogDelegate>)theDelegate
{
	[params setObject:self.appId forKey:@"api_key"];
	[self.facebook dialog:action andParams:params andDelegate:theDelegate];
}

#pragma mark -
#pragma mark Memory management

- (void) dealloc
{
	self.facebook = nil;
	[_appId release];
	[super dealloc];
}

#pragma mark -

@synthesize facebook;

@end
