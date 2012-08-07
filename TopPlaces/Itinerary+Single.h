//
//  Itinerary+Single.h
//  TopPlaces
//
//  Created by Martin Mandl on 07.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "Itinerary.h"

@interface Itinerary (Single)

+ (Itinerary *)singleItineraryInManagedObjectContext:(NSManagedObjectContext *)context;

@end
