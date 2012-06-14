//
//  DataHolder.h
//  30A
//
//  Created by Arvind Singh on 16/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AdInfo : NSObject
{
	NSInteger nAdId;
	NSString *sScreenName;
	NSString *sAdImageUrl;
	NSString *sType;
	NSString *sDetails;
}

@property (nonatomic, assign) NSInteger nAdId;
@property (nonatomic, retain) NSString *sScreenName;
@property (nonatomic, retain) NSString *sAdImageUrl;
@property (nonatomic, retain) NSString *sType;
@property (nonatomic, retain) NSString *sDetails;

- (id)initWithAdData:(NSDictionary *)attributeDict;

@end

////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////

@interface PlaceInfo : NSObject 
{
	NSInteger iRestaurantId;
	NSString *sRestaurantName;
	NSString *sPhoneNo;
	double dblLatitude;
	double dblLongitude;
	double dblDistance;
	NSString *sCommunityName;
	NSString *sDescription;
	NSString *sAddress;
	NSString *sZipCode;
	NSString *sUrl;
	BOOL bLoaded;
}

@property (nonatomic, assign) NSInteger iRestaurantId;
@property (nonatomic, retain) NSString *sRestaurantName;
@property (nonatomic, retain) NSString *sPhoneNo;
@property (nonatomic, assign) double dblLatitude;
@property (nonatomic, assign) double dblLongitude;
@property (nonatomic, assign) double dblDistance;
@property (nonatomic, retain) NSString *sCommunityName;
@property (nonatomic, retain) NSString *sDescription;
@property (nonatomic, retain) NSString *sAddress;
@property (nonatomic, retain) NSString *sZipCode;
@property (nonatomic, retain) NSString *sUrl;
@property (nonatomic, assign) BOOL bLoaded;

- (id)initWithRestaurantData:(NSDictionary *)attributeDict;
- (void)setRestaurantDetails:(NSDictionary *)attributeDict;

@end

////////////////////////////////////////////////////////////////////

@interface CommunityInfo : NSObject 
{
	NSInteger iCommunityId;
	NSString *sCommunityName;
}

@property (nonatomic, assign) NSInteger iCommunityId;
@property (nonatomic, retain) NSString *sCommunityName;

- (id)initWithCommunityData:(NSString *)sId Name:(NSString *)sName;

@end

////////////////////////////////////////////////////////////////////

@interface HotSpotInfo : NSObject 
{
	NSInteger iHotSpotId;
	NSString *sHotSpotName;
	NSInteger iRank;
	BOOL bRestaurant;
	NSString *sDetails;
}

@property (nonatomic, assign) NSInteger iHotSpotId;
@property (nonatomic, retain) NSString *sHotSpotName;
@property (nonatomic, assign) NSInteger iRank;
@property (nonatomic, assign) BOOL bRestaurant;
@property (nonatomic, retain) NSString *sDetails;

- (id)initWithHotSpotData:(NSDictionary *)attributeDict;

@end

////////////////////////////////////////////////////////////////////

@interface HotSpotCategoryInfo : NSObject 
{
	NSInteger iCategoryId;
	NSString *sCategoryName;
}

@property (nonatomic, assign) NSInteger iCategoryId;
@property (nonatomic, retain) NSString *sCategoryName;

- (id)initWithHotSpotCategoryData:(NSDictionary *)attributeDict;

@end

////////////////////////////////////////////////////////////////////

@interface UserInfo : NSObject
{	
	NSString *sTwitter_Uid;
	NSString *sTwitter_Pwd;
	NSString *sUserName;
}

@property (nonatomic, retain) NSString *sTwitter_Uid;
@property (nonatomic, retain) NSString *sTwitter_Pwd;
@property (nonatomic, retain) NSString *sUserName;

@end

////////////////////////////////////////////////////////////////////

@interface VideoInfo : NSObject
{
    NSInteger iVideoId;
    NSString *sVideoName;
    NSString *sDescription;
    NSString *sThumbUrl;
    NSString *sVideoUrl;
}

@property (nonatomic, assign) NSInteger iVideoId;
@property (nonatomic, retain) NSString *sVideoName;
@property (nonatomic, retain) NSString *sDescription;
@property (nonatomic, retain) NSString *sThumbUrl;
@property (nonatomic, retain) NSString *sVideoUrl;

- (id)initWithVideoData:(NSDictionary *)attributeDict;

@end

////////////////////////////////////////////////////////////////////

@interface WeatherInfo : NSObject
{    
	NSString *sName;
	NSString *sSRise;
	NSString *sSet;
	NSString *sHeat;
	NSString *sHumidity;
	NSString *sWind;
    NSString *sWeatherTemp;
	NSString *sDayType;
    NSString *sWeatherImgUrl;
	NSMutableArray *arr_DayInfo;
}

@property (nonatomic, retain) NSString *sName;
@property (nonatomic, retain) NSString *sSRise;
@property (nonatomic, retain) NSString *sSet;
@property (nonatomic, retain) NSString *sHeat;
@property (nonatomic, retain) NSString *sHumidity;
@property (nonatomic, retain) NSString *sWind;
@property (nonatomic, retain) NSString *sWeatherTemp;
@property (nonatomic, retain) NSString *sDayType;
@property (nonatomic, retain) NSString *sWeatherImgUrl;
@property (nonatomic, retain) NSMutableArray *arr_DayInfo;


- (id)initWithWeatherData:(NSDictionary *)attributeDict;

@end

////////////////////////////////////////////////////////////////////

@interface DayInfo : NSObject
{    
    NSString *sMinTemp;
	NSString *sMaxTemp;
    NSString *sWeatherImgUrl;
	NSString *sDayName;
}

@property (nonatomic, retain) NSString *sMinTemp;
@property (nonatomic, retain) NSString *sMaxTemp;
@property (nonatomic, retain) NSString *sWeatherImgUrl;
@property (nonatomic, retain) NSString *sDayName;


- (id)initWithDayData:(NSDictionary *)attributeDict;

@end


////////////////////////////////////////////////////////////////////

@interface TownInfo : NSObject
{    
    NSString *sTownName;
	NSString *sZipCode;
    NSString *sEMAIL; 
	double dblLatitude;
	double dblLongitude;
}

@property (nonatomic, retain) NSString *sTownName;
@property (nonatomic, retain) NSString *sZipCode;
@property (nonatomic, retain) NSString *sEMAIL;
@property (nonatomic, assign) double dblLatitude;
@property (nonatomic, assign) double dblLongitude;


- (id)initWithWeatherData:(NSDictionary *)attributeDict;

@end


