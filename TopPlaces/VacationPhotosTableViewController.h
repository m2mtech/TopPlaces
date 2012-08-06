//
//  VacationPhotosTableViewController.h
//  TopPlaces
//
//  Created by Martin Mandl on 03.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Place.h"
#import "Tag.h"

@interface VacationPhotosTableViewController : CoreDataTableViewController

@property (nonatomic, strong) NSString *vacation;
@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) Tag *tag;

@end
