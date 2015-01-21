//
//  DetailBusStopViewController.h
//  GetOnThatBus
//
//  Created by Chris Giersch on 1/20/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusStopAnnotation.h"

@interface DetailBusStopViewController : UIViewController

@property BusStopAnnotation *selectedAnnotation;
@property NSMutableArray *busStopsArray;

@end
