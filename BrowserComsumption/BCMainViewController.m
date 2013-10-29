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

#pragma mark - scroll and toolbar related methods


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
