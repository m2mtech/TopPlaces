//
//  AddVacationViewController.h
//  TopPlaces
//
//  Created by Martin Mandl on 06.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddVacationViewController;

@protocol AddVacationViewControllerDelegate <NSObject>

@optional
- (void)addVacationViewController:(AddVacationViewController *)sender 
                    addedVacation:(NSString *)vacation;

@end

@interface AddVacationViewController : UIViewController

@property (nonatomic, weak) id <AddVacationViewControllerDelegate> delegate;

@end
