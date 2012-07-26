//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by Martin Mandl on 26.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "FlickrData.h"

@interface PhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photo = _photo;

- (void)setPhoto:(NSDictionary *)photo
{    
    if (_photo == photo) return;
    _photo = photo;
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[defaults objectForKey:RECENTS_PHOTOS_KEY] 
                               mutableCopy];
    if (!recents) recents = [NSMutableArray array];
    NSUInteger key = [recents indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[photo objectForKey:FLICKR_PHOTO_ID] 
                isEqualToString:[obj objectForKey:FLICKR_PHOTO_ID]];
    }];
    if (key != NSNotFound) [recents removeObjectAtIndex:key];    
    [recents insertObject:photo atIndex:0];
    if ([recents count] > NUMBER_OF_RECENT_PHOTOS) 
        [recents removeLastObject];    
    [defaults setObject:recents forKey:RECENTS_PHOTOS_KEY];
    [defaults synchronize];    
}


#pragma mark - Scroll View delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [FlickrData titleOfPhoto:self.photo];
    self.scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.maximumZoomScale = 10.0;    
    self.scrollView.minimumZoomScale = 0.1;
    self.scrollView.contentSize = image.size;
    
    double wScale = self.scrollView.bounds.size.width / image.size.width;
    double hScale = self.scrollView.bounds.size.height / image.size.height;
    if (wScale > hScale) self.scrollView.zoomScale = wScale;
    else self.scrollView.zoomScale = hScale;
}


- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
