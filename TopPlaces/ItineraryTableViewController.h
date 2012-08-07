//
//  ItineraryTableViewController.h
//  TopPlaces
//
//  Created by Martin Mandl on 02.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Itinerary.h"

@interface ItineraryTableViewController : UITableViewController //CoreDataTableViewController

@property (nonatomic, strong) NSString *vacation;
@property (nonatomic, strong) Itinerary *itinerary;

@end
