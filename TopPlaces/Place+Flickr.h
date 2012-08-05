//
//  Place+Flickr.h
//  TopPlaces
//
//  Created by Martin Mandl on 02.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "Place.h"

@interface Place (Flickr)

+ (Place *)placeFromFlickrInfo:(NSDictionary *)flickrInfo 
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
