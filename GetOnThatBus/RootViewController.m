//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Chris Giersch on 1/20/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "RootViewController.h"
#import <MapKit/MapKit.h>
#import "BusStop.h"
#import "Parser.h"

@interface RootViewController () <MKMapViewDelegate, ParserDelegate>

@property NSMutableArray *busStopsArray;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableArray *busStopAnnotationArray;           // Array to hold multiple MKPointAnnotations
@property CLLocationManager *locationManager;


@end


@implementation RootViewController
#pragma mark - View


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.busStopsArray = [NSMutableArray new];

    [self fetchAndUnpackJSONData];          // Fetch and reformat data into BusStop objects (See unpack method)
    [self requestUserPermissionToTrack];    // Request users permission to track location

    for (BusStop *stop in self.busStopsArray)
    {
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        // Set current BusStop object's coordinate to a new Annotaion coordinate property for new pin
        annotation.coordinate = stop.coordinate;
        // Add annotation to map
        [self.mapView addAnnotation:annotation];
    }

}

- (void)fetchAndUnpackJSONData
{
    // Setting the original JSON link to a url object
    NSURL *originalJsonURL = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    // Turn URL into URLRequest
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:originalJsonURL];
    // JSON Request block call
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         // Fetching the JSON dictionary of bus stops from original JSON link
         NSDictionary *tempDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

         
         // Get "Master" array of data from dictionary
         NSArray *busStopsArrayFromRequest = [tempDictionary objectForKey:@"row"];
         // Send array of bus stops to get "unpacked" (see helper method)
         [self unpackDictionary:busStopsArrayFromRequest];

     }];
}

- (void)unpackDictionary:(NSArray *)array
{
    // Take each dictionary (bus stop) in array of Bus Stops and "unpack" into BusStop objects (set all BusStop properties in BusStop model class)
    for (NSDictionary *dict in array)
    {
        BusStop *stopWithFullDetails = [[BusStop alloc] initWithDictionary:dict];
        // Add BusStop object to busStopArray
        [self.busStopsArray addObject:stopWithFullDetails];
    }
}












#pragma mark - Permissions
- (void)requestUserPermissionToTrack
{
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;
}


@end
