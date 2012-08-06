//
//  AddVacationViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 06.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "AddVacationViewController.h"
#import "VacationHelper.h"

@interface AddVacationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *vacationName;

@end

@implementation AddVacationViewController
@synthesize vacationName = _vacationName;
@synthesize delegate;

- (IBAction)addVacationName {
    NSString *name = self.vacationName.text;    
    if ([name isEqualToString:@""]) return;
    
    VacationHelper *vh = [VacationHelper sharedVacation:name];    
    if ([vh.fileManager fileExistsAtPath:[vh.database.fileURL path]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry," message:@"this vacation does already exist." delegate:nil cancelButtonTitle:@"Back" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [vh.database saveToURL:vh.database.fileURL 
          forSaveOperation:UIDocumentSaveForCreating 
         completionHandler:^(BOOL success) {
             [self.delegate addVacationViewController:self addedVacation:name];
         }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload {
    [self setVacationName:nil];
    [super viewDidUnload];
}
@end
