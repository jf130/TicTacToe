//
//  WinScenceVC.m
//  Cylinder Tic Tac Toe
//
//  Created by V.Anh Tran on 4/26/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "WinScenceVC.h"

@implementation WinScenceVC

-(void)viewDidLoad{
	self.textLabel.text = self.whoWin;
    self.textLabel.textColor = self.winnerColor;
}

+(void)setWinnerColor:(UIColor*)textColor{
    [self setWinnerColor:textColor];
}

+(UIColor*)getWinnerColor{
    return [self getWinnerColor];
}




@end
