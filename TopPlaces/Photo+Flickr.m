//
//  Photo+Flickr.m
//  TopPlaces
//
//  Created by Martin Mandl on 03.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "Photo+Flickr.h"
#import "Place+Flickr.h"
#import "Tag+Flickr.h"
#import "FlickrFetcher.h"

@implementation Photo (Flickr)

+ (Photo *)photoFromFlickrInfo:(NSDictionary *)flickrInfo 
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", 
                         [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"title" 
                                                             ascending:YES]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || ([matches count] > 1 || error)) {
        NSLog(@"Error in photoFromFlickrInfo: %@ %@", matches, error);
    } else if ([matches count] == 0) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" 
                                              inManagedObjectContext:context];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageUrl = [[FlickrFetcher urlForPhoto:flickrInfo 
                                              format:FlickrPhotoFormatLarge] 
                          absoluteString];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.place = [Place placeFromFlickrInfo:flickrInfo 
                          inManagedObjectContext:context];
        photo.tags = [Tag tagsFromFlickrInfo:flickrInfo 
                      inManagedObjectContext:context];
    } else {
        photo = [matches lastObject];
    }
    return photo;
}

@end
