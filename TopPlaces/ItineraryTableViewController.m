//
//  ItineraryTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 02.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "ItineraryTableViewController.h"
#import "VacationHelper.h"
#import "Place.h"
#import "FlickrData.h"

@interface ItineraryTableViewController ()

@end

@implementation ItineraryTableViewController

@synthesize vacation = _vacation;

- (void)setVacation:(NSString *)vacation
{
    //[VacationHelper sharedVacation:@"itinerary"];
    if (vacation == _vacation) return;
    _vacation = vacation;
    self.title = [@"Itinerary of " stringByAppendingString:vacation];
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"firstVisited" 
                                                             ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] 
                                     initWithFetchRequest:request 
                                     managedObjectContext:[VacationHelper 
                                      sharedVacation:self.vacation].database.managedObjectContext 
                                       sectionNameKeyPath:nil 
                                                cacheName:nil];
}

#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Vacation Photos"]) {
        [segue.destinationViewController setVacation:self.vacation];        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [segue.destinationViewController performSelector:@selector(setPlace:) withObject:place];
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
    static NSString *CellIdentifier = @"Itinerary Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [FlickrData titleOfPlace:place];
    cell.detailTextLabel.text = [FlickrData subtitleOfPlace:place];;
    return cell;
}

#pragma mark - Table view delegate

@end
