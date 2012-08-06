//
//  VacationsTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 01.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "VacationsTableViewController.h"
#import "VacationTableViewController.h"
#import "VacationHelper.h"
#import "AddVacationViewController.h"

@interface VacationsTableViewController () <AddVacationViewControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popoverController; 

@end

@implementation VacationsTableViewController

@synthesize vacations = _vacations;
@synthesize popoverController;

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[VacationHelper createTestDatabase];
    self.vacations = [VacationHelper getVacations];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Vacation"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];        
        [segue.destinationViewController setVacation:[self.vacations objectAtIndex:indexPath.row]];        
    }
    if ([segue.identifier isEqualToString:@"Add Vacation"]) {
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *) segue;
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = popoverSegue.popoverController;
        }
        [segue.destinationViewController setDelegate:self];
    }
}

#pragma mark - AddVacation delegate

- (void)addVacationViewController:(AddVacationViewController *)sender 
                    addedVacation:(NSString *)vacation
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    self.vacations = [VacationHelper getVacations];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vacations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [self.vacations objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - Table view delegate

@end
