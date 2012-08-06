//
//  Tag+Flickr.h
//  TopPlaces
//
//  Created by Martin Mandl on 06.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "Tag.h"

@interface Tag (Flickr)

+ (NSSet *)tagsFromFlickrInfo:(NSDictionary *)flickrInfo 
       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
