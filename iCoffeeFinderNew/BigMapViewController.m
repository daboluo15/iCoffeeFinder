//
//  BigMapViewController.m
//  iCoffeeFinderNew
//
//  Created by mahuiye on 10/1/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import "BigMapViewController.h"

@interface BigMapViewController ()

@end

@implementation BigMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // create a region and pass it to the Map View
    MKCoordinateRegion region;
    region.center.latitude = self.coordinate.latitude;
    region.center.longitude = self.coordinate.longitude;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D myCoordinate;
    myCoordinate.latitude = self.coordinate.latitude;
    myCoordinate.longitude = self.coordinate.longitude;
    annotation.coordinate = myCoordinate;
    [self.mapView addAnnotation:annotation];
    
    [self.mapView setRegion:region animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeMapStyle:(id)sender {
    
    switch (self.mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
