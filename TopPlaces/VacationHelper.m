//
//  VacationHelper.m
//  TopPlaces
//
//  Created by Martin Mandl on 01.08.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "VacationHelper.h"

@implementation VacationHelper

+ (NSArray *)getVacations
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSURL *dir = [[[fm URLsForDirectory:NSDocumentDirectory 
                              inDomains:NSUserDomainMask] lastObject] 
                  URLByAppendingPathComponent:DEFAULT_DATABASE_FOLDER 
                                  isDirectory:YES];
    BOOL isDir = NO;
    NSError *error;
    if (![fm fileExistsAtPath:[dir path] 
                  isDirectory:&isDir] || !isDir)
        [fm createDirectoryAtURL:dir 
     withIntermediateDirectories:YES 
                      attributes:nil 
                           error:&error];
    if (error) return nil;
    //NSLog(@"%@", dir);
    
    NSArray *files = [fm contentsOfDirectoryAtURL:dir 
                       includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] 
                                          options:NSDirectoryEnumerationSkipsHiddenFiles 
                                            error:&error];
    if (error) return nil;
    
    NSString *name;
    NSMutableArray *vacations = [NSMutableArray arrayWithCapacity:[files count]];
    for (NSURL *url in files) {
        [url getResourceValue:&name forKey:NSURLNameKey error:&error];
        if (error) continue;
        [vacations addObject:name];
    }
    
    if ([vacations count]) return vacations;
    
    return [NSArray arrayWithObject:DEFAULT_VACATION_NAME];;
}

@end
