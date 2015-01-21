//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Chris Giersch on 1/20/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "RootViewController.h"
#import "DetailBusStopViewController.h"
#import <MapKit/MapKit.h>
#import "BusStopAnnotation.h"
#import "Parser.h"

@interface RootViewController () <MKMapViewDelegate, ParserDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *busStopsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property Parser *parser;
@property NSMutableArray *annotationArray;
@end




@implementation RootViewController

//--------------------------------------   View    -------------------------------------------
#pragma mark - View
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.hidden = YES;
    self.busStopsArray = [NSMutableArray new]; // create array to hold finished BusStop objects
    self.parser = [Parser new];                // create Parser object to get and reformat data from JSON
    self.parser.delegate = self;               // set parser delegate to SELF
    self.mapView.delegate = self;
    [self.parser requestDictionaryWithURLString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"]; // request data with JSON web url
    [self requestUserPermissionToTrack];    // Request users permission to track location
}

- (IBAction)onSegmentPressed:(UISegmentedControl *)sender
{
    if ([sender selectedSegmentIndex] == 0)
    {
        self.mapView.hidden = NO;
        self.tableView.hidden = YES;
    }
    else if ([sender selectedSegmentIndex] == 1)
    {
        self.mapView.hidden = YES;
        self.tableView.hidden = NO;
    }
}

//--------------------------------   Table View Delegates    -------------------------------------
#pragma mark - Table View Delegates
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BusStopAnnotation *busStop = [self.busStopsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = busStop.ctaStopName;
    cell.detailTextLabel.text = busStop.routes;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.busStopsArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailSegue" sender:tableView];
}

//-----------------------------------   Parcer Delegate    ----------------------------------------
#pragma mark - Parcer Delegate
- (void)requestDidFinishWithArray:(NSMutableArray *)array
{
//    self.busStopsArray = array;
    [self loadPinsFromArray:array];
    [self.tableView reloadData];
}


//--------------------------------------   Map View    --------------------------------------------
#pragma mark - Map View
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // Create a pop-up window (annotation view) for called upon pin in map view
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    // enable ability to view pop-up window
    pin.canShowCallout = YES;
    // Set pop-up window view type
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    BusStopAnnotation *busStopAnnotation = annotation;
    if ([busStopAnnotation.inter_modal isEqualToString:@"Metra"])
    {
        pin.pinColor = MKPinAnnotationColorGreen;
    }
    else if ([busStopAnnotation.inter_modal isEqualToString:@"Pace"])
    {
        pin.pinColor = MKPinAnnotationColorPurple;
    }
    else
    {
        return nil;
    }
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"DetailSegue" sender:view];
}

- (void)loadPinsFromArray:(NSMutableArray *)array
{
    // Send array of bus stops to get "unpacked" (see helper method)
    //self.busStopsArray = array;
    for (BusStopAnnotation *stop in array)
    {
        stop.title = stop.ctaStopName;
        stop.subtitle = stop.routes;
        // Add annotation to array
        [self.busStopsArray addObject:stop];
        // Add annotation to map
        [self.mapView addAnnotation:stop];
    }
//    BusStopAnnotation *busStop = [self.busStopsArray objectAtIndex:0];
//    CLLocationCoordinate2D centerCoordinate = busStop.coordinate;
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
//    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
//    [self.mapView setRegion:region animated:YES];

}


//-----------------------------------   Prepare For Segue    ----------------------------------------
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailBusStopViewController *detailVC = segue.destinationViewController;
    if ([sender isKindOfClass:[MKAnnotationView class]])
    {
        MKAnnotationView *annotationView = sender;
        BusStopAnnotation *busStop = annotationView.annotation;
        detailVC.selectedAnnotation = busStop;
    }
    else if ([sender isKindOfClass:[UITableView class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailVC.selectedAnnotation = [self.busStopsArray objectAtIndex:indexPath.row];
    }
}

//-------------------------------------   Permissions    ------------------------------------------
#pragma mark - Permissions
- (void)requestUserPermissionToTrack
{
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
//    self.mapView.showsUserLocation = YES;
}


@end
