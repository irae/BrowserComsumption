//
//  BCMainViewController.m
//  BrowserComsumption
//
//  Created by irae on 10/18/13.
//  Copyright (c) 2013 Irae. All rights reserved.
//

#import "BCMainViewController.h"
const CGFloat BCMainViewControllerToolBarMinY      = -44.0;
const CGFloat BCMainViewControllerToolBarMaxY      = 0.0;

@interface BCMainViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation BCMainViewController {
    BOOL _headerHidden;
}

#pragma mark - lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // we'll use scroll events to move the bars
    self.webview.scrollView.delegate = self;
    
    [self initialInsets];
    [self loadHTMLIntoWebview];
    [self addGestureRecognizers];
}

#pragma mark - initialization

- (void)loadHTMLIntoWebview
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"browser_content" ofType:@"html"];
    NSError *err = nil;
    [self.webview loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err] baseURL:nil];
    if (err) {
        NSLog(@"%@", err);
    }
}

- (void)initialInsets
{
    [self updateWebviewInsets:self.headerView.frame.origin.y + self.headerView.frame.size.height];
}

- (void)addGestureRecognizers
{
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(swipeDown)];
    swipeDown.delegate = self;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.webview.scrollView addGestureRecognizer:swipeDown];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(pan:)];
    pan.delegate = self;
    pan.minimumNumberOfTouches = 1;
    [self.webview.scrollView addGestureRecognizer:pan];
}

#pragma mark - Move stuff

- (void)updateWebviewInsets:(CGFloat)position
{
    UIEdgeInsets inset = UIEdgeInsetsMake(position, 0, 0, 0);
    [self.webview.scrollView setContentInset:inset];
    [self.webview.scrollView setScrollIndicatorInsets:inset];

}


#pragma mark - UISwipeGestureRecognizer actions

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGFloat translation = [pan translationInView:self.webview.scrollView].y;
    NSLog(@"pan %f", translation);
    translation = MAX(-self.headerView.frame.size.height, translation);
    translation = MIN(0.0, translation);
    if (!_headerHidden) {
        self.headerView.transform = CGAffineTransformMakeTranslation(0.0, translation);
        [self updateWebviewInsets:20.0 + self.headerView.frame.size.height + translation];
    }
    if (translation == -self.headerView.frame.size.height) {
        _headerHidden = YES;
    }
}


- (void)swipeDown
{
    NSLog(@"swipeDown");
//    _headerHidden = NO;
//    self.headerView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= self.headerView.frame.size.height) {
        _headerHidden = NO;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

@end
