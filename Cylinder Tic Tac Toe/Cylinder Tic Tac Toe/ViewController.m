//
//  ViewController.m
//  Cylinder Tic Tac Toe
//
//  Created by uicsi7 on 3/25/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "ViewController.h"
#import "CylinderTicTacToeGameLogic.h"
#import "Simple2DLayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	//test game logic (need to disable check player turn condition)
	CylinderTicTacToeGameLogic * gameLogic = [[CylinderTicTacToeGameLogic alloc]init];
	NSLog(@"move=%d",[gameLogic player:1 makeMoveAtIndex:[GameBoardIndex indexForLayer:0 Ring:3 Slot:0]]);
	NSLog(@"move=%d",[gameLogic player:1 makeMoveAtIndex:[GameBoardIndex indexForLayer:1 Ring:2 Slot:1]]);
	NSLog(@"move=%d",[gameLogic player:1 makeMoveAtIndex:[GameBoardIndex indexForLayer:2 Ring:1 Slot:2]]);
	NSLog(@"move=%d",[gameLogic player:1 makeMoveAtIndex:[GameBoardIndex indexForLayer:3 Ring:0 Slot:3]]);
	NSLog(@"move=%d",[gameLogic player:1 makeMoveAtIndex:[GameBoardIndex indexForLayer:0 Ring:0 Slot:2]]);
	Simple2DLayer * layer = [[Simple2DLayer alloc]initWithFrame:CGRectMake(10, 50, 300, 300)];	
	[self.view addSubview:layer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
