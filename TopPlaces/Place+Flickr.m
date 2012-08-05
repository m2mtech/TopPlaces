//
//  Place+Flickr.m
//  TopPlaces
//
//  Created by Martin Mandl on 02.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "Place+Flickr.h"
#import "FlickrFetcher.h"

@implementation Place (Flickr)

+ (Place *)placeFromFlickrInfo:(NSDictionary *)flickrInfo 
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place;    
    NSString *name = [flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"name" 
                                                             ascending:YES]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        NSLog(@"Error in placeFromPhoto: %@ %@", matches, error);
    } else if (![matches count]) {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" 
                                              inManagedObjectContext:context];
        place.name = name;
        place.firstVisited = [NSDate date];        
    } else {
        place = [matches lastObject];
    }    
    return place;
}

@end
