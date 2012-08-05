//
//  VacationPhotosTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 03.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "VacationPhotosTableViewController.h"
#import "VacationHelper.h"
#import "FlickrData.h"
#import "Photo.h"

@interface VacationPhotosTableViewController ()

@end

@implementation VacationPhotosTableViewController

@synthesize vacation = _vacation;
@synthesize place = _place;

- (void)setPlace:(Place *)place
{
    if (_place == place) return;
    _place = place;
    self.title = [FlickrData titleOfPlace:place];
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"title" 
                                                             ascending:YES 
                                                              selector:
                                @selector(localizedCaseInsensitiveCompare:)]];    
    request.predicate = [NSPredicate predicateWithFormat:@"place.name = %@", self.place.name];    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] 
                                     initWithFetchRequest:request 
                                     managedObjectContext:self.place.managedObjectContext 
                                       sectionNameKeyPath:nil 
                                                cacheName:nil];
}

#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Photo"]) {        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [segue.destinationViewController performSelector:@selector(setCoreDataPhoto:) withObject:photo];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [VacationHelper openVacation:self.vacation usingBlock:^(BOOL success) {
        [self setupFetchedResultsController];
    }];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [FlickrData titleOfPhoto:photo];
    cell.detailTextLabel.text = [FlickrData subtitleOfPhoto:photo];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id vc = [self.splitViewController.viewControllers lastObject];
    if ([vc respondsToSelector:@selector(setCoreDataPhoto:)]) {
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [vc performSelector:@selector(setCoreDataPhoto:) withObject:photo];
    }
}

@end
