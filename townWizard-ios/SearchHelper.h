//
//  SearchHelper.h
//  townWizard-ios
//
//  Created by Vilimets Anton on 1/22/13.
//
//

#import <Foundation/Foundation.h>

@protocol SearchHelperDelegate <NSObject>

- (void)partnersLoaded:(NSArray *)partners;
- (void)defaultPartnerLoaded:(Partner *)defaultPartner;

@end

@interface SearchHelper : NSObject <
UIAlertViewDelegate,
RKObjectLoaderDelegate>
{
    NSString *currentSearchQuery;
    id<SearchHelperDelegate> delegate;    
}

@property (nonatomic, readonly) BOOL loadingMorePartnersInProgress;
@property (nonatomic, readonly) NSInteger nextOffset;
@property (nonatomic, retain) NSMutableArray *partnersList;
@property (nonatomic, retain) Partner *defaultPartner;

- (id)initWithDelegate:(id<SearchHelperDelegate>)aDelegate;
- (void) searchForPartnersWithQuery:(NSString *)query;
- (void) searchForPartnersWithQuery:(NSString *)query offset:(NSInteger)offset;
- (void) loadNearbyPartners;
- (void) partnersLoaded:(NSArray *)partners;
- (void)loadMorePartners;
@end
