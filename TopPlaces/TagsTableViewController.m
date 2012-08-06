//
//  TagsTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 06.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "TagsTableViewController.h"
#import "VacationHelper.h"
#import "Tag.h"

@interface TagsTableViewController ()

@end

@implementation TagsTableViewController

@synthesize vacation = _vacation;

- (void)setVacation:(NSString *)vacation
{
    if (vacation == _vacation) return;
    _vacation = vacation;
    self.title = [@"Tags of " stringByAppendingString:vacation];
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"count" 
                                                             ascending:NO]];
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
        Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [segue.destinationViewController performSelector:@selector(setTag:)
                                              withObject:tag];
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
    static NSString *CellIdentifier = @"Tags Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [tag.name capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [tag.photos count]];
    return cell;
}

#pragma mark - Table view delegate

@end
