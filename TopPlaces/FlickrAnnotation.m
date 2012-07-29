//
//  FlickrAnnotation.m
//  TopPlaces
//
//  Created by Martin Mandl on 28.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "FlickrAnnotation.h"
#import "FlickrFetcher.h"
#import "FlickrData.h"

@implementation FlickrAnnotation

@synthesize data = _data;

+ (FlickrAnnotation *)annotationForData:(NSDictionary *)data
{
    FlickrAnnotation *annotation = [[FlickrAnnotation alloc] init];
    annotation.data = data;
    return annotation;
}

- (NSString *)title
{
    NSString *place = [self.data objectForKey:FLICKR_PLACE_NAME];
    if (place) return [FlickrData titleOfPlace:self.data];
    return [FlickrData titleOfPhoto:self.data];
}

- (NSString *)subtitle
{
    NSString *place = [self.data objectForKey:FLICKR_PLACE_NAME];
    if (place) return [FlickrData subtitleOfPlace:self.data];
    return [FlickrData subtitleOfPhoto:self.data];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.data objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.data objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
