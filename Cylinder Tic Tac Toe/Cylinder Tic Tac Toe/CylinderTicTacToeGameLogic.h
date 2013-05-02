//
//  CylinderTicTacToeGameLogic.h
//  Cylinder Tic Tac Toe
//
//  Created by V.Anh Tran on 4/7/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameBoardIndex : NSObject

@property(nonatomic) uint layer;
@property(nonatomic) uint ring;
@property(nonatomic) uint slot;

+(GameBoardIndex*)indexForLayer:(uint)layer Ring:(uint)ring Slot:(uint)slot;


@end

@interface CylinderTicTacToeGameLogic : NSObject

/** 3 Dimesion array represent a board,
	+Layer (botom up)
	+Ring (innter -> outer)
	+Slot (start 12'clock wise)
	At an index, store a number represent playerID (start at 1, 0 for no player make move here)
*/
@property(strong,nonatomic) NSMutableArray * board;


/** An ordered array of history of each player move (GameBoardIndex)
	Note: playerID will be determined by %2+1
*/
@property(strong,nonatomic) NSMutableArray * history;



/** Return player id that did make move at index, playerID start at 1
	return 0 if no body has made the move yet
*/
-(int)getPlayerIDatIndex:(GameBoardIndex*)index;


/** Return 0 if player make a valid move, -1 if not, and 1 if the player did this move win.
*/
-(int)player:(int)playerID isSlotSelected:(BOOL)slotSelected isAI:(BOOL)ai makeMoveAtIndex:(GameBoardIndex*)index;

/** Test this index for winner, (return True if there is)
	+Check same Layer: layer=index.layer
		count number of cell that has same playerID with current index start from index
		-Check same ring: ring=index.ring; slot = (index.slot+i)%8, for i in [1,2,3] and [-1,-2,-3], do 2 count in both direction, if not same break, total max = 6, min =0, if total>=3, there is a winnner.
		-Check same slot: slot=index.slot; ring = r, for r in [0,1,2,3], if all same, there is a winner
		-Check spiral: ring=(index.ring+i), slot=(index.slot+i)%8, for i in [1,2,3] and [-1,-2,-3]
					and another check with slot=(index.slot-i)%8, for i in [1,2,3] and [-1,-2,-3]
		do 2 count in both direction, if not same or ring>3 or ring<0 break, total max = 3, min =0, if total>=3, there is a winnner.
		*Using mathematic to simplize this:
			ring=r for r in [0,1,2,3];
			=> i = r-index.ring;
			=> slot = (index.slot+r-index.ring)%8	and slot = (index.slot-r+index.ring)%8
			if all same, there is a winner;
	+Check accross Layer: (after i simplize)
		do similar with above but with layer=l with l=[0,1,2,3]
		-Check same ring: ring=index.ring; slot= (index.slot + l-index.layer)%8
									   and slot= (index.slot - l+index.layer)%8
		-Check same slot: slot=index.slot; ring= index.ring + l-index.layer
									   and ring= index.ring - l+index.layer
		if ring>3 or ring<0 break, total max = 3, min =0, if total>=3, there is a winnner.
		*More simplize: if index not satisfy this condition, don't need to check for winner: index.ring=index.layer or index.ring=3-index.layer
			Case index.ring=index.layer : ring=l; if all same, there is a winner
			Case index.ring=3-index.layer : ring=3-l; if all same, there is a winner
			
		For some particular index, this win situation never happend
		-Check same ring and same slot: ring=index.ring;slot=index.slot
		-Check spiral (more simplize): if index not satisfy this condition, don't need to check for winner: index.ring=index.layer or index.ring=3-index.layer
		 Case index.ring=index.layer : 
		 	ring=l; slot= (index.slot + l-index.layer)%8
				and slot= (index.slot - l+index.layer)%8
			if all same, there is a winner
		 Case index.ring=3-index.layer : 
			ring=3-l; slot= (index.slot + l-index.layer)%8
				  and slot= (index.slot - l+index.layer)%8
			if all same, there is a winner
*/
-(BOOL)checkForWinnerAtIndex:(GameBoardIndex*)index;

-(BOOL)checkForWinnerAtIndex:(GameBoardIndex *)index WithPlayerID:(int)playerID;

/** Reset game board to initial state (full of zero)
*/
-(void)resetGameBoard;

-(void)removeSelectedSlotInLayer:(int)layer Ring:(int)ring Slot:(int)slot;

-(void)removeSelectedSlotsInOtherLayers:(int)layerNum;

/** Roll back one move
*/
-(void)rollBackOneMove;

@end
