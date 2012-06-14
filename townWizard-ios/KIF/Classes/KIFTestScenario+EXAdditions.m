//
//  KIFTestScenario+EXAdditions.m
//  KIF
//
//  Created by Denys Telezhkin on 2/29/12.
//  Copyright (c) 2012 MLSDev. All rights reserved.
//

#import "KIFTestScenario+EXAdditions.h"
#import "KIFTestStep.h"

@implementation KIFTestScenario (EXAdditions)

#define TRANSITION 0.35
#define UPLOAD_PHOTO_WHILE_TESTING 0

+(void)gotoAlmaden:(KIFTestScenario *)scenario
{
    [scenario addStep:[KIFTestStep stepToEnterText:@"Almaden"
                    intoViewWithAccessibilityLabel:@"Search"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"GO"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Almaden Life"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Almaden Life"]];   
    
}

+(void)gotoDestinShines:(KIFTestScenario *)scenario
{
    [scenario addStep:[KIFTestStep stepToEnterText:@"Destin" 
                    intoViewWithAccessibilityLabel:@"Search"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"GO"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Destin Shines"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Destin Shines"]];    
}

+(void)goBack:(KIFTestScenario *)scenario nTimes:(int)n
{
    for (int i=0;i<n;i++)
    {
        [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back"]];
        [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:TRANSITION 
                                                     description:@"transition"]]; 
    }
}

+(void)clearSearchText:(KIFTestScenario *)scenario
{
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Clear text"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Clear text"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Dismiss keyboard"]];
}

+ (id)scenarioToLookInfo;
{
    KIFTestScenario *scenario = [KIFTestScenario 
                                        scenarioWithDescription:@"Test that a user can look info"];

    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Get info"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Get info"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back"]];
    
    return scenario;
}

+ (id)scenarioToCall
{
    KIFTestScenario *scenario = [KIFTestScenario 
                                            scenarioWithDescription:@"Test that a user can call"];
    
    [KIFTestScenario gotoDestinShines:scenario];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Places"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"call"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"call"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Cancel"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    
    [KIFTestScenario goBack:scenario nTimes:2];
    
    [KIFTestScenario clearSearchText:scenario];
    
    return scenario;
}

+ (id)scenarioToOpenMapWithDirections
{
    KIFTestScenario *scenario = [KIFTestScenario 
                                        scenarioWithDescription:@"Test that a user can open map"];

    [KIFTestScenario gotoDestinShines:scenario];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Events"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"more info"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"more info"]];  
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:0.5 description:@"waiting for map"]];
    
    /*
     
     #warning add Tap on address somehow for this to work
     
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Btn Directions"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Btn Directions"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"No"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"No"]];
     
         [KIFTestScenario goBack:scenario nTimes:1];
    */
    [KIFTestScenario goBack:scenario nTimes:3];
    
    [KIFTestScenario clearSearchText:scenario];
    
    return scenario;
}

+ (id)scenarioToUploadPhoto
{
    KIFTestScenario *scenario = 
                    [KIFTestScenario scenarioWithDescription:@"Test that a user can upload photo"];
    
    [KIFTestScenario gotoAlmaden:scenario];
    
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Photos"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Photos"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Btn Camera"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Btn Camera"]];
    [scenario addStep:[KIFTestStep 
                          stepToWaitForTappableViewWithAccessibilityLabel:@"Choose from Library"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Choose from Library"]];
    
    NSArray * choosePhoto = [KIFTestStep stepsToChoosePhotoInAlbum:@"Saved Photos" 
                                                                               atRow:0 
                                                                              column:0];
    NSMutableArray * temp = [choosePhoto mutableCopy];
    [temp removeObjectAtIndex:0];
    [temp removeLastObject];

    choosePhoto  = [NSArray arrayWithArray:temp];
    [temp release];
    
    [scenario addStepsFromArray:choosePhoto];
    
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Btn Upload"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Write a caption..."]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Your name"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"KIF" 
                    intoViewWithAccessibilityLabel:@"Your name"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"Awesome photo" 
                    intoViewWithAccessibilityLabel:@"Photo comment"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done"]];
    
#if !UPLOAD_PHOTO_WHILE_TESTING
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Btn Cancel"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Btn Cancel"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Photos"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Photos"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Cancel"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
#else
    /*
     works, but it'not good to spam photo upload every time =)*/
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Btn Upload"]]; 
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Btn Upload"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Thank you!"]];
    KIFTestStep * step = [[scenario steps] lastObject];
    step.timeout = 20;
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Back"]];
#endif
    

    
    [KIFTestScenario goBack:scenario nTimes:2];
    
    [KIFTestScenario clearSearchText:scenario];
    
    return scenario;
}

+ (id)scenarioToCheckInFacebook
{
    KIFTestScenario *scenario = 
                [KIFTestScenario scenarioWithDescription:@"Test that a user can check in facebook"];
    
    [KIFTestScenario gotoDestinShines:scenario];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Events"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"check in"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"check in"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Check in here"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Check in here"]];
    [scenario addStep:[KIFTestStep 
                       stepToTapRowInTableViewWithAccessibilityLabel:@"Check in here" 
                                                atIndexPath:[NSIndexPath indexPathForRow:3 
                                                                               inSection:0]]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Yes"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Yes"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Post"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"a" 
                    intoViewWithAccessibilityLabel:@"Search for friends"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"My awesome status" 
                    intoViewWithAccessibilityLabel:@"Your status"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Dismiss keyboard"]];
    [scenario addStep:[KIFTestStep 
                       stepToTapRowInTableViewWithAccessibilityLabel:@"Friend list" 
                                                atIndexPath:[NSIndexPath indexPathForRow:0 
                                                                               inSection:0]]];
    [scenario addStep:[KIFTestStep 
                       stepToTapRowInTableViewWithAccessibilityLabel:@"Friend list" 
                                                atIndexPath:[NSIndexPath indexPathForRow:2 
                                                                               inSection:0]]];
    [scenario addStep:[KIFTestStep 
                       stepToTapRowInTableViewWithAccessibilityLabel:@"Friend list" 
                                                atIndexPath:[NSIndexPath indexPathForRow:4 
                                                                               inSection:0]]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Clear text"]];
        [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Dismiss keyboard"]];
    [KIFTestScenario goBack:scenario nTimes:4];
    
    [KIFTestScenario clearSearchText:scenario];
    
    return scenario;
}



@end