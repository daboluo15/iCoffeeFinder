//
//  BigMapViewController.h
//  iCoffeeFinderNew
//
//  Created by mahuiye on 10/1/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BigMapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@end
