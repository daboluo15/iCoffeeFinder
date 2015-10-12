//
//  DetailViewController.h
//  iCoffeeFinderNew
//
//  Created by Bo Gao on 9/30/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSString *detailedImageLink;
@property (nonatomic) NSString *detailedAddress;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *shopName;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *distance;
@property (nonatomic) NSString *tipsText;

@property (nonatomic) UIImageView *myImageView;
@property (nonatomic) MKMapView *myMapView;
@property (nonatomic) UIView *myTextView;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *tips;

@property (weak, nonatomic) IBOutlet UIView *textView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

