//
//  NewGameOptionsViewController.m
//  Cylinder Tic Tac Toe
//
//  Created by uicsi7 on 4/8/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "NewGameOptionsViewController.h"
#import "Simple2DGameViewController.h"

@interface NewGameOptionsViewController ()

@end

@implementation NewGameOptionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([segue.identifier isEqualToString:@"gotoGameVC"]) {
	  Simple2DGameViewController * destVC= segue.destinationViewController;
		if (self.segmentedControlView.selectedSegmentIndex==1)destVC.vsAI=true;
	}
	
}
-(IBAction)returnToNewGameOptionVC:(UIStoryboardSegue*)segue{
	
}

@end