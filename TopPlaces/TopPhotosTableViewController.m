//
//  TopPhotosTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 25.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "TopPhotosTableViewController.h"
#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "FlickrData.h"
#import "FlickrAnnotation.h"

@interface TopPhotosTableViewController ()

@end

@implementation TopPhotosTableViewController

@synthesize place = _place;
@synthesize photos = _photos;

- (void)setPhotos:(NSArray *)photos
{
    if (_photos == photos) return;
    _photos = photos;
    if (self.tableView.window) [self.tableView reloadData];
    self.data = _photos;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startSpinner];
    NSString *title = [FlickrData titleOfPlace:self.place];
    self.navigationItem.title = title;    
    dispatch_queue_t queue = dispatch_queue_create("Flickr Downloader", NULL);
    dispatch_async(queue, ^{
        //NSLog(@"start loading photosInPlace: %@", title);
        NSArray *photos = [FlickrFetcher photosInPlace:self.place maxResults:NUMBER_OF_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = photos;
            [self stopSpinner];
            //NSLog(@"%u %@", [self.photos count], self.photos);
            //NSLog(@"finished loading photosInPlace: %@", title);
        });
    });
    dispatch_release(queue);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Photo"]) {
        if ([sender isKindOfClass:[NSDictionary class]])
        {
            [segue.destinationViewController setPhoto:sender];
        } else {
            [segue.destinationViewController setPhoto:
             [self.photos objectAtIndex:
              [self.tableView indexPathForSelectedRow].row]];                    
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (NSString *)tableCellIdentfier
{
    return @"Top Photos Cell";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text = [FlickrData titleOfPhoto:photo];
    cell.detailTextLabel.text = [FlickrData subtitleOfPhoto:photo];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id vc = [self.splitViewController.viewControllers lastObject];
    if ([vc isKindOfClass:[PhotoViewController class]]) 
        [vc setPhoto:[self.photos objectAtIndex:indexPath.row]];
}

#pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    FlickrAnnotation *fa = view.annotation;
    id vc = [self.splitViewController.viewControllers lastObject];
    if ([vc isKindOfClass:[PhotoViewController class]])
        [vc setPhoto:fa.data];
    else 
        [self performSegueWithIdentifier:@"Show Photo" sender:fa.data];
}

@end
