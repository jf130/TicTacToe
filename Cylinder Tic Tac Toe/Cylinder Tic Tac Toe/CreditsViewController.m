//
//  CreditsViewController.m
//  Cylinder Tic Tac Toe
//
//  Created by uicsi7 on 5/8/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CreditsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"credits" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    self.webView.scalesPageToFit=YES;
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
