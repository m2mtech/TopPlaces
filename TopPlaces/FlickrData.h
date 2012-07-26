//
//  FlickrData.h
//  TopPlaces
//
//  Created by Martin Mandl on 26.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrData.h"

#define UNKNOWN_PHOTO_TITLE @"Unknown"

@interface FlickrData : NSObject

+ (NSString *)titleOfPlace:(NSDictionary *)place;
+ (NSString *)subtitleOfPlace:(NSDictionary *)place;
+ (NSString *)titleOfPhoto:(NSDictionary *)photo; 
+ (NSString *)subtitleOfPhoto:(NSDictionary *)photo; 

@end
