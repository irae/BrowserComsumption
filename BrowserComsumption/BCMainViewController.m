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

@interface BCMainViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *toolBar;

@end

@implementation BCMainViewController {
    CGFloat _initialScrollPostion;
    CGFloat _toolBarOrigin;
    CGFloat _toolBarHeight;
    BOOL _animating;
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

    [self loadHTMLIntoWebview];
    [self adjustContentPosition];
}

#pragma mark - initialization

- (void)adjustContentPosition
{
    // webview starts at top, move content below it
    _toolBarHeight = self.toolBar.frame.size.height;
    _initialScrollPostion = -_toolBarHeight;
    _toolBarOrigin = _initialScrollPostion;
    [self updateWebviewWithOffset:_initialScrollPostion];
}

- (void)loadHTMLIntoWebview
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"browser_content" ofType:@"html"];
    NSError *err = nil;
    [self.webview loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err] baseURL:nil];
    if (err) {
        NSLog(@"%@", err);
    }
}

#pragma mark - scroll and toolbar related methods

- (BOOL)isToolBarShown
{
    return self.toolBar.frame.origin.y == BCMainViewControllerToolBarMaxY;
}

- (BOOL)isToolBarHidden
{
    return self.toolBar.frame.origin.y == BCMainViewControllerToolBarMinY;
}

- (void)setWebViewContentInset:(UIEdgeInsets)inset
{
    [self.webview.scrollView setContentInset:inset];
    [self.webview.scrollView setScrollIndicatorInsets:inset];
}

- (void)fixHalfShownToolbar
{
    if (![self isToolBarHidden] && ![self isToolBarShown]) {
        CGRect toolBarFrame = self.toolBar.frame;
        CGFloat toolbarPositionRange = BCMainViewControllerToolBarMaxY - BCMainViewControllerToolBarMinY;
        CGFloat offset = _initialScrollPostion - self.webview.scrollView.contentOffset.y;
        CGFloat targetInsetTop = 0.0;

        if (offset < BCMainViewControllerToolBarMaxY) {
            toolBarFrame.origin.y = BCMainViewControllerToolBarMaxY;
            targetInsetTop = BCMainViewControllerToolBarMaxY + toolBarFrame.size.height;
        } else if (toolBarFrame.origin.y < toolbarPositionRange/2 ) {
            toolBarFrame.origin.y = BCMainViewControllerToolBarMaxY;
        } else {
            toolBarFrame.origin.y = BCMainViewControllerToolBarMinY;
        }
        
        
        _animating = YES;
        [UIView animateWithDuration:0.15f animations:^{
            self.toolBar.frame = toolBarFrame;
            if (targetInsetTop != self.webview.scrollView.contentInset.top) {
                UIEdgeInsets inset = UIEdgeInsetsMake(targetInsetTop, 0.0, 0.0, 0.0);
                [self setWebViewContentInset:inset];
            }
        } completion:^(BOOL finished) {
            _animating = NO;
        }];

    }
}

- (void)updateToolbarWithOffset:(CGFloat)offset
{
    CGFloat targetY = _toolBarOrigin - offset;
    targetY = MAX(targetY, BCMainViewControllerToolBarMinY);
    targetY = MIN(targetY, BCMainViewControllerToolBarMaxY);
    CGRect toolBarFrame = self.toolBar.frame;
    if (targetY != toolBarFrame.origin.y) {
        toolBarFrame.origin.y = targetY;
        self.toolBar.frame = toolBarFrame;
    }
    if ([self isToolBarHidden] && !self.webview.scrollView.isDecelerating) {
        _toolBarOrigin = _initialScrollPostion;
    }
}

- (void)updateWebviewWithOffset:(CGFloat)offset
{
    CGFloat targetTop = _toolBarOrigin - offset + _toolBarHeight;
    targetTop = MAX(targetTop, BCMainViewControllerToolBarMinY + _toolBarHeight);
    targetTop = MIN(targetTop, BCMainViewControllerToolBarMaxY + _toolBarHeight);
    if (targetTop != self.webview.scrollView.contentInset.top) {
        UIEdgeInsets targetInset = UIEdgeInsetsMake(targetTop, 0.0, 0.0, 0.0);
        [self setWebViewContentInset:targetInset];
    }
}

//-----------------------------------------------------------------------------------------
#pragma mark - UIScrollViewDelegate
//-----------------------------------------------------------------------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_animating == YES) {
        return;
    }
    CGFloat scrollOffset = scrollView.contentOffset.y;
    [self updateToolbarWithOffset:scrollOffset];
    [self updateWebviewWithOffset:scrollOffset];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    BOOL swipingDown = velocity.y < 0;
    BOOL willScrollEnoughtToShow = _toolBarHeight <= scrollView.contentOffset.y - targetContentOffset->y;
    if ([self isToolBarHidden] && swipingDown && willScrollEnoughtToShow) {
        // seting the origin to the target offset means it will only fully show in the last frame of the deceletation
        _toolBarOrigin = targetContentOffset->y;
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (![self isToolBarHidden]) {
        // setting the origin so toolbar can go up as the user drags
        _toolBarOrigin = scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self fixHalfShownToolbar];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self fixHalfShownToolbar];
}

@end
