//
//  MasterViewController.m
//  iCoffeeFinderNew
//
//  Created by mahuiye on 9/30/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "MasterViewController.h"
#import "DetailViewController.h"

#define kCLIENTID @"JQONBD0F5T2H4OQLUX2ZCJCUVUGGTYS3VGJBI2ZMFWYDTVUU"
#define kCLIENTSECRET @"YWLECSO3N21YMWJC1OKSO21JWZMYRBNLFP4TCGFAYU0LLVJ4"

static NSString * const BaseURLString = @"https://api.foursquare.com";
static NSString *exploreAPI = @"https://api.foursquare.com/v2/venues/explore";


@interface MasterViewController ()

@property NSMutableArray *objects;
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
        }
        
        //Extracting out the venues array from the list and put into new array
        //venueList = NSArray()
//        for result in resultList{
//            venueList = venueList.arrayByAddingObject(Venue(venue:result.objectForKey("venue") as! NSDictionary))
//        }
//        tableView.reloadData()
//        return venueList

        
//        self.weather = (NSDictionary *)responseObject;
//        self.title = @"JSON Retrieved";
//        [self.tableView reloadData];
        
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
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
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
