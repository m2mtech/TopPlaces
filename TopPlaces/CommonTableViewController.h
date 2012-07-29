//
//  CommonTableViewController.h
//  TopPlaces
//
//  Created by Martin Mandl on 25.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CommonTableViewController : UITableViewController

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIBarButtonItem *mapButton;
@property (nonatomic, strong) UIBarButtonItem *tableButton;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSArray *data;

- (void)startSpinner;
- (void)stopSpinner;

- (NSString *)tableCellIdentfier;
- (NSString *)tableCellTitleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableCellSubtitleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
