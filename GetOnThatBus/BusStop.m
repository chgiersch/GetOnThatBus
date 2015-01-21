//
//  BusStop.m
//  GetOnThatBus
//
//  Created by Chris Giersch on 1/20/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import "BusStop.h"

@implementation BusStop

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self._id = dictionary[@"_id"];
        self.position = dictionary[@"_position"];
        self.address = dictionary[@"_address"];
        self.stopID = dictionary[@"stop_id"];
        self.ctaStopName = dictionary[@"cta_stop_name"];
        self.direction = dictionary[@"direction"];
        self.routes = dictionary[@"routes"];
        self.ward = dictionary[@"ward"];
        self.longitude = dictionary[@"longitude"];
        self.latitude = dictionary[@"latitude"];



        self.coordinate = CLLocationCoordinate2DMake(self.longitude.doubleValue, self.latitude.doubleValue);
    }
    return self;
}

@end
