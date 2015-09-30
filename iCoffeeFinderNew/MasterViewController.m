//
//  MasterViewController.m
//  iCoffeeFinderNew
//
//  Created by mahuiye on 9/30/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>
#import "MasterViewController.h"
#import "DetailViewController.h"

#define kCLIENTID @"JQONBD0F5T2H4OQLUX2ZCJCUVUGGTYS3VGJBI2ZMFWYDTVUU"
#define kCLIENTSECRET @"YWLECSO3N21YMWJC1OKSO21JWZMYRBNLFP4TCGFAYU0LLVJ4"

static NSString * const BaseURLString = @"https://api.foursquare.com";
static NSString *exploreAPI = @"https://api.foursquare.com/v2/venues/explore";


@interface MasterViewController ()

@property NSMutableArray *objects;
@property NSMutableArray *venues;
@end

@implementation MasterViewController

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
    [self loadJsonVenues];
}

#pragma mark - AFNetworking Json handling
- (void)loadJsonVenues {
    //
    //    "\(exploreAPI)?client_id=\(clientId)&client_secret=\(clientSecret)&v=\(version)&m=\(method)&ll=\(latLong)&section=\(exploreSection)&venuePhotos=\(venuePhotos)&sortByDistance=\(sortByDistance)&openNow=\(openNow)"
    
    NSString *latlon = @"-37.881199,145.163190"; // 95 Kingsway, Glen Waverley VIC 3150
    //NSString *latlon = @"-37.85,145.10"; // 20 Hughes Street Burwood VIC 3125
    NSString *section = @"coffee";
    
    self.venues = [[NSMutableArray alloc] init];
    
    NSString *string = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&v=20150930&m=foursquare&ll=%@&section=%@&venuePhotos=1&sortByDistance=1&openNow=1", exploreAPI, kCLIENTID, kCLIENTSECRET, latlon, section];
    NSLog(@"exploreURL is %@", string);
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
            
            NSMutableDictionary *venueLocal = [[NSMutableDictionary alloc] init];
            [venueLocal setObject:name  forKey:@"name"];
            [venueLocal setObject:distance forKey:@"distance"];
            [venueLocal setObject:address forKey:@"address"];
            [venueLocal setObject:coordinate forKey:@"coordinate"];
            [venueLocal setObject:photosLink forKey:@"photoLink"];
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
          self.title = @"JSON Retrieved";
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
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    //NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [[self.venues objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *addressAndDistance = [NSString stringWithFormat:@"%@    %@m", [[self.venues objectAtIndex:indexPath.row] objectForKey:@"address"], [[self.venues objectAtIndex:indexPath.row] objectForKey:@"distance"]];
    cell.detailTextLabel.text = addressAndDistance;
    
    NSString *photoLink = [[self.venues objectAtIndex:indexPath.row] objectForKey:@"photoLink"];
    NSURL *photoURL = [NSURL URLWithString:photoLink];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        // Request the image
        NSData *imageData = [NSData dataWithContentsOfURL:photoURL];
        
        if (imageData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 4. Set image in cell
                CGSize itemSize = CGSizeMake(32, 32);
                UIGraphicsBeginImageContext(itemSize);
                
                UIImage *thumbnail = [UIImage imageWithData:imageData];
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [thumbnail drawInRect:imageRect];
                
                // set round corner
                cell.imageView.layer.masksToBounds = YES;
                cell.imageView.layer.cornerRadius = 10.0;
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [cell setNeedsLayout];
            });
        }
    });

    return cell;
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
