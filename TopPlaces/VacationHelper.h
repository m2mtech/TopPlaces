//
//  VacationHelper.h
//  TopPlaces
//
//  Created by Martin Mandl on 01.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_VACATION_NAME @"My Vacation"
#define DEFAULT_DATABASE_FOLDER @"vacations"

@interface VacationHelper : NSObject

+ (NSArray *)getVacations;

@end
