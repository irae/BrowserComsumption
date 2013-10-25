//
//  BCMainViewController.m
//  BrowserComsumption
//
//  Created by irae on 10/18/13.
//  Copyright (c) 2013 Irae. All rights reserved.
//

#import "BCMainViewController.h"

@interface BCMainViewController ()

@end

@implementation BCMainViewController

#pragma mark Controller lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Title";
    [self loadHTMLIntoWebview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)didReceiveMemoryWarning
{
    
}

@end
