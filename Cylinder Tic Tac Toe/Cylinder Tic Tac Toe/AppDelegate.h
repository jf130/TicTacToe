//
//  AppDelegate.h
//  Cylinder Tic Tac Toe
//
//  Created by uicsi7 on 3/25/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebSocketChannelDelegate <NSObject>


/** Channel Open
start receiving message from a channel
*/
@required
-(void)channelOpen;

/**	Receive a message from channel
*/
@required
-(void)receiveMessage:(NSString*)mes;

/**	Receive an error from channel
*/
-(void)receiveError:(NSString*)error;

/** Channel Close
channel stop working from now
*/
@required
-(void)channelClose;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property id<WebSocketChannelDelegate> webSocketlDelegate;

@end
