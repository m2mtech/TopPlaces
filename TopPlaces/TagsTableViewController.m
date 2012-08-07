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

@interface TagsTableViewController () <UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *searchButton;
@property (nonatomic, strong) NSPredicate *searchPredicate;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;

@end

@implementation TagsTableViewController

@synthesize vacation = _vacation;
@synthesize searchButton = _searchButton;
@synthesize searchPredicate = _searchPredicate;
@synthesize searchBar = _searchBar;
@synthesize searchDisplayController;

- (void)setVacation:(NSString *)vacation
{
    if (vacation == _vacation) return;
    _vacation = vacation;
    self.title = [@"Tags of " stringByAppendingString:vacation];
}

- (UIBarButtonItem *)searchButton
{
    if (!_searchButton) {
        _searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonPressed:)];
    }
    return _searchButton;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] 
                      initWithFrame:self.navigationController.navigationBar.frame];
        self.searchDisplayController = [[UISearchDisplayController alloc] 
                                        initWithSearchBar:_searchBar 
                                       contentsController:self];
        self.searchDisplayController.searchResultsDelegate = self;
        self.searchDisplayController.searchResultsDataSource = self;
        self.searchDisplayController.delegate = self;
    }
    return _searchBar;        
}

- (IBAction)searchButtonPressed:(id)sender
{
    if (self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = nil;
    } else {
        self.tableView.tableHeaderView = self.searchBar;
        if (self.searchPredicate) {
            self.searchPredicate = nil;
            [self setupFetchedResultsController];
        }        
    }
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:
                               [NSSortDescriptor sortDescriptorWithKey:@"count" 
                                                             ascending:NO]];
    request.predicate = self.searchPredicate;
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
        self.navigationItem.rightBarButtonItem = self.searchButton;
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

#pragma mark - Search delegate

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([searchString isEqualToString:@""]) self.searchPredicate = nil;
    else {
        self.searchPredicate = [NSPredicate predicateWithFormat:@"name like[c] %@", [@"*" stringByAppendingString:[searchString stringByAppendingString:@"*"]]];
    }
    
    [self setupFetchedResultsController];
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.tableView.tableHeaderView = nil;
}

@end
