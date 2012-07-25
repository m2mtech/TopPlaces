//
//  TopPhotosTableViewController.h
//  TopPlaces
//
//  Created by Martin Mandl on 25.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewController.h"

#define NUMBER_OF_PHOTOS 50

@interface TopPhotosTableViewController : CommonTableViewController

@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic, strong) NSArray *photos;

@end
