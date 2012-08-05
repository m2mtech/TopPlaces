//
//  Photo.h
//  TopPlaces
//
//  Created by Martin Mandl on 03.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Place *place;

@end
