//
//  SpreadView.m
//  Spread
//
//  Created by Kevin Wojniak on 3/12/10.
//

#import "SpreadView.h"
#import "Spread.h"


@implementation SpreadView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
	if (self = [super initWithFrame:frame isPreview:isPreview])
	{
		[self setAnimationTimeInterval:1/30.0];
		spread = [[Spread alloc] initWithSize:NSSizeToCGSize(frame.size)];
	}
	
	return self;
}

- (void)dealloc
{
	[spread release];
	[super dealloc];
}

- (void)drawRect:(NSRect)rect
{
	[spread drawInContext:(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort]];
}

- (void)animateOneFrame
{
	[spread	animateOneFrame];
	[self setNeedsDisplay:YES];
}

@end
