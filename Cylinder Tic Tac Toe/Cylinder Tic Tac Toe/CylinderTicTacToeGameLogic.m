//
//  CylinderTicTacToeGameLogic.m
//  Cylinder Tic Tac Toe
//
//  Created by V.Anh Tran on 4/7/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "CylinderTicTacToeGameLogic.h"

@implementation GameBoardIndex

+(GameBoardIndex *)indexForLayer:(uint)layer Ring:(uint)ring Slot:(uint)slot{
	GameBoardIndex * index = [[GameBoardIndex alloc]init];
	index.layer=layer;
	index.ring=ring;
	index.slot=slot;
	return index;
}

@end

@implementation CylinderTicTacToeGameLogic

-(id)init{
	self = [super init];
	if (self) {
		self.board = [[NSMutableArray alloc]initWithCapacity:4];
		for (int l=0; l<=3; l++) {
			NSMutableArray * layer = [[NSMutableArray alloc]initWithCapacity:4];
			for (int r=0; r<=3; r++) {
				NSMutableArray * ring = [[NSMutableArray alloc]initWithCapacity:8];
				for(int i=0;i<8;i++)[ring addObject:@(0)];
				[layer addObject:ring];
			}
			[self.board addObject:layer];
		}
		self.history = [[NSMutableArray alloc]init];
	}
	return self;
}

-(void)resetGameBoard{
	for (NSMutableArray * layer in self.board) {
		for (NSMutableArray * ring in layer) {
			for(int i=0;i<8;i++)[ring replaceObjectAtIndex:i withObject:@(0)];
		}
	}
	[self.history removeAllObjects];//clear history
}

-(int)getPlayerIDatIndex:(GameBoardIndex *)index{
	return [[[[self.board objectAtIndex:index.layer] objectAtIndex:index.ring] objectAtIndex:index.slot] intValue];
}

-(int)player:(int)playerID makeMoveAtIndex:(GameBoardIndex *)index{
	// check valid move ( correct possition ,correct player turn )
	if ([self getPlayerIDatIndex:index] != 0 || self.history.count%2+1 !=playerID) //i could comment this player turn condition for testing
		return -1;
	//make move
	[[[self.board objectAtIndex:index.layer] objectAtIndex:index.ring] replaceObjectAtIndex:index.slot withObject:@(playerID)];
	[self.history addObject:index]; //add to history
	//check for winner
	if([self checkForWinnerAtIndex:index]==true)return 1;
	return 0;
}

-(BOOL)checkForWinnerAtIndex:(GameBoardIndex *)index{
	int playerID=[self getPlayerIDatIndex:index];
	if(playerID<0)return false;
	//Check same layer
	int count,layer,ring,slot;
	layer=index.layer;
		//check same ring
		count=0;
		ring=index.ring;
		for (int i=1; i<=3; i++) {
			slot = (index.slot+i)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
			else break;
		}
		for (int i=-1; i>=-3; i--) {
			slot = (index.slot+i)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
			else break;
		}
		if (count>=3)return true;//result count not include the current one
		//check same slot
		count=0;
		slot=index.slot;
		for (int r=0; r<=3; r++) {
			ring=r;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
			else break;
		}
		if (count>=4)return true;
		//check spiral check 1
		count=0;
		for (int r=0; r<=3; r++) {
			ring=r;
			slot=(index.slot+r-index.ring)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
			else break;
		}	
		if (count>=4)return true;
		//check spiral check 2
		count=0;
		for (int r=0; r<=3; r++) {
			ring=r;
			slot=(index.slot-r+index.ring)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
			else break;
		}	
		if (count>=4)return true;
	//check across layer
		//check same ring check 1
		count=0;
		ring=index.ring;
		for (int l=0; l<=3; l++) {
			layer=l;
			slot= (index.slot + l-index.layer)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
			else break;
		}	
		if (count>=4)return true;
		//check same ring check 2
		count=0;
		ring=index.ring;
		for (int l=0; l<=3; l++) {
			layer=l;
			slot= (index.slot - l+index.layer)%8;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
			else break;
		}	
		if (count>=4)return true;
		//check same slot situation 1
		if(index.ring==index.layer){
			count=0;
			slot=index.slot;
			for (int l=0; l<=3; l++) {
				layer=l;
				ring=l;
				if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
				else break;
			}	
			if (count>=4)return true;
		}
		//check same slot situation 2
		count=0;
		slot=index.slot;
		if(index.ring==3-index.layer){
			for (int l=0; l<=3; l++) {
				layer=l;
				ring=3-l;
				if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
				else break;
			}	
			if (count>=4)return true;
		}
		
		//check same ring same slot
		count=0;
		ring=index.ring;slot=index.slot;
		for (int l=0; l<=3; l++) {
			layer=l;
			if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
			else break;
		}
		if (count>=4)return true;
		
		//check spiral situation 1
		if(index.ring==index.layer){
			//check 1
			count=0;
			for (int l=0; l<=3; l++) {
				layer=l;
				ring=l;
				slot= (index.slot + l-index.layer)%8;
				if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
				else break;
			}	
			if (count>=4)return true;
			//check 2
			count=0;
			for (int l=0; l<=3; l++) {
				layer=l;
				ring=l;
				slot= (index.slot - l+index.layer)%8;
				if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
				else break;
			}	
			if (count>=4)return true;
		}
		
		//check spiral situation 2
		if(index.ring==3-index.layer){
			//check 1
			count=0;
			for (int l=0; l<=3; l++) {
				layer=l;
				ring=3-l;
				slot= (index.slot + l-index.layer)%8;
				if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
				else break;
			}	
			if (count>=4)return true;
			//check 2
			count=0;
			for (int l=0; l<=3; l++) {
				layer=l;
				ring=3-l;
				slot= (index.slot - l+index.layer)%8;
				if ([self getPlayerIDatIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]]==playerID)count+=1;
				else break;
			}	
			if (count>=4)return true;
		}
		
	return false;
}

@end
