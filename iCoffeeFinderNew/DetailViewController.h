//
//  DetailViewController.h
//  iCoffeeFinderNew
//
//  Created by mahuiye on 9/30/15.
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
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

