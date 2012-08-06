//
//  Photo+Flickr.h
//  TopPlaces
//
//  Created by Martin Mandl on 03.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoFromFlickrInfo:(NSDictionary *)flickrInfo 
        inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Photo *)exisitingPhotoWithID:(NSString *)photoID
        inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)removePhoto:(Photo *)photo;
+ (void)removePhotoWithID:(NSString *)photoID
   inManagedObjectContext:(NSManagedObjectContext *)context;


@end
