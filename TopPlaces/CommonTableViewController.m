//
//  CommonTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 25.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "CommonTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrData.h"
#import "FlickrCache.h"
#import "FlickrAnnotation.h"

@interface CommonTableViewController () <MKMapViewDelegate>

@property (nonatomic) BOOL showMap;
@property (nonatomic, strong) NSArray *annotations;


@end

@implementation CommonTableViewController

@synthesize spinner = _spinner;
@synthesize mapButton = _mapButton;
@synthesize tableButton = _tableButton;
@synthesize mapView = _mapView;
@synthesize showMap = _showMap;
@synthesize annotations = _annotations;
@synthesize data = _data;

#pragma mark - Setter & Getter

- (void)updateMapView
{
    if (self.mapView.annotations) 
        [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) {
        [self.mapView addAnnotations:self.annotations];    
        FlickrAnnotation *annotation = [self.annotations lastObject]; 
        CLLocationCoordinate2D min = annotation.coordinate;
        CLLocationCoordinate2D max = min;
        for (FlickrAnnotation *annotation in self.annotations) {
            if (annotation.coordinate.latitude < min.latitude)
                min.latitude = annotation.coordinate.latitude;
            else if (annotation.coordinate.latitude > max.latitude)
                max.latitude = annotation.coordinate.latitude;
            if (annotation.coordinate.longitude < min.longitude)
                min.longitude = annotation.coordinate.longitude;
            else if (annotation.coordinate.longitude > max.longitude)
                max.longitude = annotation.coordinate.longitude;            
        }
        MKCoordinateRegion region;
        region.center.longitude = (min.longitude + max.longitude) / 2;
        region.center.latitude = (min.latitude + max.latitude) / 2;
        region.span.latitudeDelta = (max.latitude - min.latitude) * 1.1;
        if (!region.span.latitudeDelta) region.span.latitudeDelta = 1;
        region.span.longitudeDelta = (max.longitude - min.longitude) * 1.1;
        if (!region.span.longitudeDelta) region.span.longitudeDelta = 1;
        [self.mapView setRegion:region];
    }
}

- (void)setAnnotations:(NSArray *)annotations
{
    if (_annotations == annotations) return;
    _annotations = annotations;
    [self updateMapView];
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.data count]];
    for (NSDictionary *item in self.data) 
        [annotations addObject:[FlickrAnnotation annotationForData:item]];
    return annotations;
}

- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.tableView.frame];
        _mapView.autoresizingMask = self.tableView.autoresizingMask;
        _mapView.delegate = self;
        [self.tableView addSubview:_mapView];
        
        NSArray *controllArray = [NSArray arrayWithObjects:@"Normal", @"Satellite", @"Hybrid", nil];
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:controllArray];
        CGPoint center = _mapView.center;
        center.y = _mapView.bounds.origin.y + _mapView.bounds.size.height - segControl.frame.size.height / 2 - 10;
        segControl.center = center;
        segControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        segControl.selectedSegmentIndex = 0;
        [segControl addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventValueChanged];
        
        [_mapView addSubview:segControl];
    }
    return _mapView;
}

#pragma mark - Actions

- (void) changeMapType:(id)sender{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    switch ([segControl selectedSegmentIndex]) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;            
        default:
            self.mapView.mapType = MKMapTypeStandard;
            break;
    }
    
}

- (void)startSpinner
{
    [self.spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
}

- (void)stopSpinner
{
    [self.spinner stopAnimating];
    if (self.showMap)
        self.navigationItem.rightBarButtonItem = self.tableButton;
    else
        self.navigationItem.rightBarButtonItem = self.mapButton;
}

- (IBAction)showMapView:(id)sender 
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];    
    self.navigationItem.rightBarButtonItem = self.tableButton;
    self.annotations = [self mapAnnotations];
    self.mapView.hidden = NO;
    self.showMap = YES;
    [self.tableView bringSubviewToFront:self.mapView];
}

- (IBAction)showTableView:(id)sender 
{
    self.navigationItem.rightBarButtonItem = self.mapButton;
    self.mapView.hidden = YES;
    self.showMap = NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.spinner = [[UIActivityIndicatorView alloc] 
                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(showMapView:)];
    self.tableButton = [[UIBarButtonItem alloc] initWithTitle:@"Table" style:UIBarButtonItemStyleBordered target:self action:@selector(showTableView:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.showMap) [self.tableView bringSubviewToFront:self.mapView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSString *)tableCellIdentfier
{
    return @"Cell";
}

- (NSString *)tableCellTitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Title";
}

- (NSString *)tableCellSubtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Subtitle";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    CellIdentifier = [self tableCellIdentfier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self tableCellTitleForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = [self tableCellSubtitleForRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView 
  willDisplayCell:(UITableViewCell *)cell 
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *photo = [[self.data objectAtIndex:indexPath.row] copy];
    NSNumber *photoID = [photo objectForKey:FLICKR_PHOTO_ID];
    if (!photoID) return;

    cell.imageView.image = [UIImage imageNamed:@"Placeholder"];

    dispatch_queue_t queue = dispatch_queue_create("Flickr Thumbnails", NULL);
    dispatch_async(queue, ^{
        FlickrCache *cache = [FlickrCache cacheFor:@"photos"];
        NSURL *url = [cache urlForCachedPhoto:photo 
                                       format:FlickrPhotoFormatSquare];
        if (!url) url = [FlickrFetcher urlForPhoto:photo
                                            format:FlickrPhotoFormatSquare];
        //NSLog(@"start loading: %@", photoID);
        NSData *data = [NSData dataWithContentsOfURL:url];
        //NSLog(@"finished loading: %@", photoID);
        [cache cacheData:data ofPhoto:photo format:FlickrPhotoFormatSquare];
        if ([[[self.data objectAtIndex:indexPath.row] objectForKey:FLICKR_PHOTO_ID] 
             isEqualToString:[photo objectForKey:FLICKR_PHOTO_ID]]) 
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"changed cell: %@", photoID);
                UIImage *image = [UIImage imageWithData:data]; 
                cell.imageView.image = image;
                [cell setNeedsDisplay];                
            });
    });
    dispatch_release(queue);    
}

#pragma mark - Map view data source

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    aView.annotation = annotation;
    FlickrAnnotation *fa = annotation;
    if ([FlickrData titleOfPlace:fa.data]) {
        aView.leftCalloutAccessoryView = nil;
    } else {
        [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    }
    
    return aView;
}

#pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{ 
    if (!view.leftCalloutAccessoryView) return;

    FlickrAnnotation *fa = view.annotation;
    
    NSDictionary *photo = [fa.data copy];
    NSNumber *photoID = [photo objectForKey:FLICKR_PHOTO_ID];
    if (!photoID) return;
    
    dispatch_queue_t queue = dispatch_queue_create("Flickr Thumbnails", NULL);
    dispatch_async(queue, ^{
        FlickrCache *cache = [FlickrCache cacheFor:@"photos"];
        NSURL *url = [cache urlForCachedPhoto:photo 
                                       format:FlickrPhotoFormatSquare];
        if (!url) url = [FlickrFetcher urlForPhoto:photo
                                            format:FlickrPhotoFormatSquare];
        //NSLog(@"start loading: %@", photoID);
        NSData *data = [NSData dataWithContentsOfURL:url];
        //NSLog(@"finished loading: %@", photoID);
        [cache cacheData:data ofPhoto:photo format:FlickrPhotoFormatSquare];
        if ([[fa.data objectForKey:FLICKR_PHOTO_ID] 
             isEqualToString:[photo objectForKey:FLICKR_PHOTO_ID]]) 
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"changed cell: %@", photoID);
                UIImage *image = [UIImage imageWithData:data];        
                [(UIImageView *)view.leftCalloutAccessoryView setImage:image];
                [view setNeedsDisplay];                
            });
    });
    dispatch_release(queue);    
}

@end
