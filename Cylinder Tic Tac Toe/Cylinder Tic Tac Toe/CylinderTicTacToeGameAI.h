//
//  CylinderTicTacToeGameAI.h
//  Cylinder Tic Tac Toe
//
//  Created by V.Anh Tran on 4/13/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CylinderTicTacToeGameLogic.h"

@interface CylinderTicTacToeGameAI : CylinderTicTacToeGameLogic

@property(weak,nonatomic) CylinderTicTacToeGameLogic * currentgameBoard;


-(id)initForGameLogic:(CylinderTicTacToeGameLogic*)gameLogic WithIntelligent:(int)deepLV;


/** Copy game state of currentGameBoard
*/
-(void)copyGameState;

/** Return a list of (GameIndex) represent possible moves for current state
*/
-(NSArray*)possibleMovesForCurrentState;

/** Return a heuristic value of currentState if this state is not an end state
I tried a simple heuristic but it is terrible unless there are few slot left in current state

*/
-(float)heuristicValueOfCurrentStateForPlayerID:(int)playerID;

/** Return the best move found by AI
*/
-(GameBoardIndex*)bestPossibleMove;



@end
