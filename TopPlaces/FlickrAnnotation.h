//
//  FlickrAnnotation.h
//  TopPlaces
//
//  Created by Martin Mandl on 28.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FlickrAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSDictionary *data;

+ (FlickrAnnotation *)annotationForData:(NSDictionary *)data;

@end
