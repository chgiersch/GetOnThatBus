//
//  DetailBusStopViewController.m
//  GetOnThatBus
//
//  Created by Chris Giersch on 1/20/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "DetailBusStopViewController.h"
#import "BusStopAnnotation.h"

@interface DetailBusStopViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferLabel;

@end

@implementation DetailBusStopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.stopNameLabel.text = self.selectedAnnotation.ctaStopName;
    [self reverseGeocodeAddressFromCoordinate:self.selectedAnnotation.coordinate];
    self.routeLabel.text = [NSString stringWithFormat:@"Route: %@", self.selectedAnnotation.routes];
    self.transferLabel.text = self.selectedAnnotation.inter_modal; 
}


- (void)reverseGeocodeAddressFromCoordinate:(CLLocationCoordinate2D)coordinate
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if (error)
        {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        if (placemarks && placemarks.count > 0)
        {
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *addressDictionary = placemark.addressDictionary;
            NSString *address = [addressDictionary objectForKey:@"Name"];
            self.addressLabel.text = address;
        }
    }];
}


@end
