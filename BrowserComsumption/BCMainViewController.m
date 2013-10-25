//
//  BCMainViewController.m
//  BrowserComsumption
//
//  Created by irae on 10/18/13.
//  Copyright (c) 2013 Irae. All rights reserved.
//

#import "BCMainViewController.h"
const CGFloat BCMainViewControllerToolBarMaxHeight = 64.0;
const CGFloat BCMainViewControllerToolBarMinY      = -44.0;
const CGFloat BCMainViewControllerToolBarMaxY      = 0.0;


@interface BCMainViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *toolBar;

@end

@implementation BCMainViewController {
    CGFloat _initialScrollPostion;
}

#pragma mark Controller lifecycle

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
    
    self.navigationItem.title = @"Title";
    
    // we'll use scroll events to move the bars
    self.webview.scrollView.delegate = self;

    [self loadHTMLIntoWebview];
    [self adjustContentPosition];
}

#pragma mark - initialization

- (void)adjustContentPosition
{
    // webview starts at top, move content below it
    CGRect toolBarFrame = self.toolBar.frame;
    _initialScrollPostion = -toolBarFrame.size.height;
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

- (void)setWebViewContentInset:(UIEdgeInsets)inset
{
    [self.webview.scrollView setContentInset:inset];
    [self.webview.scrollView setScrollIndicatorInsets:inset];
}

- (void)updateToolbarWithOffset:(CGFloat)offset
{
    CGFloat targetY = _initialScrollPostion - offset;
    targetY = MAX(targetY, BCMainViewControllerToolBarMinY);
    targetY = MIN(targetY, BCMainViewControllerToolBarMaxY);
    CGRect toolBarFrame = self.toolBar.frame;
    toolBarFrame.origin.y = targetY;
    self.toolBar.frame = toolBarFrame;
}

- (void)updateWebviewWithOffset:(CGFloat)offset
{
    CGFloat targetTop = _initialScrollPostion - offset + self.toolBar.frame.size.height;
    targetTop = MAX(targetTop, BCMainViewControllerToolBarMinY + self.toolBar.frame.size.height);
    targetTop = MIN(targetTop, BCMainViewControllerToolBarMaxY + self.toolBar.frame.size.height);
    UIEdgeInsets targetInset = UIEdgeInsetsMake(targetTop, 0.0, 0.0, 0.0);
    [self setWebViewContentInset:targetInset];
}

//-----------------------------------------------------------------------------------------
#pragma mark - UIScrollViewDelegate
//-----------------------------------------------------------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollInset = scrollView.contentInset.top;
    NSLog(@"offset: %f, inset:%f",scrollOffset, scrollInset);
    [self updateToolbarWithOffset:scrollOffset];
    [self updateWebviewWithOffset:scrollOffset];
}

@end
