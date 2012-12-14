//
//  TWShareKitConfigurator.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 12/6/12.
//
//

#import "TWShareKitConfigurator.h"
#import "AppDelegate.h"

@implementation TWShareKitConfigurator

- (NSString*)appName {
	return @"TownWizard";
}

- (NSString*)appURL {
	return @"https://itunes.apple.com/us/app/townwizard/id507216232?mt=8";
}

- (NSString*)facebookAppId {
	return [AppDelegate sharedDelegate].facebookHelper.appId ;
}

- (NSString*)facebookLocalAppId
{
	return @"";
}

//Change if your app needs some special Facebook permissions only. In most cases you can leave it as it is.
- (NSArray*)facebookListOfPermissions
{
    return [NSArray arrayWithObjects:@"publish_stream", @"offline_access", nil];
}

- (NSString*)twitterConsumerKey
{
	return @"";
}

- (NSString*)twitterSecret
{
	return @"";
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl
{
	return @"";
}
// To use xAuth, set to 1
- (NSNumber*)twitterUseXAuth
{
	return [NSNumber numberWithInt:0];
}
// Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)twitterUsername
{
	return @"";
}


@end
