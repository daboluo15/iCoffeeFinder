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
    
    self.mapView.delegate = self;
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
    annotation.title = self.shopName;
    annotation.subtitle = self.address;
    self.title = self.shopName;
    
    [self.mapView addAnnotation:annotation];
    // show the callout by default without tapping on it
    [self.mapView selectAnnotation:annotation animated:YES];
    
    [self.mapView setRegion:region animated:YES];

}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //if annotation is the user location, return nil to get default blue-dot...
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKUserLocation *userLocation = annotation;
        self.currentLocation = userLocation.coordinate;
        return nil;
    }
    
    // If no pin view already exists, create a new one.
    
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:@"coffee"];
    //MKPinAnnotationView *customPinView = (MKPinAnnotationView*)[self.mapView viewForAnnotation: annotation];
    customPinView.pinColor = MKPinAnnotationColorRed;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    
    // Because this is an iOS app, add the detail disclosure button to display details about the annotation in another view.
#if 0
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;
#else
    
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImage *carImage = [UIImage imageNamed:@"directionGreen"];
    UIImage *carImage = [UIImage imageNamed:@"direction"];
    
    if ([carImage respondsToSelector:@selector(imageWithRenderingMode:)])
    {
        carImage = [carImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    [infoButton setImage:carImage forState: UIControlStateNormal];
    
    infoButton.frame = CGRectMake(0, 0, 32, 32);
    
    customPinView.rightCalloutAccessoryView = infoButton;
#endif
    
    // Add a custom image to the left side of the callout.
    
    UIView *viewLeftAccessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, customPinView.frame.size.height, customPinView.frame.size.height)];
    
    UIImageView *temp=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, customPinView.frame.size.height- 10, customPinView.frame.size.height -10)];
    temp.image = [UIImage imageNamed:@"free-vector-coffee-icon.jpg"];
    temp.contentMode = UIViewContentModeScaleAspectFit;
    
    [viewLeftAccessory addSubview:temp];
    
    customPinView.leftCalloutAccessoryView = viewLeftAccessory;
    
    return customPinView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Coffee Shop");
    }
#if 1
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    [alertView show];
    
    // call apple maps app for direction
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f", self.currentLocation.latitude, self.currentLocation.longitude, self.coordinate.latitude, self.coordinate.longitude]];
    
    [[UIApplication sharedApplication] openURL:url];
#else
    // make phone call and then come back, cannot debug in simulator
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:@"0481215774"];
    //NSString *phoneNumber = [@"tel://" stringByAppendingString:@"0481215774"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
#endif
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
