//
//  VacationTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 01.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "VacationTableViewController.h"
#import "ItineraryTableViewController.h"
#import "VacationHelper.h"

@interface VacationTableViewController ()

@end

@implementation VacationTableViewController

@synthesize vacation = _vacation;

- (void)setVacation:(NSString *)vacation
{
    if (vacation == _vacation) return;
    _vacation = vacation;
    self.title = vacation;
    [VacationHelper sharedVacation:vacation];
}

#pragma mark - View lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"Show Itinerary"]) {
        [segue.destinationViewController setVacation:self.vacation];        
    }
    if ([segue.identifier isEqualToString:@"Show Tags"]) {
        [segue.destinationViewController setVacation:self.vacation];        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

@end
