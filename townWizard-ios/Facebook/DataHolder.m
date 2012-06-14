//
//  DataHolder.m
//  30A
//
//  Created by Arvind Singh on 16/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DataHolder.h"


@implementation AdInfo

@synthesize nAdId, sScreenName, sAdImageUrl, sType, sDetails;

- (id)initWithAdData:(NSDictionary *)attributeDict
{
	if(self = [super init])
	{
		self.nAdId = [[attributeDict valueForKey:@"id"] integerValue];
		self.sScreenName = [attributeDict valueForKey:@"screen"];
		self.sAdImageUrl = [attributeDict valueForKey:@"image"];
		self.sType = [attributeDict valueForKey:@"type"];
		self.sDetails = [attributeDict valueForKey:@"details"];
	}
	return self;
}

- (void)dealloc {
	[sScreenName release];
	[sAdImageUrl release];
	[sType release];
	[sDetails release];
	[super dealloc];
}

@end

////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////

@implementation PlaceInfo

@synthesize iRestaurantId, sRestaurantName, sPhoneNo, dblLatitude, dblLongitude, 
                                                        dblDistance, sCommunityName, sDescription;
@synthesize sAddress, sZipCode, sUrl, bLoaded;

- (id)initWithRestaurantData:(NSDictionary *)attributeDict
{
	if(self = [super init])
	{
		self.iRestaurantId = [[attributeDict valueForKey:@"id"] integerValue];
		self.sRestaurantName = [attributeDict valueForKey:@"name"];
		self.sPhoneNo = [attributeDict valueForKey:@"phone"];
		self.dblLatitude = [[attributeDict valueForKey:@"lat"] doubleValue];
		self.dblLongitude = [[attributeDict valueForKey:@"long"] doubleValue];
		self.dblDistance = [[attributeDict valueForKey:@"distance"] doubleValue];
		self.sCommunityName = [attributeDict valueForKey:@"community"];
	}
	return self;
}

- (void)setRestaurantDetails:(NSDictionary *)attributeDict
{
	self.iRestaurantId = [[attributeDict valueForKey:@"id"] integerValue];
	self.sRestaurantName = [attributeDict valueForKey:@"name"];
	self.sPhoneNo = [attributeDict valueForKey:@"phone"];
	self.dblLatitude = [[attributeDict valueForKey:@"lat"] doubleValue];
	self.dblLongitude = [[attributeDict valueForKey:@"long"] doubleValue];
	self.sCommunityName = [attributeDict valueForKey:@"community"];
	self.sAddress = [attributeDict valueForKey:@"address"];
	self.sZipCode = [attributeDict valueForKey:@"zip"];
	self.sUrl = [attributeDict valueForKey:@"url"];
	if(self.dblDistance == 0) {
		self.dblDistance = [[attributeDict valueForKey:@"distance"] doubleValue];
	}
}

- (void)dealloc {
	[sRestaurantName release];
	[sPhoneNo release];
	[sCommunityName release];
	[sDescription release];
	[sAddress release];
	[sZipCode release];
	[sUrl release];
	[super dealloc];
}

@end

////////////////////////////////////////////////////////////////////

@implementation CommunityInfo

@synthesize iCommunityId, sCommunityName;

- (id)initWithCommunityData:(NSString *)sId Name:(NSString *)sName
{
	if(self = [super init])
	{
		self.iCommunityId = [sId integerValue];
		self.sCommunityName = sName;
	}	
	return self;
}

- (void)dealloc {
	[sCommunityName release];
	[super dealloc];
}

@end

////////////////////////////////////////////////////////////////////

@implementation HotSpotInfo

@synthesize iHotSpotId, sHotSpotName, iRank, bRestaurant, sDetails;

- (id)initWithHotSpotData:(NSDictionary *)attributeDict
{
	if(self = [super init])
	{
		self.iHotSpotId = [[attributeDict valueForKey:@"id"] integerValue];
		self.sHotSpotName = [attributeDict valueForKey:@"name"];
		self.iRank = [[attributeDict valueForKey:@"rank"] integerValue];
		self.bRestaurant = ([[attributeDict valueForKey:@"bRestaurant"] integerValue] == 1) ? YES:NO;
		self.sDetails = [attributeDict valueForKey:@"details"];
	}	
	return self;
}

- (void)dealloc {
	[sHotSpotName release];
	[sDetails release];
	[super dealloc];
}

@end

////////////////////////////////////////////////////////////////////

@implementation HotSpotCategoryInfo

@synthesize iCategoryId, sCategoryName;

- (id)initWithHotSpotCategoryData:(NSDictionary *)attributeDict
{
	if(self = [super init])
	{
		self.iCategoryId = [[attributeDict valueForKey:@"id"] integerValue];
		self.sCategoryName = [attributeDict valueForKey:@"name"];
	}	
	return self;
}

- (void)dealloc {
	[sCategoryName release];
	[super dealloc];
}

@end

////////////////////////////////////////////////////////////////////

@implementation UserInfo

@synthesize sTwitter_Uid, sTwitter_Pwd, sUserName;

- (id)init {
	if(self = [super init])	{	
		sTwitter_Uid = @"";
		sTwitter_Pwd = @"";
		sUserName = @"";
	}
	return self;
}

- (void)dealloc {		
	[super dealloc];
}

@end

////////////////////////////////////////////////////////////////////

@implementation VideoInfo

@synthesize iVideoId, sVideoName, sDescription, sThumbUrl, sVideoUrl;

- (id)initWithVideoData:(NSDictionary *)attributeDict
{
    if(self = [super init])
    {
        self.iVideoId = [[attributeDict valueForKey:@"id"] integerValue];
        self.sVideoName = [attributeDict valueForKey:@"name"];
        self.sDescription = [attributeDict valueForKey:@"desc"];
        self.sThumbUrl = [attributeDict valueForKey:@"thumbnail"];
        self.sVideoUrl = [attributeDict valueForKey:@"videourl"];
    }   
    return self;
}

- (void)dealloc {
    [sVideoName release];
    [sDescription release];
    [sThumbUrl release];
    [sVideoUrl release];
    [super dealloc];
}

@end

////////////////////////////////////////////////////////////////////

@implementation WeatherInfo

@synthesize sWeatherTemp, sHeat, sWeatherImgUrl, sName, sDayType, sSRise, sSet, 
                                                                    sWind, sHumidity, arr_DayInfo;

- (id)initWithWeatherData:(NSDictionary *)attributeDict
{
    if(self = [super init])
    {
        self.sWeatherTemp = [attributeDict valueForKey:@"id"];
        self.sWeatherImgUrl = [attributeDict valueForKey:@"name"];
	}   
    return self;
}

- (void)dealloc {
    [sWeatherImgUrl release];
    [sWeatherTemp release];
	[sHeat release];
	[sName release];
	[sDayType release];
	[sSRise release];
	[sSet release];
	[sHumidity release];
	[sWind release];
	[arr_DayInfo release];
    [super dealloc];
}

@end


////////////////////////////////////////////////////////////////////

@implementation DayInfo

@synthesize sMinTemp, sMaxTemp, sWeatherImgUrl, sDayName;

- (id)initWithDayData:(NSDictionary *)attributeDict
{
    if(self = [super init])
    {
	}   
    return self;
}

- (void)dealloc {
    [sWeatherImgUrl release];
    [sMaxTemp release];
	[sMinTemp release];
	[sDayName release];
    [super dealloc];
}

@end


////////////////////////////////////////////////////////////////////

@implementation TownInfo

@synthesize sTownName, sZipCode, sEMAIL, dblLatitude, dblLongitude;

- (id)initWithWeatherData:(NSDictionary *)attributeDict
{
    if(self = [super init])
    {
        self.sTownName = [attributeDict valueForKey:@"townname"];
        self.sZipCode = [attributeDict valueForKey:@"zip"];
		self.sEMAIL = [attributeDict valueForKey:@"email"];
		self.dblLatitude = [[attributeDict valueForKey:@"latitude"] doubleValue];
		self.dblLongitude = [[attributeDict valueForKey:@"longitude"] doubleValue];
	}   
    return self;
}

- (void)dealloc {
    [sTownName release];
    [sZipCode release];
	[sEMAIL release];
    [super dealloc];
}

@end




