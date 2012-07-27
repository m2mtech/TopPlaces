//
//  PhotoViewController.h
//  TopPlaces
//
//  Created by Martin Mandl on 26.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface PhotoViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (nonatomic, strong) NSDictionary *photo;

@end
