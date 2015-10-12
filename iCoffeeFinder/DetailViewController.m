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

#if 1
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10 + 65, self.view.frame.size.width - 20, 190)];
    self.myMapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 210 + 65, self.view.frame.size.width - 20, 190)];
    self.myTextView = [[UIView alloc] initWithFrame:CGRectMake(10, 410 + 65, self.view.frame.size.width - 20,  190)];
    
    self.myImageView.image = [UIImage imageNamed:@"sea"];
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, 190 * 3 + 40 + 65);
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 30, 20)];
    name.numberOfLines = 0;
    name.lineBreakMode = UILineBreakModeWordWrap;
    name.text = self.shopName;
    [name setTextColor:[UIColor blueColor]];
    [name setFont:[UIFont systemFontOfSize:18]];
    
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, self.view.frame.size.width - 30, 20)];
    address.numberOfLines = 0;
    address.lineBreakMode = UILineBreakModeWordWrap;

    address.text = self.detailedAddress;
    
    [address setTextColor:[UIColor grayColor]];
    [address setFont:[UIFont systemFontOfSize:12]];
    
    UILabel *rating = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, self.view.frame.size.width - 30, 40)];
    [rating setTextColor:[UIColor redColor]];
    [rating setFont:[UIFont systemFontOfSize:12]];
    rating.text = @"Rating:";
    
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(5, 90, self.view.frame.size.width - 30, 100)];
    tips.numberOfLines = 0;
    tips.lineBreakMode = UILineBreakModeWordWrap;
    [tips setTextColor:[UIColor darkGrayColor]];

    tips.text = [NSString stringWithFormat:@"Tips: %@", self.tipsText];
    [tips setFont:[UIFont systemFontOfSize:12]];
    

    
    [self.myTextView addSubview:name];
    [self.myTextView addSubview:address];
    [self.myTextView addSubview:rating];
    [self.myTextView addSubview:tips];
    
    // set imageview round corner
    self.myImageView.layer.cornerRadius = 10.0;
    self.myImageView.layer.masksToBounds = YES;
    //And to add a border:
    
    self.myImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.myImageView.layer.borderWidth = 2.0;
    
    // create a region and pass it to the Map View
//    MKCoordinateRegion region;
//    region.center.latitude = self.coordinate.latitude;
//    region.center.longitude = self.coordinate.longitude;
//    region.span.latitudeDelta = 0.1;
//    region.span.longitudeDelta = 0.1;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (self.coordinate, [self.distance floatValue] + 1000, [self.distance floatValue] + 1000);
    MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D myCoordinate;
    myCoordinate.latitude = self.coordinate.latitude;
    myCoordinate.longitude = self.coordinate.longitude;
    annotation.coordinate = myCoordinate;
    [self.myMapView addAnnotation:annotation];
    
    self.myMapView.delegate = self;
    
    self.myMapView.showsUserLocation = YES;
    
    [self.myMapView setRegion:region animated:YES];
    
    
    
    // Add tap to detailed mapview
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self.myMapView addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [singleTap requireGestureRecognizerToFail: doubleTap];
    [self.myMapView addGestureRecognizer:singleTap];
    
    // set imageview round corner
    self.myMapView.layer.cornerRadius = 10.0;
    self.myMapView.layer.masksToBounds = YES;
    //And to add a border:
    
    self.myMapView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.myMapView.layer.borderWidth = 2.0;
    
    self.myTextView.backgroundColor = [UIColor whiteColor];
    self.myTextView.layer.cornerRadius = 10.0;
    self.myTextView.layer.masksToBounds = YES;
    self.myTextView.layer.borderWidth = 2.0;
    self.myTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    
    [scrollview addSubview:self.myImageView];
    [scrollview addSubview:self.myMapView];
    [scrollview addSubview:self.myTextView];
    [self.view addSubview:scrollview];
    
    self.title = self.shopName;
#endif
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        // Request the image
        NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
        
        if (imageData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *thumbnail = [UIImage imageWithData:imageData];
                [self.myImageView initWithImage:thumbnail];
            });
        }
    });
#if 0
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
    
    
    
#endif
    
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
    
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(62, 45, 200, 50)];
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
    [self.myTextView addSubview:starRatingView];
    
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

//- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
//    MKCoordinateRegion region;
//    CLLocationCoordinate2D userLocation;
//    userLocation.latitude = aUserLocation.coordinate.latitude;
//    userLocation.longitude = aUserLocation.coordinate.longitude;
//    region.center.latitude = self.coordinate.latitude;
//    region.center.longitude = self.coordinate.longitude;
//    region.span.latitudeDelta = fabs(userLocation.latitude - self.coordinate.latitude) + 0.01;
//    region.span.longitudeDelta = fabs(userLocation.longitude - self.coordinate.longitude) + 0.01;
//    [aMapView setRegion:region animated:YES];
//}


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
        bigMapViewController.address = self.detailedAddress;
        bigMapViewController.distance = self.distance;
    }
}

@end
