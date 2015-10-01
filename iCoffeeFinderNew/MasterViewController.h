//
//  MasterViewController.h
//  iCoffeeFinderNew
//
//  Created by Bo Gao on 9/30/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MasterViewController : UITableViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic) NSString *venueSection;

@end

