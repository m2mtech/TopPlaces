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

- (NSString *)titleOfPhoto:(NSDictionary *)photo
{
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    if ([title length]) return title;
    title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([title length]) return title;
    return UNKNOWN_PHOTO_TITLE;
}

- (NSString *)subtitleOfPhoto:(NSDictionary *)photo
{
    if ([[photo objectForKey:FLICKR_PHOTO_TITLE] length])
        return [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    return @"";
}

#pragma mark - View lifecycle

#pragma mark - Table view data source

#pragma mark - Table view delegate

@end
