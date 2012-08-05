//
//  FlickrCache.m
//  TopPlaces
//
//  Created by Martin Mandl on 28.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "FlickrCache.h"
#import "Photo.h"

@interface FlickrCache ()

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSURL *cacheDir;

@end

@implementation FlickrCache

@synthesize fileManager = _fileManager;
@synthesize cacheDir = _cacheDir;

- (NSFileManager *)fileManager
{
    if (!_fileManager)
        _fileManager = [[NSFileManager alloc] init];
    return _fileManager;
}

- (void)setCacheDir:(NSURL *)cacheDir
{
    if (cacheDir == _cacheDir) return;
    _cacheDir = cacheDir;
    BOOL isDir = NO;
    if (![self.fileManager fileExistsAtPath:[_cacheDir path] isDirectory:&isDir] || !isDir)
        [self.fileManager createDirectoryAtURL:_cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)setStandardCacheDirByAppindingString:(NSString *)string
{
    self.cacheDir = [[[self.fileManager URLsForDirectory:NSCachesDirectory 
                                               inDomains:NSUserDomainMask] lastObject] 
                     URLByAppendingPathComponent:string isDirectory:YES];
}

+ (FlickrCache *)cacheFor:(NSString *)folder
{
    FlickrCache *cache = [[FlickrCache alloc] init];
    [cache setStandardCacheDirByAppindingString:folder];
    return cache;
}

- (NSURL *)urlForLocalPhoto:(id)photo format:(FlickrPhotoFormat)format
{
    if (!photo) return nil;
    NSString * photoID;
    if ([photo isKindOfClass:[NSDictionary class]])
        photoID = [photo objectForKey:FLICKR_PHOTO_ID];
    if ([photo isKindOfClass:[Photo class]])
        photoID = ((Photo *)photo).unique;    
    return [self urlForCachedPhotoID:photoID format:format];
}

- (NSURL *)urlForLocalPhotoID:(NSString *)photoID format:(FlickrPhotoFormat)format
{
    if (!photoID) return nil;
    NSString *fileName = [NSString stringWithFormat:@"%u-%@", format, photoID];
    return [self.cacheDir URLByAppendingPathComponent:fileName];
}

- (NSURL *)urlForCachedPhoto:(id)photo format:(FlickrPhotoFormat)format
{
    if (!photo) return nil;
    NSURL *url = [self urlForLocalPhoto:photo format:format];
    if ([self.fileManager fileExistsAtPath:[url path]]) return url;    
    return nil;
}

- (NSURL *)urlForCachedPhotoID:(NSString *)photoID format:(FlickrPhotoFormat)format
{
    if (!photoID) return nil;
    NSURL *url = [self urlForLocalPhotoID:photoID format:format];
    if ([self.fileManager fileExistsAtPath:[url path]]) return url;    
    return nil;
}

- (void)cacheData:(NSData *)data ofPhoto:(id)photo format:(FlickrPhotoFormat)format
{
    if (!photo) return;
    NSString *path = [[self urlForLocalPhoto:photo format:format] path];
    if ([self.fileManager fileExistsAtPath:path]) return;    
    [self.fileManager createFileAtPath:path contents:data attributes:nil];
    [self cleanupOldFiles];
}

- (void)cacheData:(NSData *)data ofPhotoID:(NSString *)photoID format:(FlickrPhotoFormat)format
{
    if (!photoID) return;
    NSString *path = [[self urlForLocalPhotoID:photoID format:format] path];
    if ([self.fileManager fileExistsAtPath:path]) return;    
    [self.fileManager createFileAtPath:path contents:data attributes:nil];
    [self cleanupOldFiles];
}

- (void)cleanupOldFiles
{
    NSDirectoryEnumerator *dirEnumerator = [self.fileManager 
                                            enumeratorAtURL:self.cacheDir 
                                 includingPropertiesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] 
                                                    options:NSDirectoryEnumerationSkipsHiddenFiles 
                                               errorHandler:nil];
    NSString *fileName;
    NSNumber *fileSize;
    NSDate *fileCreation;
    NSMutableArray *files = [NSMutableArray array];
    NSDictionary *fileData;
    __block NSUInteger dirSize = 0;
    for (NSURL *url in dirEnumerator) {
        [url getResourceValue:&fileName forKey:NSURLNameKey error:nil];
        [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:nil];
        [url getResourceValue:&fileCreation forKey:NSURLCreationDateKey error:nil];
        dirSize += [fileSize integerValue];
        fileData = [[NSDictionary alloc] initWithObjectsAndKeys:url, 
                    @"url", fileSize, @"size", fileCreation, @"date", nil];
        [files addObject:fileData];
    }
    if (dirSize > MAX_FLICKR_CACHE_SIZE) {
        NSArray *sorted = [files sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 valueForKey:@"date"] compare:[obj2 valueForKey:@"date"]];
        }];
        [sorted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            dirSize -= [[obj valueForKey:@"size"] integerValue];
            [self.fileManager removeItemAtURL:[obj valueForKey:@"url"] error:nil];
            *stop = dirSize < MAX_FLICKR_CACHE_SIZE;
        }];
    }            
    
}

@end
