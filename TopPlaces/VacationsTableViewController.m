//
//  VacationsTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 01.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "VacationsTableViewController.h"
#import "VacationHelper.h"

@interface VacationsTableViewController ()

@end

@implementation VacationsTableViewController

@synthesize vacations = _vacations;

- (NSArray *)vacations
{
    if (!_vacations) _vacations = [VacationHelper getVacations];
    //NSLog(@"%@", _vacations);
    return _vacations;
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
