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

@interface TopPlacesTableViewController ()

@end

@implementation TopPlacesTableViewController

@synthesize places = _places;

- (void)setPlaces:(NSArray *)places
{
    if (places == _places) return;
    _places = [places sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *string1 = [obj1 objectForKey:FLICKR_PLACE_NAME];
        NSString *string2 = [obj2 objectForKey:FLICKR_PLACE_NAME];
        return [string1 localizedCompare:string2];                
    }];
    [self.tableView reloadData];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.places = [FlickrFetcher topPlaces];
    //NSLog(@"%@", self.places);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Photos from Place"]) {
        [segue.destinationViewController setPlace:
         [self.places objectAtIndex:
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
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSDictionary *place = [self.places objectAtIndex:indexPath.row];
    cell.textLabel.text = [FlickrData titleOfPlace:place];
    cell.detailTextLabel.text = [FlickrData subtitleOfPlace:place];
    
    return cell;
}

#pragma mark - Table view delegate

@end
