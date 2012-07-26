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

@interface TopPhotosTableViewController ()

@end

@implementation TopPhotosTableViewController

@synthesize place = _place;
@synthesize photos = _photos;

- (void)setPhotos:(NSArray *)photos
{
    if (_photos == photos) return;
    _photos = photos;
    if (self.tableView.window) 
        [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [self titleOfPlace:self.place];    
    self.photos = [FlickrFetcher photosInPlace:self.place maxResults:NUMBER_OF_PHOTOS];
    //NSLog(@"%u %@", [self.photos count], self.photos);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Photo"]) {
        [segue.destinationViewController setPhoto:
         [self.photos objectAtIndex:
          [self.tableView indexPathForSelectedRow].row]];        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Photos Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text = [self titleOfPhoto:photo];
    cell.detailTextLabel.text = [self subtitleOfPhoto:photo];
    return cell;
}

#pragma mark - Table view delegate

@end
