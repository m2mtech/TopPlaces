//
//  RecentPhotosTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 24.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "RecentPhotosTableViewController.h"
#import "PhotoViewController.h"
#import "FlickrData.h"

@interface RecentPhotosTableViewController ()

@end

@implementation RecentPhotosTableViewController

@synthesize photos = _photos;

- (void)loadPhotos
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.photos = [[defaults objectForKey:RECENTS_PHOTOS_KEY] copy];         
}

- (void)setPhotos:(NSArray *)photos
{
    if (_photos == photos) return;
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadPhotos];
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
    static NSString *CellIdentifier = @"Recent Photos Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text = [FlickrData titleOfPhoto:photo];
    cell.detailTextLabel.text = [FlickrData subtitleOfPhoto:photo];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id vc = [self.splitViewController.viewControllers lastObject];
    if ([vc isKindOfClass:[PhotoViewController class]]) {
        [vc setPhoto:[self.photos objectAtIndex:indexPath.row]];
        [self loadPhotos];        
    }
}

@end
