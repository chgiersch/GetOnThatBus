//
//  Parser.m
//  GetOnThatBus
//
//  Created by Chris Giersch on 1/20/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "Parser.h"
#import "BusStop.h"

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
     }];
}

- (void)unpackDictionariesFromArray:(NSMutableArray *)array
{
    NSMutableArray *tempBusStopArray = [NSMutableArray new];
    // Take each dictionary (bus stop) in array of Bus Stops and "unpack" into BusStop objects (set all BusStop properties in BusStop model class)
    for (NSDictionary *dict in array)
    {
        BusStop *stopWithFullDetails = [[BusStop alloc] initWithDictionary:dict];
        // Add BusStop object to busStopArray
        [tempBusStopArray addObject:stopWithFullDetails];
    }
    [self.delegate requestDidFinishWithArray:tempBusStopArray];
}














@end
