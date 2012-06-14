//
//  EXTestController.m
//  KIF
//
//  Created by Denys Telezhkin on 2/29/12.
//  Copyright (c) 2012 MLSDev. All rights reserved.
//

#import "EXTestController.h"
#import "KIFTestScenario+EXAdditions.h"

@implementation EXTestController

- (void)initializeScenarios;
{
    [self addScenario:[KIFTestScenario scenarioToLookInfo]];  
    [self addScenario:[KIFTestScenario scenarioToUploadPhoto]];
    [self addScenario:[KIFTestScenario scenarioToCall]];
    
    // not good test - it will fail if token changed
    //[self addScenario:[KIFTestScenario scenarioToCheckInFacebook]];
    
    
    //Test has a problem with WebView:
   // [self addScenario:[KIFTestScenario scenarioToOpenMapWithDirections]];
}



@end
