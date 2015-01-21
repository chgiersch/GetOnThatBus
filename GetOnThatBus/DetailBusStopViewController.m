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

    self.stopNameLabel.text = self.selectedAnnotation.stopID;
}

@end
