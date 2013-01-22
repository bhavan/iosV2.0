//
//  SearchHelper.m
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/22/13.
//
//

#import "SearchHelper.h"
#import "UIApplication+NetworkActivity.h"

@implementation SearchHelper
@synthesize partnersList;
@synthesize defaultPartner;
@synthesize nextOffset;
@synthesize loadingMorePartnersInProgress;

#pragma mark -
#pragma mark RKObjectLoaderDelegate

- (id)initWithDelegate:(id<SearchHelperDelegate>)aDelegate
{
    self = [super init];
    if (self)
    {
        delegate = aDelegate;
        self.partnersList = [NSMutableArray array];
        loadingMorePartnersInProgress = NO;
    }
    return self;
}

- (void)objectLoader:(RKObjectLoader *)loader willMapData:(inout id *)mappableData
{
    NSMutableDictionary* data = [[*mappableData objectForKey: @"meta"] mutableCopy];
    if([data objectForKey:@"next_offset"])
    {
        nextOffset = [[data objectForKey:@"next_offset"] integerValue];
    }
    else
    {
        nextOffset = 0;
    }
    [data release];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if (objects)
    {
        [self partnersLoaded:objects];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}

- (void) searchForPartnersWithQuery:(NSString *)query
{
    loadingMorePartnersInProgress = NO;
    [self searchForPartnersWithQuery:query offset:0];
}

- (void)loadMorePartners
{
    loadingMorePartnersInProgress = YES;
    [self searchForPartnersWithQuery:currentSearchQuery offset:nextOffset];

}

- (void) searchForPartnersWithQuery:(NSString *)query offset:(NSInteger)offset
{
    if([partnersList count] > 0 &&
       ![query isEqualToString:DEFAULT_PARTNER_NAME] &&
       !loadingMorePartnersInProgress)
    {
        [partnersList removeAllObjects];
    }
    currentSearchQuery = query;
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] showNetworkActivityIndicator];
    [RequestHelper partnersWithQuery:query offset:offset andDelegate:self];
   
}

- (void)partnersLoaded:(NSArray *)partners
{
    if ([partners count] == 0)
    {
        [UIAlertView showWithTitle:@"Whoops!"
                           message:@"Sorry, but it looks like we dont have a TownWizard in your area yet!"
                          delegate:self
                 cancelButtonTitle:@"OK"
                confirmButtonTitle:nil];
        
    }
    else if([[partners lastObject] isKindOfClass:[Partner class]])
    {
        Partner *partner = [partners lastObject];
        if(partner && [partner.name isEqualToString:DEFAULT_PARTNER_NAME]
           && [currentSearchQuery isEqualToString:DEFAULT_PARTNER_NAME])
        {
            currentSearchQuery = nil;
            defaultPartner = [partner retain];           
            [delegate defaultPartnerLoaded:partner];
        }
        else if(partners.count > 0 && loadingMorePartnersInProgress)
        {            
            [self.partnersList addObjectsFromArray:partners];
            loadingMorePartnersInProgress = NO;
            [delegate partnersLoaded:partnersList];
        }
        else
        {
            self.partnersList = [[[NSMutableArray alloc]initWithArray:partners] autorelease];
            [delegate partnersLoaded:partnersList];
            if (defaultPartner == nil)
            {
                [self searchForPartnersWithQuery:DEFAULT_PARTNER_NAME];
            }
            
        }
    }   
}

- (void)loadNearbyPartners
{
    [self searchForPartnersWithQuery:nil];
}

- (void)dealloc
{
    [partnersList release];
    [defaultPartner release];
    [super dealloc];
}


@end
