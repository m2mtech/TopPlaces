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
#import "FlickrCache.h"
#import "VacationHelper.h"
#import "Photo+Flickr.h"

@interface PhotoViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *visitButton;

@end

@implementation PhotoViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize toolbar = _toolbar;
@synthesize toolbarTitle = _toolbarTitle;
@synthesize spinner = _spinner;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize photo = _photo;
@synthesize coreDataPhoto = _coreDataPhoto;
@synthesize visitButton = _visitButton;

- (void)displayVisitButtonForPhotoID:(NSString *)photoID {
    VacationHelper *vh = [VacationHelper sharedVacation:nil];
    [VacationHelper openVacation:vh.vacation usingBlock:^(BOOL success) {
        if ([Photo exisitingPhotoWithID:photoID 
                inManagedObjectContext:vh.database.managedObjectContext]) {
            self.visitButton.title = @"Unvisit";
        } else {
            self.visitButton.title = @"Visit";
        }
    }];
    
    if (self.splitViewController) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        [toolbarItems addObject:self.visitButton];
        self.toolbar.items = toolbarItems;                
    } else {
        self.navigationItem.rightBarButtonItem = self.visitButton;
    }
}

- (void)hideVisitButton {
    if (self.splitViewController) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        [toolbarItems removeObject:self.visitButton];
        self.toolbar.items = toolbarItems;                        
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }            
}

- (UIBarButtonItem *)visitButton
{
    if (!_visitButton) {
        _visitButton = [[UIBarButtonItem alloc] initWithTitle:@"Visit" style:UIBarButtonItemStyleBordered target:self action:@selector(visitButtonPressed:)];
    }
    return _visitButton;
}

- (IBAction)visitButtonPressed:(id)sender
{
    VacationHelper *vh = [VacationHelper sharedVacation:nil];
    if (self.coreDataPhoto) {
        if (self.splitViewController) {
            self.imageView.alpha = 0.5;
            [self hideVisitButton];            
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [Photo removePhoto:self.coreDataPhoto];
        [vh.database saveToURL:vh.database.fileURL 
              forSaveOperation:UIDocumentSaveForOverwriting 
             completionHandler:NULL];
    } 
    if (self.photo) {
        if ([self.visitButton.title isEqualToString:@"Visit"]) {
            self.visitButton.title = @"Unvisit";
            [VacationHelper openVacation:vh.vacation usingBlock:^(BOOL success) {
                [Photo photoFromFlickrInfo:self.photo 
                    inManagedObjectContext:vh.database.managedObjectContext];
            }];            
        } else {
            self.visitButton.title = @"Visit";
            [VacationHelper openVacation:vh.vacation usingBlock:^(BOOL success) {
                [Photo removePhotoWithID:[self.photo objectForKey:FLICKR_PHOTO_ID] 
                  inManagedObjectContext:vh.database.managedObjectContext];
            }];
        }
        [vh.database saveToURL:vh.database.fileURL 
              forSaveOperation:UIDocumentSaveForOverwriting 
             completionHandler:NULL];
    }
}

- (void)loadPhoto
{
    NSString *title = @"Photo";
    NSString *photoID;
    if (self.photo) {
        title = [FlickrData titleOfPhoto:self.photo];
        photoID = [[self.photo objectForKey:FLICKR_PHOTO_ID] copy];
    }
    if (self.coreDataPhoto) {
        title = [FlickrData titleOfPhoto:self.coreDataPhoto];   
        photoID = [self.coreDataPhoto.unique copy];
    }
    self.navigationItem.title = title;
    self.toolbarTitle.title = title;
    if (self.imageView.image) self.imageView.alpha = 0.5;
    [self hideVisitButton];
    if (self.photo || self.coreDataPhoto) [self.spinner startAnimating];

    dispatch_queue_t queue = dispatch_queue_create("Flickr Downloader", NULL);
    dispatch_async(queue, ^{
        FlickrCache *cache = [FlickrCache cacheFor:@"photos"];
        NSURL *url = [cache urlForCachedPhotoID:photoID format:FlickrPhotoFormatLarge];
        if (!url) {
            if (self.photo) {
                url = [FlickrFetcher urlForPhoto:self.photo 
                                          format:FlickrPhotoFormatLarge];
            }
            if (self.coreDataPhoto) {
                url = [NSURL URLWithString:self.coreDataPhoto.imageUrl];
            }            
        }
        NSData *data = [NSData dataWithContentsOfURL:url];
        [cache cacheData:data ofPhotoID:photoID format:FlickrPhotoFormatLarge];
        if (self.imageView.window 
            && ((self.photo 
                 && [[self.photo objectForKey:FLICKR_PHOTO_ID] isEqualToString:photoID]) 
             || (self.coreDataPhoto 
                 && [self.coreDataPhoto.unique isEqualToString:photoID]))) 
            dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:data];        
            self.scrollView.zoomScale = 1.0;
            self.imageView.alpha = 1;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.scrollView.maximumZoomScale = 10.0;    
            self.scrollView.minimumZoomScale = 0.1;
            self.scrollView.contentSize = image.size;
            double wScale = self.scrollView.bounds.size.width / image.size.width;
            double hScale = self.scrollView.bounds.size.height / image.size.height;
            if (wScale > hScale) self.scrollView.zoomScale = wScale;
            else self.scrollView.zoomScale = hScale;
            [self.spinner stopAnimating];
            [self displayVisitButtonForPhotoID:photoID];
            [self.imageView setNeedsDisplay];
        });
    });
    dispatch_release(queue);
}

- (void)setPhoto:(NSDictionary *)photo
{    
    if (_photo == photo) return;
    _photo = photo;
    if (!_photo) return;
    self.coreDataPhoto = nil;
    
    
    if (self.imageView.window) [self loadPhoto];        
        
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

- (void)setCoreDataPhoto:(Photo *)coreDataPhoto
{
    if (_coreDataPhoto == coreDataPhoto) return;
    _coreDataPhoto = coreDataPhoto;
    if (!_coreDataPhoto) return;
    self.photo = nil;
    
    if (self.imageView.window) [self loadPhoto];    
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.imageView.image = nil;
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [self setToolbar:nil];
    [self setToolbarTitle:nil];
    [self setSpinner:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
