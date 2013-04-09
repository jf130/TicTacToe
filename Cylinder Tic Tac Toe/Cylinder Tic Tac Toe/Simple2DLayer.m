//
//  Simple2DLayer.m
//  Cylinder Tic Tac Toe
//
//  Created by V.Anh Tran on 4/9/13.
//  Copyright (c) 2013 uicsi7. All rights reserved.
//

#import "Simple2DLayer.h"

@implementation Simple2DLayer{
	NSArray * colorSet;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor=[UIColor whiteColor];
		colorSet=@[[UIColor whiteColor],[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor]];
    }
    return self;
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
	CGRect bounds = self.bounds;
	CGPoint center = CGPointMake((bounds.size.width/2.0), (bounds.size.height/2.0));
	int numberOfSlot=8;
	CGFloat slotAngle = M_PI*2 / numberOfSlot;
	CGFloat radius=self.frame.size.width/2;
	CGFloat ringRadius=radius/4;
	for (int r=3; r>=0; r--) {
		
		for (int i=0; i<8; i++) {
			//Draw the disk
			[[UIColor blackColor] setStroke];
			CGFloat startAngle = slotAngle * i;
			CGFloat endAngle = startAngle + slotAngle;
			
			
			UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:ringRadius*r+ringRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
			if (r!=0)[path addArcWithCenter:center radius:ringRadius*r startAngle:endAngle endAngle:startAngle clockwise:NO];
			else [path addLineToPoint:center];
			[path closePath];
			
			[path setLineWidth:2.2];
			[path stroke];
			
			UIColor *fillColor;
			if(self.datasource != nil)fillColor = [colorSet objectAtIndex:[self.datasource indexColorForRing:r Slot:i]];
			else{//test color
				if(i%2==0){
					fillColor= [UIColor blueColor];
					if(r%2==0)fillColor = [UIColor greenColor];	
				}else{
					fillColor = [UIColor redColor];
					if(r%2==0)fillColor = [UIColor yellowColor];	
				}
			}
			
			[fillColor set];
			[path fill];
		
		}
	}
}



@end
