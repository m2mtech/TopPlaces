//
//  Itinerary+Single.m
//  TopPlaces
//
//  Created by Martin Mandl on 07.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "Itinerary+Single.h"

@implementation Itinerary (Single)

+ (Itinerary *)singleItineraryInManagedObjectContext:(NSManagedObjectContext *)context
{
    Itinerary *itinerary;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Itinerary"];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];    
    if (!matches || ([matches count] > 1 || error)) {
        NSLog(@"Error in singleItineraryInManagedObjectContext: %@ %@", matches, error);
    } else if ([matches count] == 0) {
        itinerary = [NSEntityDescription insertNewObjectForEntityForName:@"Itinerary" 
                                                  inManagedObjectContext:context];
    } else {
        itinerary = [matches lastObject];
    }
    //NSLog(@"itinerary %@", itinerary);    
    return itinerary;
}

@end
