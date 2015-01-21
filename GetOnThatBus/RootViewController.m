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
@property Parser *parser;

@end


@implementation RootViewController
#pragma mark - View


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.busStopsArray = [NSMutableArray new];
    self.parser = [Parser new];
    self.parser.delegate = self;
    [self.parser requestDictionaryWithURLString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    [self requestUserPermissionToTrack];    // Request users permission to track location
}


- (void)requestDidFinishWithArray:(NSMutableArray *)array
{
    // Send array of bus stops to get "unpacked" (see helper method)
    self.busStopsArray = array;
    for (BusStop *stop in self.busStopsArray)
    {
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        // Set current BusStop object's coordinate to a new Annotaion coordinate property for new pin
        annotation.coordinate = stop.coordinate;
        // Add annotation to map
        [self.mapView addAnnotation:annotation];
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
