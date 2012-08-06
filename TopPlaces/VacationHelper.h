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

@property (nonatomic, strong) NSString *vacation;
@property (nonatomic, strong) UIManagedDocument *database;
@property (nonatomic, strong) NSFileManager *fileManager;


+ (NSArray *)getVacations;
+ (VacationHelper *)sharedVacation:(NSString *)vacationName;
+ (void)openVacation:(NSString *)vacationName
          usingBlock:(void (^)(BOOL success))block;

+ (void)createTestDatabase;

@end
