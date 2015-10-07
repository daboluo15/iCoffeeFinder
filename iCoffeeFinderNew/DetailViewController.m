//
//  DetailViewController.m
//  iCoffeeFinderNew
//
//  Created by Bo Gao on 9/30/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import "DetailViewController.h"
#import "BigMapViewController.h"
#import "HCSStarRatingView.h"

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
    
    // set imageview round corner
    self.imageView.layer.cornerRadius = 10.0;
    self.imageView.layer.masksToBounds = YES;
    //And to add a border:
    
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView.layer.borderWidth = 2.0;
    
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
    
    // set imageview round corner
    self.mapView.layer.cornerRadius = 10.0;
    self.mapView.layer.masksToBounds = YES;
    //And to add a border:
    
    self.mapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mapView.layer.borderWidth = 2.0;
    
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 10.0;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 2.0;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.name.numberOfLines = 0;
    //This makes your label wrap words as they reach the end of a line
    self.name.lineBreakMode = UILineBreakModeWordWrap;

    self.name.text = self.shopName;
    
    self.address.numberOfLines = 0;
    self.address.lineBreakMode = UILineBreakModeWordWrap;
    self.address.text = self.detailedAddress;
    
    self.tips.numberOfLines = 0;
    self.tips.lineBreakMode = UILineBreakModeWordWrap;
    self.tips.text = [NSString stringWithFormat:@"Tips: %@", self.tipsText];
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(62, 78, 200, 50)];
    starRatingView.maximumValue = 10;
    starRatingView.minimumValue = 0;
    starRatingView.allowsHalfStars = YES;
    starRatingView.accurateHalfStars = YES;
    //starRatingView.value = 8.5;
    starRatingView.value = [self.rating floatValue];
    starRatingView.emptyStarImage = [UIImage imageNamed:@"star_off"];
    starRatingView.halfStarImage = [UIImage imageNamed:@"star_half"]; // optional
    starRatingView.filledStarImage = [UIImage imageNamed:@"star"];
    starRatingView.tintColor = [UIColor redColor];
    [self.textView addSubview:starRatingView];
    
}

- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailedMap"]) {
        BigMapViewController *bigMapViewController = [segue destinationViewController];
        bigMapViewController.coordinate = self.coordinate;
        bigMapViewController.shopName = self.shopName;
    }
}

@end
