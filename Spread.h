//
//  Spread.h
//  Spread
//
//  Created by Kevin Wojniak on 3/12/10.
//

#import <Foundation/Foundation.h>


@interface Spread : NSObject
{
	CGSize boundsSize;
	NSMutableArray *branches;
	NSUInteger frameNum;
	CGLayerRef layer;
	CGFloat directionOffset;
	NSInteger newBranchFrames;
	CGColorSpaceRef colorSpace;
	CFAbsoluteTime lastTreeCreated;	
}

- (id)initWithSize:(CGSize)size;
- (void)drawInContext:(CGContextRef)ctx;
- (void)animateOneFrame;

@end
