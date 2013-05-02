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

-(float)heuristicValueOfCurrentStateForPlayerID:(int)playerID{
	
	float sum=0;
	for (GameBoardIndex * index in self.history) {
		int indexPlayerID=[self getPlayerIDatIndex:index];
		if (indexPlayerID==0)NSLog(@"WTF");
		float heuristicValue = [self heuristicValueOfCurrentStateForIndex:index WithPlayerID:indexPlayerID];
		if(playerID==indexPlayerID)sum+=heuristicValue;
		else sum-=heuristicValue;
	}
	
	return sum;///(4*4*8); 
}



-(float)heuristicValueOfCurrentStateForIndex:(GameBoardIndex *)index WithPlayerID:(int)playerID{
	//Check same layer
	int count,count2,layer,ring,slot;
	int point=0;
	layer=index.layer;
	//check same ring
	count=count2=0;
	ring=index.ring;
	for (int i=1; i<=3; i++) {
		slot = (index.slot+i)%8;
		if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
		else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
		else break;
	}
	for (int i=-1; i>=-3; i--) {
		slot = (index.slot+i)%8;
		if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
		else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
		else break;
	}
	if (count>=3)point+=1+count2;//result count not include the current one
	if (count>=4 && count2>=2)point+=count2*count2*count;//sure win situation
	
	//check same slot
	count=count2=0;
	slot=index.slot;
	for (int r=0; r<=3; r++) {
		ring=r;
		if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
		else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
		else break;
	}
	if (count>=4)point+=count2;
	//check spiral check 1
	count=count2=0;
	for (int r=0; r<=3; r++) {
		ring=r;
		slot=(index.slot+r-index.ring)%8;
		if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
		else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
		else break;
	}	
	if (count>=4)point+=count2;;
	//check spiral check 2
	count=count2=0;
	for (int r=0; r<=3; r++) {
		ring=r;
		slot=(index.slot-r+index.ring)%8;
		if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
		else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
		else break;
	}	
	if (count>=4)point+=count2;
	//check across layer
	//check same ring check 1
	count=count2=0;
	ring=index.ring;
	for (int l=0; l<=3; l++) {
		layer=l;
		slot= (index.slot + l-index.layer)%8;
		if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
		else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
		else break;
	}	
	if (count>=4)point+=count2;
	//check same ring check 2
	count=count2=0;
	ring=index.ring;
	for (int l=0; l<=3; l++) {
		layer=l;
		slot= (index.slot - l+index.layer)%8;
		if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
		else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
		else break;
	}	
	if (count>=4)point+=count2;
	//check same slot situation 1
	if(index.ring==index.layer){
		count=count2=0;
		slot=index.slot;
		for (int l=0; l<=3; l++) {
			layer=l;
			ring=l;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
			else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
			else break;
		}	
		if (count>=4)point+=count2;
	}
	//check same slot situation 2
	count=count2=0;
	slot=index.slot;
	if(index.ring==3-index.layer){
		for (int l=0; l<=3; l++) {
			layer=l;
			ring=3-l;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
			else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
			else break;
		}	
		if (count>=4)point+=count2;
	}
	
	//check same ring same slot
	count=count2=0;
	ring=index.ring;slot=index.slot;
	for (int l=0; l<=3; l++) {
		layer=l;
		if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
		else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
		else break;
	}
	if (count>=4)point+=count2;
	
	//check spiral situation 1
	if(index.ring==index.layer){
		//check 1
		count=count2=0;
		for (int l=0; l<=3; l++) {
			layer=l;
			ring=l;
			slot= (index.slot + l-index.layer)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
			else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
			else break;
		}	
		if (count>=4)point+=count2;
		//check 2
		count=count2=0;
		for (int l=0; l<=3; l++) {
			layer=l;
			ring=l;
			slot= (index.slot - l+index.layer)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
			else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
			else break;
		}	
		if (count>=4)point+=count2;
	}
	
	//check spiral situation 2
	if(index.ring==3-index.layer){
		//check 1
		count=count2=0;
		for (int l=0; l<=3; l++) {
			layer=l;
			ring=3-l;
			slot= (index.slot + l-index.layer)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
			else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
			else break;
		}	
		if (count>=4)point+=count2;
		//check 2
		count=count2=0;
		for (int l=0; l<=3; l++) {
			layer=l;
			ring=3-l;
			slot= (index.slot - l+index.layer)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID){count+=1;count2+=1;}
			else if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==0)count+=1;
			else break;
		}	
		if (count>=4)point+=count2;
	}
	
	return point;
}

-(float)minimaxSearchForDept:(int)depth{
	int lastPlayerID=[self getPlayerIDatIndex:self.history.lastObject];
	if ([self checkForWinnerAtIndex:self.history.lastObject WithPlayerID:lastPlayerID]==true)return -1;
	if(depth <= 0)return 0; //I've implement heurestic but it is terible so just return 0
	int currentPlayerID=lastPlayerID%2+1;
	float alpha = -INFINITY;
	for(GameBoardIndex * index in [self possibleMovesForCurrentState]){
		[self player:currentPlayerID isSlotSelected:false isAI:true makeMoveAtIndex:index];
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
	if(depth <= 0)return [self heuristicValueOfCurrentStateForPlayerID:botID]; //I've implement heurestic but it is terible so just return 0
	int currentPlayerID=lastPlayerID%2+1;
	if (lastPlayerID!=botID) {
		for(GameBoardIndex * index in [self possibleMovesForCurrentState]){
			if([self player:currentPlayerID isSlotSelected:false isAI:true makeMoveAtIndex:index]==-1)continue;
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
			if([self player:currentPlayerID isSlotSelected:false isAI:true makeMoveAtIndex:index]==-1)continue;
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
	NSLog(@"player heuristic=%.2f",[self heuristicValueOfCurrentStateForPlayerID:lastPlayerID]);
	
	[self alphaBetaPruningWithDepth:depthLevelOfSearch Alpha:-INFINITY Beta:INFINITY botPlayer:currentPlayerID];
	return bestMove;
}

@end
