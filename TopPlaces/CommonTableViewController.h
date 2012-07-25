//
//  CommonTableViewController.h
//  TopPlaces
//
//  Created by Martin Mandl on 25.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UNKNOWN_PHOTO_TITLE @"Unknown"

@interface CommonTableViewController : UITableViewController

- (NSString *)titleOfPlace:(NSDictionary *)place;
- (NSString *)subtitleOfPlace:(NSDictionary *)place;
- (NSString *)titleOfPhoto:(NSDictionary *)photo; 
- (NSString *)subtitleOfPhoto:(NSDictionary *)photo; 

@end
