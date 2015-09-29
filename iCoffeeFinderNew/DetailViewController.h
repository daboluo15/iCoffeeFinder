//
//  DetailViewController.h
//  iCoffeeFinderNew
//
//  Created by mahuiye on 9/30/15.
//  Copyright (c) 2015 Bo Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

