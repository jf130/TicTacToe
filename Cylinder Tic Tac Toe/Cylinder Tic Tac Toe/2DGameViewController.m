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
        gameLogic = [[CylinderTicTacToeGameLogic alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Simple2DLayer * layerZero = [[Simple2DLayer alloc]initWithFrame:CGRectMake(10, 50, 300, 300)];
    layerZero.delegate = self;
	[self.view addSubview:layerZero];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    CGPoint pt = [[touches anyObject] locationInView:self.view];
//	NSLog(@"pt=%f,%f",pt.x,pt.y);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
}

-(int)indexColorForRing:(uint)ring Slot:(uint)slot sender:(id)sender
{
    GameBoardIndex *index = [GameBoardIndex indexForLayer :0 Ring:ring Slot:slot];
    int playerColorIndex = [gameLogic getPlayerIDatIndex:index];
    return playerColorIndex;
}

-(BOOL)userWantToMakeMoveAtRing:(uint)ring Slot:(uint)slot sender:(id)sender
{
    return true;
}

@end

