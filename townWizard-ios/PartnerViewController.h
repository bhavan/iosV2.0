//
//  PartnerViewController.h
//  townWizard-ios
//
//  Created by Evgeniy Kirpichenko on 10/19/12.
//
//

#import "MasterDetailController.h"
#import "Partner.h"

@interface PartnerViewController : MasterDetailController {
}

- (id) initWithPartner:(Partner *) partner;

@property (nonatomic, retain, readonly) Partner *partner;

@end
