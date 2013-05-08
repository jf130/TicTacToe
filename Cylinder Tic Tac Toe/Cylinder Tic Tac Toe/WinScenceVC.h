//
//  WinScenceVC.h
//  Cylinder Tic Tac Toe
//
//  Created by V.Anh Tran on 4/26/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinScenceVC : UIViewController


@property (strong,nonatomic) NSString * whoWin;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, copy) UIColor* winnerColor;

+(UIColor*)getWinnerColor;
+(void)setWinnerColor:(UIColor*)textColor;


@end
