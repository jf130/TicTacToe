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
#import "AppDelegate.h"

@interface Simple2DGameViewController : UIViewController <LayerDataDelegate,WebSocketChannelDelegate>


@property(nonatomic) int currentPlayer;
@property(nonatomic) int numberOfPlayers;
@property(nonatomic) BOOL vsAI;
@property(nonatomic) BOOL isSlotSelected;
@property(nonatomic) uint selectedLayer,selectedRing,selectedSlot;


@property(nonatomic) BOOL vsPlayerOnline;
@property(nonatomic) int myPlayerID;

@end
