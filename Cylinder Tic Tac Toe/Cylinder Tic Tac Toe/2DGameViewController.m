//
//  2DGameViewController.m
//  Cylinder Tic Tac Toe
//
//  Created by uicsi7 on 4/9/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "2DGameViewController.h"
#import "Simple2DLayer.h"
#import "CylinderTicTacToeGameLogic.h"


@interface _DGameViewController ()

@end

@implementation _DGameViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	gameLogic = [[CylinderTicTacToeGameLogic alloc]init];
	self.numberOfPlayers = 2;
	self.currentPlayer = 1;
	self.textLabel.text=@"Player 1";
	
    layerArray = [[NSMutableArray alloc] initWithCapacity:4];
    Simple2DLayer * layerZero = [[Simple2DLayer alloc]initWithFrame:CGRectMake(10, 50, 300, 300)];
    layerZero.delegate = self;
    [layerArray addObject:layerZero];
	[self.view addSubview:layerZero];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)indexColorForRing:(uint)ring Slot:(uint)slot sender:(id)sender
{
    int playerColorIndex = [gameLogic getPlayerIDatIndex:[GameBoardIndex indexForLayer:0 Ring:ring Slot:slot]];
    return playerColorIndex;
}

-(BOOL)userWantToMakeMoveAtRing:(uint)ring Slot:(uint)slot sender:(id)sender
{
    int result = [gameLogic player:self.currentPlayer makeMoveAtIndex:[GameBoardIndex indexForLayer:0 Ring:ring Slot:slot]];
    NSLog(@"player=%d , result=%d",self.currentPlayer,result);
	[self redrawBoard:0];
	if(result != -1){
        
		
		if(result == 1){
			NSLog(@"Player %d won!",self.currentPlayer);
			self.textLabel.text = [NSString stringWithFormat:@"Player %d won",self.currentPlayer];
		}
		
		self.currentPlayer+=1;
		if (self.currentPlayer>self.numberOfPlayers)self.currentPlayer=1;
		
		if(result==0)self.textLabel.text = [NSString stringWithFormat:@"Player %d turn",self.currentPlayer];
		
		return true;
    }else{
		self.textLabel.text = [NSString stringWithFormat:@"Player %d wrong move!",self.currentPlayer];

	}
    return false;
}

-(void)redrawBoard:(int)layerNum{
    Simple2DLayer *layer = [layerArray objectAtIndex: layerNum];
    [layer setNeedsDisplay];
}

@end

