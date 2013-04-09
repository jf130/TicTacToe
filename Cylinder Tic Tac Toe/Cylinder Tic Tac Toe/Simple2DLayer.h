//
//  Simple2DLayer.h
//  Cylinder Tic Tac Toe
//
//  Created by V.Anh Tran on 4/9/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LayerDataSource <NSObject>
/** return the index color for representing a specific slot
This should be playerID that made a move at this slot
current colorSet=[white,red,blue,yellow,green]
*/
-(int)indexColorForRing:(uint)ring Slot:(uint)slot;

@end


@interface Simple2DLayer : UIView

/** Who responsible for what color
*/
@property (weak, nonatomic) id <LayerDataSource> datasource;

@end
