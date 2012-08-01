//
//  VacationTableViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 01.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "VacationTableViewController.h"

@interface VacationTableViewController ()

@end

@implementation VacationTableViewController

@synthesize vacation = _vacation;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.vacation;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

@end
