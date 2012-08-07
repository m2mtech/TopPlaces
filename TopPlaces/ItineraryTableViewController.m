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
#import "Itinerary+Single.h"

@interface ItineraryTableViewController ()

@property (nonatomic) BOOL placesHaveBeenRearranged;

@end

@implementation ItineraryTableViewController

@synthesize vacation = _vacation;
@synthesize itinerary = _itinerary;
@synthesize placesHaveBeenRearranged = _placesHaveBeenRearranged;

- (void)setVacation:(NSString *)vacation
{
    if (vacation == _vacation) return;
    _vacation = vacation;
    self.title = [@"Itinerary of " stringByAppendingString:vacation];
}

#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Vacation Photos"]) {
        [segue.destinationViewController setVacation:self.vacation];        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Place *place = [self.itinerary.places objectAtIndex:indexPath.row]; 
        [segue.destinationViewController 
         performSelector:@selector(setPlace:) 
              withObject:place];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [VacationHelper openVacation:self.vacation usingBlock:^(BOOL success) {
        self.itinerary = [Itinerary singleItineraryInManagedObjectContext:
          [VacationHelper sharedVacation:self.vacation].database.managedObjectContext];
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self.tableView reloadData];
    }];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itinerary.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Itinerary Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    Place *place = [self.itinerary.places objectAtIndex:indexPath.row]; 
    cell.textLabel.text = [FlickrData titleOfPlace:place];
    cell.detailTextLabel.text = [FlickrData subtitleOfPlace:place];;
    return cell;
}

#pragma mark - Table view delegate

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES]; 
    if (!editing && self.placesHaveBeenRearranged) {
        VacationHelper *vh = [VacationHelper sharedVacation:self.vacation];    
        [vh.database saveToURL:vh.database.fileURL 
              forSaveOperation:UIDocumentSaveForOverwriting 
             completionHandler:NULL];
        self.placesHaveBeenRearranged = NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView 
  shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Place *place = [self.itinerary.places objectAtIndex:sourceIndexPath.row];
    // the following two auto-generated method are broken
    //[self.itinerary removePlacesObject:place];
    //[self.itinerary insertObject:place inPlacesAtIndex:destinationIndexPath.row];
    NSMutableOrderedSet *places = [self.itinerary.places mutableCopy];
    [places removeObject:place];
    [places insertObject:place atIndex:destinationIndexPath.row];
    self.itinerary.places = places;
    self.placesHaveBeenRearranged = YES;
}

@end
