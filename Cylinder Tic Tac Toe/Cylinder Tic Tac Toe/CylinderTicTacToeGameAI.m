//
//  CylinderTicTacToeGameAI.m
//  Cylinder Tic Tac Toe
//
//  Created by V.Anh Tran on 4/13/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "CylinderTicTacToeGameAI.h"

@implementation CylinderTicTacToeGameAI{
	int depthLevelOfSearch;
	GameBoardIndex * bestMove;
}

-(id)initForGameLogic:(CylinderTicTacToeGameLogic*)gameLogic WithIntelligent:(int)depthLV{
	self = [super init];
	if (self) {
		depthLevelOfSearch=depthLV;
		self.currentgameBoard = gameLogic;
	}
	return self;
}

-(void)copyGameState{
	for (int l=0;l<4;l++) {
		NSMutableArray * layer = [self.board objectAtIndex:l];
		for (int r=0;r<4;r++) {
			NSMutableArray * ring = [layer objectAtIndex:r];
			for(int i=0;i<8;i++)
				[ring replaceObjectAtIndex:i withObject:@([self.currentgameBoard getPlayerIDatIndex:[GameBoardIndex indexForLayer:l Ring:r Slot:i]])];
		}
	}
	[self.history removeAllObjects];
	for (GameBoardIndex * index in self.currentgameBoard.history) {
		[self.history addObject:index];
	}
	
}

-(int)compareIndex:(GameBoardIndex*)indexA withIndex:(GameBoardIndex*)indexB{
	if(indexA.layer==indexB.layer && indexA.ring==indexB.ring && indexA.slot == indexB.slot)return 0;
	else{ 
		int dslot=abs(indexA.slot-indexB.slot);
		if (dslot>4)dslot=8-dslot;
		return pow(abs(indexA.layer-indexB.layer),3)+pow(abs(indexA.ring-indexB.ring),2)+pow(dslot,1);
	}
	//return 1;
}

-(NSArray *)possibleMovesForCurrentState{
	//int lastPlayerID=[self getPlayerIDatIndex:self.history.lastObject];
	NSMutableArray * possibleMoveList = [[NSMutableArray alloc]initWithCapacity:4*4*8];
	for (int l=0;l<4;l++) {
		for (int r=0;r<4;r++) {
			for(int i=0;i<8;i++){
				GameBoardIndex * currentIndex = [GameBoardIndex indexForLayer:l Ring:r Slot:i];
				bool skipIndex=false;
				int rate=0;
				//check for move already comited
				for (GameBoardIndex * historyIndex in self.history) {
					int d=[self compareIndex:currentIndex withIndex:historyIndex];
					if (d==0){
						skipIndex=true;
						break;
					}
					if (d<=3){
						rate+=1;
					}
				}
				if (skipIndex)continue;
				if(rate*4>=self.history.count|| rate>=1)
					[possibleMoveList addObject:currentIndex];
			}
		}
	}
	return possibleMoveList;
}

-(float)heuristicValueOfCurrentState{
	int lastPlayerID=[self getPlayerIDatIndex:self.history.lastObject];
	//NSLog(@"lastPlayerID=%d",lastPlayerID);
	
	int sum=[self heuristicValueOfCurrentStateForPlayerID:lastPlayerID]-[self heuristicValueOfCurrentStateForPlayerID:(lastPlayerID+1)%2];
	return @(sum).floatValue;///(4*4*8); 
}


-(float)heuristic2ForPlayerID:(int)playerID{
	//Count number of win situation;
	int numberOfWinSituation=0;
	for (GameBoardIndex * index in self.history) {
//		int playerID = [self getPlayerIDatIndex:index];
		
	}
	
	return numberOfWinSituation;
}

-(int)heuristicValueOfCurrentStateForPlayerID:(int)lastPlayerID{
	//Turn all 0  possible possition to lastPlayerID
//	GameBoardIndex * lastIndex=[self.history objectAtIndex:self.history.count-1];
//	if ([self getPlayerIDatIndex:lastIndex] != lastPlayerID)lastIndex=[self.history objectAtIndex:self.history.count-2];
	
	for (int l=0;l<4;l++) {
		NSMutableArray * layer = [self.board objectAtIndex:l];
		for (int r=0;r<4;r++) {
			NSMutableArray * ring = [layer objectAtIndex:r];
			for(int i=0;i<8;i++){
				if ([[ring objectAtIndex:i] intValue] == 0) {
					[ring replaceObjectAtIndex:i withObject:@(lastPlayerID)];
				}
			}
		}
	}
	
	
	//Count number of win situation;
	int numberOfWinSituation=0;
	for (int l=0;l<4;l++) {
		for (int r=0;r<4;r++) {
			for(int i=0;i<8;i++){
				GameBoardIndex * currentIndex = [GameBoardIndex indexForLayer:l Ring:r Slot:i];
				if ([self getPlayerIDatIndex:currentIndex]==lastPlayerID
				&& [self checkForWinnerAtIndex:currentIndex WithPlayerID:lastPlayerID]==1){
					numberOfWinSituation+=1;
				}
			}
		}
	}
	
	//numberOfWinSituation/=4;
	//recover board using history
	for (NSMutableArray * layer in self.board) {
		for (NSMutableArray * ring in layer) {
			for(int i=0;i<8;i++)[ring replaceObjectAtIndex:i withObject:@(0)];
		}
	}
	for(int i=0;i<self.history.count;i++){
		GameBoardIndex * index = [self.history objectAtIndex:i];
		[[[self.board objectAtIndex:index.layer] objectAtIndex:index.ring] replaceObjectAtIndex:index.slot withObject:@(i%2+1)];
	}
	
	return numberOfWinSituation;
}

-(float)minimaxSearchForDept:(int)depth{
	int lastPlayerID=[self getPlayerIDatIndex:self.history.lastObject];
	if ([self checkForWinnerAtIndex:self.history.lastObject WithPlayerID:lastPlayerID]==true)return -1;
	if(depth <= 0)return 0; //I've implement heurestic but it is terible so just return 0
	int currentPlayerID=lastPlayerID%2+1;
	float alpha = -INFINITY;
	for(GameBoardIndex * index in [self possibleMovesForCurrentState]){
		[self player:currentPlayerID makeMoveAtIndex:index];
		float a=-[self minimaxSearchForDept:depth-1];
		if(a>alpha){
			alpha=a;
			if(depth==depthLevelOfSearch)bestMove = index;
		}
		[self rollBackOneMove];
	}
	return alpha;
}	

/**
function alphabeta(node, depth, α, β, Player)         
if  depth = 0 or node is a terminal node
return the heuristic value of node
if  Player = MaxPlayer
for each child of node
α := max(α, alphabeta(child, depth-1, α, β, not(Player) ))     
if β ≤ α
break                             (* Beta cut-off *)
return α
else
for each child of node
β := min(β, alphabeta(child, depth-1, α, β, not(Player) ))     
if β ≤ α
break                             (* Alpha cut-off *)
return β
*/

-(float)alphaBetaPruningWithDepth:(int)depth Alpha:(float)alpha Beta:(float)beta botPlayer:(int)botID{
	int lastPlayerID=[self getPlayerIDatIndex:self.history.lastObject];
	if ([self checkForWinnerAtIndex:self.history.lastObject WithPlayerID:lastPlayerID]==true){
		if(botID==lastPlayerID)return INFINITY;
		else return -INFINITY;
	}
	if(depth <= 0)return 0; //I've implement heurestic but it is terible so just return 0
	int currentPlayerID=lastPlayerID%2+1;
	if (lastPlayerID!=botID) {
		for(GameBoardIndex * index in [self possibleMovesForCurrentState]){
			if([self player:currentPlayerID makeMoveAtIndex:index]==-1)continue;
			float a=[self alphaBetaPruningWithDepth:depth-1 Alpha:alpha Beta:beta botPlayer:botID];
			[self rollBackOneMove];
			
			if(a>alpha){
				alpha=a;
				if(depth==depthLevelOfSearch)bestMove = index;
			}
			if (beta<=alpha)break;
		}
		return alpha;
	}else{
		for(GameBoardIndex * index in [self possibleMovesForCurrentState]){
			if([self player:currentPlayerID makeMoveAtIndex:index]==-1)continue;
			float b=[self alphaBetaPruningWithDepth:depth-1 Alpha:alpha Beta:beta botPlayer:botID];
			[self rollBackOneMove];
			
			if(b<beta){
				beta=b;
				if(depth==depthLevelOfSearch)bestMove = index;
			}
			if (beta<=alpha)break;
		}
		return beta;
	}
}

		
-(GameBoardIndex *)bestPossibleMove{
	bestMove = Nil;
	//[self minimaxSearchForDept:depthLevelOfSearch];
	int lastPlayerID=[self getPlayerIDatIndex:self.history.lastObject];
	int currentPlayerID=lastPlayerID%2+1;
	NSLog(@"botID=%d",currentPlayerID);
	[self alphaBetaPruningWithDepth:depthLevelOfSearch Alpha:-INFINITY Beta:INFINITY botPlayer:currentPlayerID];
	return bestMove;
}

@end
