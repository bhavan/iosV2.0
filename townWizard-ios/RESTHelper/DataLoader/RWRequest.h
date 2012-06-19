//
//  RequestLoader.h
//  muddler
//
//  Created by Evgeniy Kirpichenko on 11/21/11.
//  Copyright (c) 2011 MLS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWRequestDelegate.h"
#import "JSONDataParser.h"

typedef id (^ParsingBlock)(JSONDataParser * parser);

@interface RWRequest : NSOperation <NSURLConnectionDelegate> {
    NSURLRequest *urlRequest;
    NSURLConnection *urlConnection;
    NSMutableArray *observers;
    
    NSMutableData *receivedData;
    
    id userInfo;
    id response;
    NSError *error;
    
    BOOL finished;
}

- (id) initWithRequest:(NSURLRequest *) aRequest;
- (void) cancelRequest;

- (void) registerObserver:(id<RWRequestDelegate>) observer;
- (void) removeObserver:(id<RWRequestDelegate>) observer;

@property (nonatomic,readonly) NSURLRequest *urlRequest;
@property (nonatomic,assign) NSInteger attempsToRemain;
@property (nonatomic,retain) ParsingBlock parsingBlock;

@property (nonatomic,readonly) id response;
@property (nonatomic,readonly) NSError *error;
@property (nonatomic,retain) id userInfo;
@property (nonatomic,readonly) BOOL isFinished;

@end



