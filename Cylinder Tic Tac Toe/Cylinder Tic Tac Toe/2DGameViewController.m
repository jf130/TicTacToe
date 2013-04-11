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

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define RadiansToDegrees(x) ((x) * 180 / M_PI)

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
    for (int i=0; i<4; i++) {
		Simple2DLayer * layerView = [[Simple2DLayer alloc]initWithFrame:CGRectMake(10, 21+132*i, 300, 300)];
		layerView.delegate = self;
		[layerArray addObject:layerView];
		[self.view addSubview:layerView];
	}
	
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)layerNumerOfLayerView:(Simple2DLayer*)layerView{
	return [layerArray indexOfObject:layerView];
}

-(int)indexColorForRing:(uint)ring Slot:(uint)slot sender:(id)sender
{
    int playerColorIndex = [gameLogic getPlayerIDatIndex:[GameBoardIndex indexForLayer:[self layerNumerOfLayerView:sender] Ring:ring Slot:slot]];
    return playerColorIndex;
}

-(BOOL)userWantToMakeMoveAtRing:(uint)ring Slot:(uint)slot sender:(id)sender
{
    int layer=[self layerNumerOfLayerView:sender];
	int result = [gameLogic player:self.currentPlayer makeMoveAtIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]];
    NSLog(@"player=%d , result=%d",self.currentPlayer,result);
	[self redrawBoard:layer];
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
    if (layerNum>=0 && layerNum < layerArray.count) {
		Simple2DLayer *layerView = [layerArray objectAtIndex: layerNum];
		[layerView setNeedsDisplay];
	}else{
		for (Simple2DLayer * layerView in layerArray) [layerView setNeedsDisplay];
	}
}

#pragma mark - touch, gesture

- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender {
	NSLog(@"Swipe!");
	CGFloat rotateAngle;
	if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
		rotateAngle=90;
	}
	if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
		rotateAngle=-90;
	}
	
	for (Simple2DLayer * layerView in layerArray){
		[UIView beginAnimations:@"rotate" context:nil];
		[UIView setAnimationDuration:0.8];
		CGFloat radians = atan2f(layerView.transform.b, layerView.transform.a); 
		CGFloat currentAngle =  RadiansToDegrees(radians); 
		layerView.transform = CGAffineTransformMakeRotation(DegreesToRadians(currentAngle+rotateAngle));
		[UIView commitAnimations];
	}
}


@end

