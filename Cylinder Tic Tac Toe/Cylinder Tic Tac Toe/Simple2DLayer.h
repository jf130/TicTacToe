//
//  Simple2DLayer.h
//  Cylinder Tic Tac Toe
//
//  Created by V.Anh Tran on 4/9/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LayerDataDelegate <NSObject>
@required
/** return the index color for representing a specific slot
This should be playerID that made a move at this slot
current colorSet=[white,red,blue,yellow,green]
*/
-(int)indexColorForRing:(uint)ring Slot:(uint)slot sender:(id)sender;

/**	Notify delegate for touch interaction at a particular slot
Return False if this is not a valid move, other wise return True
*/
-(BOOL)userWantToMakeMoveAtRing:(uint)ring Slot:(uint)slot sender:(id)sender;

@end


@interface Simple2DLayer : UIView

/** Who responsible for what color
*/
@property (weak, nonatomic) id <LayerDataDelegate> delegate;
@property(nonatomic) int layerNumber;


@end
