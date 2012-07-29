//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 24.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "TopPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrData.h"
#import "FlickrAnnotation.h"

@interface TopPlacesTableViewController ()

@property (nonatomic, strong) NSDictionary *placesByCountry;
@property (nonatomic, strong) NSArray *countries;

@end

@implementation TopPlacesTableViewController

@synthesize places = _places;
@synthesize placesByCountry = _placesByCountry;
@synthesize countries = _countries;

- (void)updatePlacesByCountry
{
    NSMutableDictionary *placesByCountry = [NSMutableDictionary dictionary];
    for (NSDictionary *place in self.places) {
        NSString *country = [FlickrData countryOfPlace:place];
        NSMutableArray *places = [placesByCountry objectForKey:country];
        if (!places) {
            places = [NSMutableArray array];
            [placesByCountry setObject:places forKey:country];
        }
        [places addObject:place];
    }
    self.placesByCountry = placesByCountry;
    NSArray *countries = [placesByCountry allKeys];
    self.countries = [countries sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSCaseInsensitiveSearch];
    }];
}

- (void)setPlaces:(NSArray *)places
{
    if (places == _places) return;
    _places = [places sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *string1 = [obj1 objectForKey:FLICKR_PLACE_NAME];
        NSString *string2 = [obj2 objectForKey:FLICKR_PLACE_NAME];
        return [string1 localizedCompare:string2];                
    }];
    [self updatePlacesByCountry];
    if (self.tableView.window) [self.tableView reloadData];
    self.data = _places;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_queue_t queue = dispatch_queue_create("Flickr Downloader", NULL);
    dispatch_async(queue, ^{
        //NSLog(@"start loading topPlaces");
        [self startSpinner];
        NSArray *places = [FlickrFetcher topPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.places = places;
            [self stopSpinner];
            //NSLog(@"%@", self.places);
            //NSLog(@"finished loading topPlaces");
        });
    });
    dispatch_release(queue);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Photos from Place"]) {
        if ([sender isKindOfClass:[NSDictionary class]]) {
            [segue.destinationViewController setPlace:sender];
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            [segue.destinationViewController setPlace:
             [[self.placesByCountry objectForKey:
               [self.countries objectAtIndex:indexPath.section]
               ] objectAtIndex:indexPath.row]];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.countries count];
}

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section
{
    return [self.countries objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.placesByCountry objectForKey:
             [self.countries objectAtIndex:section]] count];
}

- (NSString *)tableCellIdentfier
{
    return @"Top Places Cell";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *place = [[self.placesByCountry objectForKey:
                            [self.countries objectAtIndex:indexPath.section]
                            ] objectAtIndex:indexPath.row];
    cell.textLabel.text = [FlickrData titleOfPlace:place];
    cell.detailTextLabel.text = [FlickrData subtitleOfPlace:place];
    return cell;
}

#pragma mark - Table view delegate

#pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    FlickrAnnotation *fa = view.annotation;
    [self performSegueWithIdentifier:@"Show Photos from Place" sender:fa.data];
}

@end
