//
//  FlickrData.m
//  TopPlaces
//
//  Created by Martin Mandl on 26.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "FlickrData.h"
#import "FlickrFetcher.h"

@implementation FlickrData

+ (NSString *)titleOfPlace:(NSDictionary *)place
{
    return [[[place objectForKey:FLICKR_PLACE_NAME] 
             componentsSeparatedByString:@", "] objectAtIndex:0];
}

+ (NSString *)subtitleOfPlace:(NSDictionary *)place
{
    NSArray *nameParts = [[place objectForKey:FLICKR_PLACE_NAME] 
                          componentsSeparatedByString:@", "];
    NSRange range;
    range.location = 1;
    range.length = [nameParts count] - 1;
    return [[nameParts subarrayWithRange:range] componentsJoinedByString:@", "];
}

+ (NSString *)titleOfPhoto:(NSDictionary *)photo
{
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    if ([title length]) return title;
    title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([title length]) return title;
    return UNKNOWN_PHOTO_TITLE;
}

+ (NSString *)subtitleOfPhoto:(NSDictionary *)photo
{
    if ([[photo objectForKey:FLICKR_PHOTO_TITLE] length])
        return [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    return @"";
}

@end
