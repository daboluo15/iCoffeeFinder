//
//  DetailViewController.m
//  iCoffeeFinderNew
//
//  Created by Bo Gao on 9/30/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//            
//        // Update the view.
//        [self configureView];
//    }
}

- (void)configureView {
    // Update the user interface for the detail item.
//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    NSString *photoLink = self.detailedImageLink;
    NSURL *photoURL = [NSURL URLWithString:photoLink];

    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        // Request the image
        NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
        
        if (imageData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *thumbnail = [UIImage imageWithData:imageData];
                [self.imageView initWithImage:thumbnail];
            });
        }
    });
    
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
    
    self.addressLabel.text = self.detailedAddress;
    self.title = self.shopName;

    // Add tap to detailed mapview
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [singleTap requireGestureRecognizerToFail: doubleTap];
    [self.mapView addGestureRecognizer:singleTap];
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    [self performSegueWithIdentifier:@"detailedMap" sender:self];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
