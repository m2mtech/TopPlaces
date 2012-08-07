//
//  Itinerary.h
//  TopPlaces
//
//  Created by Martin Mandl on 07.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Itinerary : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *places;
@end

@interface Itinerary (CoreDataGeneratedAccessors)

- (void)insertObject:(Place *)value inPlacesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPlacesAtIndex:(NSUInteger)idx;
- (void)insertPlaces:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePlacesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPlacesAtIndex:(NSUInteger)idx withObject:(Place *)value;
- (void)replacePlacesAtIndexes:(NSIndexSet *)indexes withPlaces:(NSArray *)values;
- (void)addPlacesObject:(Place *)value;
- (void)removePlacesObject:(Place *)value;
- (void)addPlaces:(NSOrderedSet *)values;
- (void)removePlaces:(NSOrderedSet *)values;
@end
