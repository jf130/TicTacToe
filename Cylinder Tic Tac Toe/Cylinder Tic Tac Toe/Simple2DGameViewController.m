//
//  Simple2DGameViewController.m
//  Cylinder Tic Tac Toe
//
//  Created by uicsi7 on 4/9/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "Simple2DGameViewController.h"
#import "Simple2DLayer.h"
#import "CylinderTicTacToeGameLogic.h"
#import "CylinderTicTacToeGameAI.h"

#import "WinScenceVC.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define RadiansToDegrees(x) ((x) * 180 / M_PI)

@interface Simple2DGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation Simple2DGameViewController {
    
    CylinderTicTacToeGameLogic *gameLogic;
    NSArray * colorSet;
	NSMutableArray * layerArray;
    
	CylinderTicTacToeGameAI * testAI;
	
	NSString * whoWin;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	colorSet=@[[UIColor whiteColor],[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor], [UIColor grayColor]];
	gameLogic = [[CylinderTicTacToeGameLogic alloc]init];
	if(self.vsAI)testAI = [[CylinderTicTacToeGameAI alloc]initForGameLogic:gameLogic WithIntelligent:2];
	
	self.numberOfPlayers = 2;
	self.currentPlayer = 1;
	self.textLabel.text=@"Player 1";
    self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
    self.isSlotSelected = false;
	
    layerArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i=0; i<4; i++) {
		Simple2DLayer * layerView = [[Simple2DLayer alloc]initWithFrame:CGRectMake(30, 1+112*i, 250, 250)];
		layerView.delegate = self;
        layerView.layerNumber = i;
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
    [gameLogic removeSelectedSlotsInOtherLayers:layer];
    for (Simple2DLayer * layerView in layerArray) [layerView setNeedsDisplay];
    
    
    if(self.isSlotSelected && layer == self.selectedLayer
                           && ring == self.selectedRing
                           && slot == self.selectedSlot
       ){
        int result = [gameLogic player:self.currentPlayer isSlotSelected:self.isSlotSelected isAI:false makeMoveAtIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]];
        NSLog(@"player=%d , result=%d",self.currentPlayer,result);
        
        [testAI copyGameState];
		
        [self redrawBoard:layer];
            
            if([gameLogic checkForWinnerAtIndex:gameLogic.history.lastObject WithPlayerID:self.currentPlayer]){
                NSLog(@"Player %d won!",self.currentPlayer);
                self.textLabel.text = [NSString stringWithFormat:@"Player %d won",self.currentPlayer];
                self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
                whoWin = [NSString stringWithFormat:@"Player %d won",self.currentPlayer];
                [self performSegueWithIdentifier:@"gotoWinScenceVC" sender:Nil];
            }
            
            self.currentPlayer+=1;
            if (self.currentPlayer>self.numberOfPlayers)self.currentPlayer=1;
            
        self.textLabel.text = [NSString stringWithFormat:@"Player %d turn",self.currentPlayer];
        self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
        self.isSlotSelected = false;
        
        if (self.currentPlayer==2 && self.vsAI){
            
            self.textLabel.text = @"Waiting for AI";
            self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
            [self.view setNeedsDisplay];
            GameBoardIndex * bestMove = [testAI bestPossibleMove];
            NSLog(@"bestMove %@=(%d,%d,%d)",bestMove,bestMove.layer,bestMove.ring,bestMove.slot);
            if (bestMove!=Nil) {
                [gameLogic player:self.currentPlayer isSlotSelected:true isAI:true makeMoveAtIndex:[GameBoardIndex indexForLayer:bestMove.layer Ring:bestMove.ring Slot:bestMove.slot]];
                [self redrawBoard:bestMove.layer];
                if([gameLogic checkForWinnerAtIndex:gameLogic.history.lastObject WithPlayerID:self.currentPlayer]){
                    NSLog(@"Bot won!");
                    self.textLabel.text = @"Bot won!";
                    whoWin = @"Bot won!";
                    [self performSegueWithIdentifier:@"gotoWinScenceVC" sender:Nil];
                }else{
                    self.textLabel.text = @"Player 1 turn";
                }
                    
                self.currentPlayer=self.currentPlayer%2+1;
                self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
            }else{
                NSLog(@"Bot give up!");
                self.textLabel.text = @"Bot give up!";
                whoWin = @"You won!\nBot give up!";
                [self performSegueWithIdentifier:@"gotoWinScenceVC" sender:Nil];
            }
            
        }

        return true;
                    
    }
    else{
        if(self.isSlotSelected){
            [self removeSelectedSlotInLayer];
        }
        int result = [gameLogic player:self.currentPlayer isSlotSelected:self.isSlotSelected isAI:false makeMoveAtIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]];
        NSLog(@"player=%d , result=%d",self.currentPlayer,result);
        NSString *test = @"FALSE";
        if(self.isSlotSelected){
            test = @"TRUE";
        }
        NSLog(@"isSelected=%@",test);
        if(result != -1){
            
            [self redrawBoard:layer];
            self.selectedLayer = layer;
            self.selectedRing = ring;
            self.selectedSlot = slot;
            self.isSlotSelected = true;
            return true;
        }
        else{
            self.textLabel.text = [NSString stringWithFormat:@"Player %d wrong move!",self.currentPlayer];
            self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
            return false;
        }
    }
    

}

-(void)removeSelectedSlotInLayer{
    [gameLogic removeSelectedSlotInLayer:self.selectedLayer Ring:self.selectedRing Slot:self.selectedSlot];
    self.isSlotSelected = false;
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
//	NSLog(@"Swipe!");
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
#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([segue.identifier isEqualToString:@"gotoWinScenceVC"]) {
		WinScenceVC * destVC = segue.destinationViewController;
		NSLog(@"whoWin=%@",whoWin);
        [destVC setWinnerColor:[colorSet objectAtIndex:self.currentPlayer]];
		destVC.whoWin = whoWin;
	}
}

@end

