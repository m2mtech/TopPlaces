//
//  FlickrData.h
//  TopPlaces
//
//  Created by Martin Mandl on 26.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UNKNOWN_PHOTO_TITLE @"Unknown"
#define RECENTS_PHOTOS_KEY @"RecentWatchedPhotosKey"
#define NUMBER_OF_RECENT_PHOTOS 20

@interface FlickrData : NSObject

+ (NSString *)titleOfPlace:(id)place;
+ (NSString *)subtitleOfPlace:(id)place;

+ (NSString *)countryOfPlace:(NSDictionary *)place;

+ (NSString *)titleOfPhoto:(id)photo; 
+ (NSString *)subtitleOfPhoto:(id)photo; 

@end
