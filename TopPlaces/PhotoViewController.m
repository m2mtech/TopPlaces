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

@interface PhotoViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarTitle;

@end

@implementation PhotoViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize toolbar = _toolbar;
@synthesize toolbarTitle = _toolbarTitle;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize photo = _photo;

- (void)loadPhoto
{
    NSString *title = @"Photo";
    if (self.photo) title = [FlickrData titleOfPhoto:self.photo];
    self.navigationItem.title = title;
    self.toolbarTitle.title = title;
    
    dispatch_queue_t queue = dispatch_queue_create("Flickr Downloader", NULL);
    dispatch_async(queue, ^{
        //NSLog(@"start loading image: %@", title);
        NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        NSData *data = [NSData dataWithContentsOfURL:url];
        //[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
        //NSLog(@"done loading image data: %@", title);
        if (self.imageView.window) dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:data];        
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
            [self.imageView setNeedsDisplay];
            //NSLog(@"finished loading image: %@", title);
        });
    });
    dispatch_release(queue);
}

- (void)setPhoto:(NSDictionary *)photo
{    
    if (_photo == photo) return;
    _photo = photo;    
    
    if (self.imageView.window)
        [self loadPhoto];        
        
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

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem)
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
}

#pragma mark - Scroll View delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Split View delegate

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter {
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) detailVC = nil;
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] 
        initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
                             target:barButtonItem.target 
                             action:barButtonItem.action];
    barButtonItem = button;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.splitViewController.delegate = self;
    [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadPhoto];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [self setToolbar:nil];
    [self setToolbarTitle:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
