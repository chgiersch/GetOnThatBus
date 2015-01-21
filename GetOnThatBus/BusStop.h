//
//  BusStop.h
//  GetOnThatBus
//
//  Created by Chris Giersch on 1/20/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BusStop : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property NSString *_id;
@property NSString *position;
@property NSString *address;
@property NSString *stopID;
@property NSString *ctaStopName;
@property NSString *direction;
@property NSString *name;
@property NSArray *routes;
@property NSArray *ward;
@property NSString *longitude;
@property NSString *latitude;
@property NSDictionary *location;
@property CLLocationCoordinate2D coordinate;


@end
