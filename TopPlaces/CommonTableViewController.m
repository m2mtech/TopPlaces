//
//  CommonTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 25.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "CommonTableViewController.h"
#import "FlickrFetcher.h"

@interface CommonTableViewController ()

@end

@implementation CommonTableViewController

- (NSString *)titleOfPlace:(NSDictionary *)place
{
    return [[[place objectForKey:FLICKR_PLACE_NAME] 
             componentsSeparatedByString:@", "] objectAtIndex:0];
}

- (NSString *)subtitleOfPlace:(NSDictionary *)place
{
    NSArray *nameParts = [[place objectForKey:FLICKR_PLACE_NAME] 
                          componentsSeparatedByString:@", "];
    NSRange range;
    range.location = 1;
    range.length = [nameParts count] - 1;
    return [[nameParts subarrayWithRange:range] componentsJoinedByString:@", "];
}

#pragma mark - View lifecycle

#pragma mark - Table view data source

#pragma mark - Table view delegate

@end
