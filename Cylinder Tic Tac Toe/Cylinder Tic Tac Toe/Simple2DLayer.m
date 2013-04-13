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
	NSArray * radiusSet;
	uint currentSlot,currentRing;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor=[UIColor clearColor];
		colorSet=@[[UIColor whiteColor],[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor]];
    	radiusSet=@[@(0.36),@(0.58),@(0.8),@(1.0)];
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
	CGFloat lineWidth=2.2;
	CGFloat radius=self.frame.size.width/2-lineWidth/2;
//	CGFloat ringRadius=radius/4;
	for (int r=3; r>=0; r--) {
		
		for (int i=0; i<8; i++) {
			//Draw the disk
			[[UIColor blackColor] setStroke];
			CGFloat startAngle = slotAngle * i;
			CGFloat endAngle = startAngle + slotAngle;
			
			CGFloat rad = radius * ([[radiusSet objectAtIndex:r] floatValue]);
			UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:rad startAngle:startAngle endAngle:endAngle clockwise:YES];
			if (r!=0){
				rad=radius * ([[radiusSet objectAtIndex:r-1] floatValue]);
				[path addArcWithCenter:center radius:rad startAngle:endAngle endAngle:startAngle clockwise:NO];
			}else [path addLineToPoint:center];
			[path closePath];
			
			[path setLineWidth:lineWidth];
			[path stroke];
			
			UIColor *fillColor;
			if(self.delegate != nil)fillColor = [colorSet objectAtIndex:[self.delegate indexColorForRing:r Slot:i sender:self]];
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

-(uint)identifySlotForPoint:(CGPoint)pt{
	CGRect bounds = self.bounds;
	CGPoint center = CGPointMake((bounds.size.width/2.0), (bounds.size.height/2.0));
	CGFloat distance =  sqrtf(powf( (pt.x-center.x) , 2.0) + powf( (pt.y-center.y) , 2.0));
	//	NSLog(@"distance=%f",distance);
	CGFloat angle = asinf( (pt.y-center.y)/distance);
	if(pt.x-center.x < 0)angle= M_PI-angle;
	if (angle<0)angle+=2*M_PI;
	//	NSLog(@"angle=%f",angle);
	//angle start from 0 to 2*M_PI
	//first slot start at angle 0	
	//identify slot
	int slot = @(angle/(M_PI/4)).intValue;
	return slot;
}
-(uint)identifyRingForPoint:(CGPoint)pt{
	
	CGRect bounds = self.bounds;
	CGPoint center = CGPointMake((bounds.size.width/2.0), (bounds.size.height/2.0));
	CGFloat distance =  sqrtf(powf( (pt.x-center.x) , 2.0) + powf( (pt.y-center.y) , 2.0));
	//identify ring
	CGFloat radius=self.frame.size.width/2;
	int r;
	for (r=0; r<4; r++) {
		CGFloat rad = radius * ([[radiusSet objectAtIndex:r] floatValue]);
		if (distance<rad)break;
	}
	return  r;
}

/** To make this view interactive with only touch inside disk not outside
*/
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
	CGRect bounds = self.bounds;
	CGPoint center = CGPointMake((bounds.size.width/2.0), (bounds.size.height/2.0));
	CGPoint pt = point;
	CGFloat distance =  sqrtf(powf( (pt.x-center.x) , 2.0) + powf( (pt.y-center.y) , 2.0));
	CGFloat radius=self.frame.size.width/2;
	if (distance<radius) {
		return TRUE;
	}
	return FALSE;
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
//    NSLog(@"pt=%f,%f",pt.x,pt.y);
	currentSlot=[self identifySlotForPoint:pt];
	currentRing=[self identifyRingForPoint:pt];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	CGPoint pt = [[touches anyObject] locationInView:self];
	int slot=[self identifySlotForPoint:pt];
	int ring=[self identifyRingForPoint:pt];
	if (slot==currentSlot || ring==currentRing) {
		NSLog(@"ring=%d,slot=%d",ring,slot);
		//rare: ring could be = 4 (mean user touch the part that not inside disk)
		if (ring<4) {
			[self.delegate userWantToMakeMoveAtRing:ring Slot:slot sender:self];
		}
	}else{
		NSLog(@"Don't move outside of first touch slot!");
	}
	
}



@end
