//
//  AppDelegate.m
//  Cylinder Tic Tac Toe
//
//  Created by uicsi7 on 3/25/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
	NSString * fullURL=[url absoluteString];
	NSLog(@"Handle url: %@",fullURL);
	if([[fullURL substringToIndex:11] isEqualToString:@"game://OPEN"]){
		NSLog(@"OPEN");
		if(self.webSocketlDelegate!=Nil)[self.webSocketlDelegate channelOpen];
		return YES;
	}
	if([[fullURL substringToIndex:11] isEqualToString:@"game://MES:"]){
		NSString * mes = [fullURL substringFromIndex:11];
		NSLog(@"mes=%@",mes);
		if(self.webSocketlDelegate!=Nil)[self.webSocketlDelegate receiveMessage:mes];
		return YES;
	}
	if([[fullURL substringToIndex:13] isEqualToString:@"game://ERROR:"]){
		NSString * error = [fullURL substringFromIndex:13];
		NSLog(@"error=%@",error);
		if(self.webSocketlDelegate!=Nil)[self.webSocketlDelegate receiveError:error];
		return YES;
	}
	if([[fullURL substringToIndex:12] isEqualToString:@"game://CLOSE"]){
		NSLog(@"CLOSE");
		if(self.webSocketlDelegate!=Nil)[self.webSocketlDelegate channelClose];
		return YES;
	}
	NSLog(@"Handle failed!");
	return NO;
}
@end
