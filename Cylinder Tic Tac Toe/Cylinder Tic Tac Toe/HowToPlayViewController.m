//
//  HowToPlayViewController.m
//  Cylinder Tic Tac Toe
//
//  Created by uicsi7 on 4/30/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "HowToPlayViewController.h"

@interface HowToPlayViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HowToPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"howToPlay" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
