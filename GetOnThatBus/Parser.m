//
//  Parser.m
//  GetOnThatBus
//
//  Created by Chris Giersch on 1/20/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "Parser.h"
#import "BusStopAnnotation.h"

@implementation Parser

- (void)requestDictionaryWithURLString:(NSString *)urlString
{
    // Setting the original JSON link to a url object
    NSURL *originalJsonURL = [NSURL URLWithString:urlString];
    // Turn URL into URLRequest
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:originalJsonURL];
    // JSON Request block call
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         // Fetching the JSON dictionary of bus stops from original JSON link
         NSDictionary *tempDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         // Get "Master" array of data from dictionary
         NSMutableArray *busStopsArrayFromRequest = [tempDictionary objectForKey:@"row"];
         [self unpackDictionariesFromArray:busStopsArrayFromRequest];
     }];
}

- (void)unpackDictionariesFromArray:(NSMutableArray *)array
{
    NSMutableArray *reformattedBusStopsArray = [NSMutableArray new];
    // Take each dictionary (bus stop) in array of Bus Stops and "unpack" into BusStop objects (set all BusStop properties in BusStop model class)
    for (NSDictionary *dict in array)
    {
        BusStopAnnotation *busStopObjectWithFullDetails = [[BusStopAnnotation alloc] initWithDictionary:dict];
        // Add BusStop object to busStopArray
        [reformattedBusStopsArray addObject:busStopObjectWithFullDetails];
    }
    [self.delegate requestDidFinishWithArray:reformattedBusStopsArray];
}













@end
