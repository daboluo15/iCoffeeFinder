//
//  MasterViewController.m
//  iCoffeeFinderNew
//
//  Created by Bo Gao on 9/30/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "VenueEntryTableViewCell.h"
#import "SWRevealViewController.h"

#define kCLIENTID @"JQONBD0F5T2H4OQLUX2ZCJCUVUGGTYS3VGJBI2ZMFWYDTVUU"
#define kCLIENTSECRET @"YWLECSO3N21YMWJC1OKSO21JWZMYRBNLFP4TCGFAYU0LLVJ4"

static NSString * const BaseURLString = @"https://api.foursquare.com";
static NSString *exploreAPI = @"https://api.foursquare.com/v2/venues/explore";


@interface MasterViewController ()

@property NSMutableArray *objects;
@property NSMutableArray *venues;
@property NSString *currentCoordinate;
@end

@implementation MasterViewController

CLLocationManager *locationManager;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    self.currentCoordinate = @"-37.881199,145.163190"; // 95 Kingsway, Glen Waverley VIC 3150
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    // update location every 600 m
    locationManager.distanceFilter = 600;
    [locationManager startUpdatingLocation];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // remove the seperator between two cell
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.parentViewController.view.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // set the small egde below the navigation header and the first tableview Cell
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        //longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        //latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        self.currentCoordinate = [NSString stringWithFormat:@"%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    }
    [self loadJsonVenues];
}

#pragma mark - AFNetworking Json handling
- (void)loadJsonVenues {
    //
    //    "\(exploreAPI)?client_id=\(clientId)&client_secret=\(clientSecret)&v=\(version)&m=\(method)&ll=\(latLong)&section=\(exploreSection)&venuePhotos=\(venuePhotos)&sortByDistance=\(sortByDistance)&openNow=\(openNow)"
    
    //NSString *latlon = @"-37.881199,145.163190"; // 95 Kingsway, Glen Waverley VIC 3150
    NSString *latlon;
    if (self.currentCoordinate == nil) {
        latlon = @"-37.881199,145.163190"; // 95 Kingsway, Glen Waverley VIC 3150
    }else {
        latlon = [NSString stringWithString:self.currentCoordinate];
    }
    
    //NSString *latlon = @"-37.85,145.10"; // 20 Hughes Street Burwood VIC 3125
    //NSString *section = @"coffee";
    if (self.venueSection == nil) {
        self.venueSection = @"coffee";
        self.title = @"Coffee";
    }
    NSLog(@"self.venueSection = %@", self.venueSection);
    
    self.venues = [[NSMutableArray alloc] init];
    
    NSString *string = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&v=20150930&m=foursquare&ll=%@&section=%@&venuePhotos=1&sortByDistance=1&openNow=1", exploreAPI, kCLIENTID, kCLIENTSECRET, latlon, self.venueSection];
    NSLog(@"exploreURL is %@", string);
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // clear the old value
        [self.venues removeAllObjects];
        
        // 3
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        NSLog(@"jsonDict = %@", jsonDict);
        NSDictionary *responseDict = [jsonDict objectForKey:@"response"];
        NSArray *groupsArray = [responseDict objectForKey:@"groups"];
        NSDictionary *groupsDict = [groupsArray firstObject];
        NSArray *resultList = [groupsDict objectForKey:@"items"];
        
        for (NSDictionary* result in resultList) {
            NSDictionary *venue = [result objectForKey:@"venue"];
            NSLog(@"venue name = %@", [venue objectForKey:@"name"]);
            NSString *name = [venue objectForKey:@"name"];
            NSNumber *rating = [venue objectForKey:@"rating"];
            
            NSDictionary *location = [venue objectForKey:@"location"];
            NSString *address = [NSString stringWithFormat:@"%@, %@ %@ %@", [location objectForKey:@"address"], [location objectForKey:@"city"], [location objectForKey:@"state"], [location objectForKey:@"postalCode"]];
            NSString *distance = [location objectForKey:@"distance"];
            NSInteger intDistance = [distance intValue];
            CLLocationDegrees lat = [[location objectForKey:@"lat"] doubleValue];
            CLLocationDegrees lng = [[location objectForKey:@"lng"] doubleValue];
            //CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
            CLLocation *coordinate = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
//            To get the CLLocationCoordinate struct back from CLLocation, call coordinate on the object.
//            
//            CLLocationCoordinate2D coord = [[currentDisplayedTowers lastObject] coordinate];
            
            NSLog(@"location: distance=%ldm lat=%f, lng=%f address = %@", (long)intDistance, lat, lng, address);
            
            //get the photos link for cafe
            NSDictionary *featuredPhotos = [venue objectForKey:@"featuredPhotos"];
            NSArray *itemsReturned = [featuredPhotos objectForKey:@"items"];
            NSDictionary *photos = [itemsReturned objectAtIndex:0];
            NSString *photosLink = [NSString stringWithFormat:@"%@%@x%@%@", [photos objectForKey:@"prefix"], [photos objectForKey:@"width"], [photos objectForKey:@"height"], [photos objectForKey:@"suffix"]];
            NSLog(@"photos link=%@", photosLink);
            
            NSArray *tipsArray = [result objectForKey:@"tips"];
            NSDictionary *tips = tipsArray[0];
            NSString *tipsText = [tips objectForKey:@"text"];
            
            NSMutableDictionary *venueLocal = [[NSMutableDictionary alloc] init];
            if (name != nil) {
                [venueLocal setObject:name  forKey:@"name"];
            }
            if (rating != nil) {
                [venueLocal setObject:rating forKey:@"rating"];
            }
            if (distance != nil) {
                [venueLocal setObject:distance forKey:@"distance"];
            }
            if (address != nil) {
                [venueLocal setObject:address forKey:@"address"];
            }
            if (coordinate != nil) {
                [venueLocal setObject:coordinate forKey:@"coordinate"];
            }
            if (photosLink != nil) {
                [venueLocal setObject:photosLink forKey:@"photoLink"];
            }
            if (tipsText != nil) {
                [venueLocal setObject:tipsText forKey:@"tips"];
            }
            [self.venues addObject:venueLocal];
            
        }
        
        //Extracting out the venues array from the list and put into new array
        //venueList = NSArray()
//        for result in resultList{
//            venueList = venueList.arrayByAddingObject(Venue(venue:result.objectForKey("venue") as! NSDictionary))
//        }
//        tableView.reloadData()
//        return venueList

        
//        self.weather = (NSDictionary *)responseObject;
          //self.title = @"JSON Retrieved";
          [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Coffee"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

    
    // 5
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = self.objects[indexPath.row];
        if (indexPath.row <= self.venues.count) {
            NSDictionary *object = self.venues[indexPath.row];
            
            DetailViewController* detailedViewController = [segue destinationViewController];
            detailedViewController.detailedImageLink = [object objectForKey:@"photoLink"];
            detailedViewController.detailedAddress = [object objectForKey:@"address"];
            detailedViewController.coordinate = [[object objectForKey:@"coordinate"] coordinate];
            detailedViewController.shopName = [object objectForKey:@"name"];
            detailedViewController.rating = [object objectForKey:@"rating"];
            detailedViewController.tipsText = [object objectForKey:@"tips"];
            detailedViewController.distance = [object objectForKey:@"distance"];
            
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VenueEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    //NSDate *object = self.objects[indexPath.row];
    //This allows for multiple lines
    cell.name.numberOfLines = 0;
    //This makes your label wrap words as they reach the end of a line
    cell.name.lineBreakMode = UILineBreakModeWordWrap;
    cell.name.text = [[self.venues objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *addressAndDistance = [NSString stringWithFormat:@"%@", [[self.venues objectAtIndex:indexPath.row] objectForKey:@"address"]];
    cell.address.numberOfLines = 0;
    //This makes your label wrap words as they reach the end of a line
    cell.address.lineBreakMode = UILineBreakModeWordWrap;
    cell.address.text = addressAndDistance;
    NSString *distance = [NSString stringWithFormat:@"%@ m", [[self.venues objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    cell.distance.text = distance;
    
    NSString *photoLink = [[self.venues objectAtIndex:indexPath.row] objectForKey:@"photoLink"];
    NSURL *photoURL = [NSURL URLWithString:photoLink];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        // Request the image
        NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
        
        if (imageData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 4. Set image in cell
                CGSize itemSize = CGSizeMake(80, 80);
                UIGraphicsBeginImageContext(itemSize);
                
                UIImage *thumbnail = [UIImage imageWithData:imageData];
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [thumbnail drawInRect:imageRect];
                
                // set round corner
                cell.myImageView.layer.masksToBounds = YES;
                cell.myImageView.layer.cornerRadius = 10.0;
                cell.myImageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [cell setNeedsLayout];
            });
        }
    });

    [cell.contentView.layer setCornerRadius:7.0f];
    [cell.contentView.layer setMasksToBounds:YES];
    
    UIImage *background = [UIImage imageNamed:@"rectangle-fat"];
    UIImageView *cellImageBackgroundView = [[UIImageView alloc] initWithFrame:cell.bounds];
    cellImageBackgroundView.image = background;
    cell.backgroundView = cellImageBackgroundView;
    
    UIImage *selectedBackGround = [UIImage imageNamed:@"rectangle-fat-gray"];
    UIImageView *cellSelectedView = [[UIImageView alloc] initWithFrame:cell.bounds];
    cellSelectedView.image = selectedBackGround;
    cell.selectedBackgroundView = cellSelectedView;
    
    
    cell.backgroundColor = [UIColor clearColor];


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Determine cell height based on screen
    return 120;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

@end
