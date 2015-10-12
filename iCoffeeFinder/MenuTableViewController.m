//
//  MenuTableViewController.m
//  iCoffeeFinderNew
//
//  Created by mahuiye on 10/1/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import "MenuTableViewController.h"
#import "SWRevealViewController.h"
#import "MasterViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController {
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    menuItems = @[@"title", @"food", @"coffee", @"drinks"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    
    return cell;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    if ([segue.identifier isEqualToString:@"showVenue"]) {
        UINavigationController *navController = segue.destinationViewController;
        MasterViewController *venueController = [navController childViewControllers].firstObject;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        switch (indexPath.row) {
            case 1:
                venueController.venueSection = @"food";
                venueController.title = @"Food";
                break;
                
            case 2:
                venueController.venueSection = @"coffee";
                venueController.title = @"Coffee";
                break;
            case 3:
                venueController.venueSection = @"drinks";
                venueController.title = @"Drinks";
                break;
                
            default:
                venueController.venueSection = @"coffee";
                venueController.title = @"Coffee";

                break;
        }
    }
}

@end
