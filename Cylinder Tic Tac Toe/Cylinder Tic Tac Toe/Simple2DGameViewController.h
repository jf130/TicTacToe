//
//  Simple2DGameViewController.h
//  Cylinder Tic Tac Toe
//
//  Created by uicsi7 on 4/9/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CylinderTicTacToeGameLogic.h"
#import "Simple2DLayer.h"


@interface Simple2DGameViewController : UIViewController <LayerDataDelegate>


@property(nonatomic) int currentPlayer;
@property(nonatomic) int numberOfPlayers;
@property(nonatomic) BOOL vsAI;
@property(nonatomic) BOOL isSlotSelected;
@property(nonatomic) uint selectedLayer,selectedRing,selectedSlot;

@end
