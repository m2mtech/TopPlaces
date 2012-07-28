//
//  FlickrCache.h
//  TopPlaces
//
//  Created by Martin Mandl on 28.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

#define MAX_FLICKR_CACHE_SIZE 1024*1024*10

@interface FlickrCache : NSObject

+ (FlickrCache *)cacheFor:(NSString *)folder;

- (NSURL *)urlForCachedPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

- (void)cacheData:(NSData *)data ofPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

@end
