//
//  FlickrData.m
//  TopPlaces
//
//  Created by Martin Mandl on 26.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "FlickrData.h"
#import "FlickrFetcher.h"
#import "Place.h"
#import "Photo.h"

@implementation FlickrData

+ (NSString *)titleOfPlace:(id)place
{
    NSString *name;
    if ([place isKindOfClass:[NSDictionary class]])
        name = [place objectForKey:FLICKR_PLACE_NAME];
    else if ([place isKindOfClass:[Place class]])
        name = ((Place *)place).name;
    return [[name componentsSeparatedByString:@", "] objectAtIndex:0];
}

+ (NSString *)subtitleOfPlace:(id)place
{
    NSString *name;
    if ([place isKindOfClass:[NSDictionary class]])
        name = [place objectForKey:FLICKR_PLACE_NAME];
    else if ([place isKindOfClass:[Place class]])
        name = ((Place *)place).name;
    NSArray *nameParts = [name componentsSeparatedByString:@", "];
    NSRange range;
    range.location = 1;
    range.length = [nameParts count] - 1;
    return [[nameParts subarrayWithRange:range] componentsJoinedByString:@", "];
}

+ (NSString *)countryOfPlace:(NSDictionary *)place
{
    return [[[place objectForKey:FLICKR_PLACE_NAME] 
             componentsSeparatedByString:@", "] lastObject];    
}

+ (NSString *)titleOfPhoto:(id)photo
{
    NSString *title;
    if ([photo isKindOfClass:[NSDictionary class]])
        title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    else if ([photo isKindOfClass:[Photo class]])
        title = ((Photo *)photo).title;
    if ([title length]) return title;
    if ([photo isKindOfClass:[NSDictionary class]])
        title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    else if ([photo isKindOfClass:[Photo class]])
        title = ((Photo *)photo).subtitle;
    if ([title length]) return title;
    return UNKNOWN_PHOTO_TITLE;
}

+ (NSString *)subtitleOfPhoto:(id)photo
{
    NSString *title = [FlickrData titleOfPhoto:photo];
    if ([title isEqualToString:UNKNOWN_PHOTO_TITLE]) return @"";
    NSString *subtitle;
    if ([photo isKindOfClass:[NSDictionary class]])
        subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    else if ([photo isKindOfClass:[Photo class]])
        subtitle = ((Photo *)photo).subtitle;
    if ([title isEqualToString:subtitle]) return @"";
    return subtitle;
}

@end
