//
//  Tag+Flickr.m
//  TopPlaces
//
//  Created by Martin Mandl on 06.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "Tag+Flickr.h"
#import "FlickrFetcher.h"

@implementation Tag (Flickr)

+ (NSSet *)tagsFromFlickrInfo:(NSDictionary *)flickrInfo 
       inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tagStrings = [[flickrInfo objectForKey:FLICKR_TAGS] componentsSeparatedByString:@" "];
    if (![tagStrings count]) return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSRange range;
    NSArray *matches;
    NSError *error;
    Tag *tag;    
    NSMutableSet *tags = [NSMutableSet setWithCapacity:[tagStrings count]];    
    for (NSString *tagName in tagStrings) {
        tag = nil;
        if (!tagName || [tagName isEqualToString:@""]) continue;
        range = [tagName rangeOfString:@":"];
        if (range.location != NSNotFound) continue;
        
        error = nil;
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", tagName];
        matches = [context executeFetchRequest:request error:&error];
        if (!matches || ([matches count] > 1) || error) {
            NSLog(@"Error in tagsFromFlickrInfo: %@ %@", matches, error);
        } else if (![matches count]) {
            tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" 
                                                inManagedObjectContext:context];
            tag.name = tagName;
            tag.count = [NSNumber numberWithInt:1];
        } else {
            tag = [matches lastObject];
            tag.count = [NSNumber numberWithInt:[tag.count intValue] + 1]; 
        }
        if (tag) [tags addObject:tag];
    }
    return tags;
}

@end
