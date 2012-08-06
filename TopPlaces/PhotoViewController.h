//
//  PhotoViewController.h
//  TopPlaces
//
//  Created by Martin Mandl on 26.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"
#import "Photo.h"

#define VACATION_SELECTION_POPOVER_TABLE_SIZE 220

@interface PhotoViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (nonatomic, strong) NSDictionary *photo;
@property (nonatomic, strong) Photo *coreDataPhoto;

@end
