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
#define timeInterval 1

@interface Simple2DGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end


@implementation Simple2DGameViewController {
    
    CylinderTicTacToeGameLogic *gameLogic;
    NSArray * colorSet;
	NSMutableArray * layerArray;
    
	CylinderTicTacToeGameAI * testAI;
	
	NSString * whoWin;
	
	UIWebView * backgroundWebView;
	
	bool waitForOpponent;
	
	int timeCount;
	NSString * gamekey;
	
	NSTimer * timer;
}

//static NSString * serverURL = @"http://localhost:8080";
static NSString * serverURL = @"http://social-file-server.appspot.com";

- (void)viewDidLoad
{
    [super viewDidLoad];
	colorSet=@[[UIColor whiteColor],[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor], [UIColor grayColor]];
	gameLogic = [[CylinderTicTacToeGameLogic alloc]init];
	if(self.vsAI)testAI = [[CylinderTicTacToeGameAI alloc]initForGameLogic:gameLogic WithIntelligent:2];
	
	
	
	
	self.numberOfPlayers = 2;
	self.currentPlayer = 1;
	self.textLabel.text=@"Player 1 turn";
    self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
    self.isSlotSelected = false;
	
    
	if(self.vsPlayerOnline) {
		self.myPlayerID=0;
		gamekey=@"";
		waitForOpponent=true;
		backgroundWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
		[backgroundWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/test/gamechannel?gamekey=%@",serverURL,gamekey]]]];
		AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
		app.webSocketlDelegate = self; //set delegate for websocket connection
		
		self.textLabel.text=@"Init connection";
	}
	
	layerArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i=0; i<4; i++) {
		Simple2DLayer * layerView = [[Simple2DLayer alloc]initWithFrame:CGRectMake(35, 1+112*i, 250, 250)];
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
    
    if (self.vsPlayerOnline && self.myPlayerID!=self.currentPlayer) {
		//user is playing online and this is not user turn to play
		return false;
	}
	
    if(self.isSlotSelected && layer == self.selectedLayer
                           && ring == self.selectedRing
                           && slot == self.selectedSlot
       ){
        int result = [gameLogic player:self.currentPlayer isSlotSelected:self.isSlotSelected isAI:false makeMoveAtIndex:[GameBoardIndex indexForLayer:layer Ring:ring Slot:slot]];
        NSLog(@"player=%d , result=%d",self.currentPlayer,result);
		
        [self redrawBoard:layer];
            
            if([gameLogic checkForWinnerAtIndex:gameLogic.history.lastObject WithPlayerID:self.currentPlayer]){
                NSLog(@"Player %d won!",self.currentPlayer);
                self.textLabel.text = [NSString stringWithFormat:@"Player %d won",self.currentPlayer];
                self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
                whoWin = [NSString stringWithFormat:@"Player %d won",self.currentPlayer];
				if (self.vsPlayerOnline) whoWin = @"You Won!";
                [self performSegueWithIdentifier:@"gotoWinScenceVC" sender:Nil];
            }
            
            self.currentPlayer+=1;
            if (self.currentPlayer>self.numberOfPlayers)self.currentPlayer=1;
            
        self.textLabel.text = [NSString stringWithFormat:@"Player %d turn",self.currentPlayer];
        self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
        self.isSlotSelected = false;
        
		if (self.vsPlayerOnline) { //playing online, send message to opponent about use move
			[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/test/gamechannel?gamekey=%@&mes=%d%d%d%d",serverURL,gamekey,self.myPlayerID,layer,ring,slot]] encoding:NSUTF8StringEncoding error:nil];
			timeCount=0;
		}
        if (self.currentPlayer==2 && self.vsAI){
            [testAI copyGameState];
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
                    
                self.currentPlayer+=1;
				if (self.currentPlayer>self.numberOfPlayers)self.currentPlayer=1;
				
                self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
           		//bring the layer that bot make move to front, will rearrange when user try to move
				[self.view bringSubviewToFront: [layerArray objectAtIndex:bestMove.layer]];
				
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
		//rearrange layer to normal
		[self arrangeLayer];
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

-(void)arrangeLayer{
	for (Simple2DLayer * layerView in layerArray)[self.view bringSubviewToFront:layerView];	
}

#pragma mark - touch, gesture

- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender {
//	NSLog(@"Swipe!");
	//rearrange layer
	[self arrangeLayer];
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
		[timer invalidate];
		WinScenceVC * destVC = segue.destinationViewController;
		NSLog(@"whoWin=%@",whoWin);
        [destVC setWinnerColor:[colorSet objectAtIndex:self.currentPlayer]];
		destVC.whoWin = whoWin;
	}
}

#pragma mark - Counter
- (void)updateCounter:(NSTimer *)theTimer {
	timeCount+=timeInterval;
	
	if(waitForOpponent){
		if (timeCount>120) {
			whoWin = @"Time out!";
			[self performSegueWithIdentifier:@"gotoWinScenceVC" sender:Nil];
		}
		self.textLabel.text = [NSString stringWithFormat:@"Wait Oppt %d",120-timeCount];
	}else{
		if(timeCount%20==0 && self.currentPlayer!=self.myPlayerID){
			[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/test/gamechannel?gamekey=%@&cache=no&mes=PING",serverURL,gamekey]] encoding:NSUTF8StringEncoding error:nil];
		}
		
	}
	//polling
	if(timeCount%30==0){
		NSLog(@"Polling for message...");
		NSString *mes=[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/test/gamechannel?gamekey=%@&cache=get",serverURL,[self getMyRealGamekey]]] encoding:NSUTF8StringEncoding error:nil];
		NSLog(@"Result polling=%@",mes);
		if(mes){
			[self receiveMessage:mes];
		}
	}
}

-(int)getOpponentID{
	return self.myPlayerID%2+1;
}

-(NSString*)getMyRealGamekey{
	int len = [gamekey length]; //gamekey is the key token of opponent
    NSMutableString *reverse = [[NSMutableString alloc] initWithCapacity:len];
    for(int i=len-1;i>=0;i--)[reverse appendString:[NSString stringWithFormat:@"%c",[gamekey characterAtIndex:i]]];
	return reverse;
}


#pragma mark - Websocket delegate
-(void)receiveMessage:(NSString *)mes{
	//pid,layer,ring,slot
	if([mes isEqualToString:@"PING"]){
		NSLog(@"You has been PING");
		if(self.currentPlayer==self.myPlayerID){//wait me make a move
			[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/test/gamechannel?gamekey=%@&cache=no&mes=WAIT",serverURL,gamekey]] encoding:NSUTF8StringEncoding error:nil];
		}else{//he didn't get my lastmove, resend it
			GameBoardIndex * lastMove = gameLogic.history.lastObject;
			[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/test/gamechannel?gamekey=%@&mes=%d%d%d%d",serverURL,gamekey,self.myPlayerID,lastMove.layer,lastMove.ring,lastMove.slot]] encoding:NSUTF8StringEncoding error:nil];
		}
	}else if ([mes isEqualToString:@"WAIT"]){
		NSLog(@"Your opponent is thinking!");
	}else if ([mes isEqualToString:@"QUIT"]){
		NSLog(@"Opponent quit!");
		whoWin = @"Opponent quit";
		[self performSegueWithIdentifier:@"gotoWinScenceVC" sender:Nil];
	}
	else if (mes.length>3 && [[mes substringToIndex:3] isEqualToString:@"OK:"]){
		
		if(self.myPlayerID==0){
			gamekey = [mes substringFromIndex:3];
			self.myPlayerID=1;//this player create the game that other join
//			[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/test/gamechannel?gamekey=%@&mes=OK:%@",serverURL,gamekey,[self getMyRealGamekey]]] encoding:NSUTF8StringEncoding error:nil];
			self.textLabel.text=@"Your turn";
			self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
			waitForOpponent=false;
		}
//		else{
//			if ([gamekey isEqualToString:[mes substringFromIndex:3]])NSLog(@"Handshake OK!");
//			else NSLog(@"Invalid gamekey while handshaking!");
//			self.textLabel.text=@"Player 1 turn";
//		}
		
	}
	else if (mes.length>5 && [[mes substringToIndex:5] isEqualToString:@"JOIN:"]){
		gamekey = [mes substringFromIndex:5];
		[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/test/gamechannel?gamekey=%@&mes=OK:%@",serverURL,gamekey,[self getMyRealGamekey]]] encoding:NSUTF8StringEncoding error:nil];
		self.myPlayerID=2;//this player join the game that other create
		self.textLabel.text=@"Player 1 turn";;
		self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
		waitForOpponent=false;
	}
	else if(mes.length==4){
		int pid=[[mes substringWithRange:NSMakeRange(0, 1)] intValue];
		if(pid==0)return;//not correct message
		
		int layer=[[mes substringWithRange:NSMakeRange(1, 1)] intValue]%4;
		int ring=[[mes substringWithRange:NSMakeRange(2, 1)] intValue]%4;
		int slot=[[mes substringWithRange:NSMakeRange(3, 1)] intValue]%8;
		
		NSLog(@"pid=%d,layer=%d,ring=%d,slot=%d",pid,layer,ring,slot);
		if(pid == self.currentPlayer && pid !=self.myPlayerID){ //opponent move
			GameBoardIndex * opponentMove = [GameBoardIndex indexForLayer:layer Ring:ring Slot:slot];
			[gameLogic player:self.currentPlayer isSlotSelected:true isAI:true makeMoveAtIndex:[GameBoardIndex indexForLayer:opponentMove.layer Ring:opponentMove.ring Slot:opponentMove.slot]];
			[self redrawBoard:opponentMove.layer];
			if([gameLogic checkForWinnerAtIndex:gameLogic.history.lastObject WithPlayerID:self.currentPlayer]){
				NSLog(@"You lost!");
				whoWin = @"You lost";
				[self performSegueWithIdentifier:@"gotoWinScenceVC" sender:Nil];
			}else{
				self.textLabel.text = @"Your turn";
			}
			self.currentPlayer+=1;
			if (self.currentPlayer>self.numberOfPlayers)self.currentPlayer=1;
			
			self.textLabel.textColor = [colorSet objectAtIndex:self.currentPlayer];
			//bring the layer that opponent make move to front, will rearrange when user try to move
			[self.view bringSubviewToFront: [layerArray objectAtIndex:opponentMove.layer]];
		}
	}
}

-(void)receiveError:(NSString *)error{
	NSLog(@"WebSocket error:%@",error);
	UIAlertView * allert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"WebSocket error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
	[allert show];
}

-(void)channelOpen{
	NSLog(@"WebSocket Channel Openned!");
	self.textLabel.text=@"Wait Oppt";
	timeCount=0;
	timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval
									 target:self
								   selector:@selector(updateCounter:)
								   userInfo:nil
									repeats:YES];
}

-(void)channelClose{
	whoWin = @"Connection Lost";
	[self performSegueWithIdentifier:@"gotoWinScenceVC" sender:nil];
}

-(void)sendQuitGameSignal{
	[timer invalidate];
	if (!waitForOpponent) {
		[NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/test/gamechannel?gamekey=%@&mes=QUIT",serverURL,gamekey]] encoding:NSUTF8StringEncoding error:nil];
		NSLog(@"Quit signal sent!");
	}
}

@end

