//
//  Spread.m
//  Spread
//
//  Created by Kevin Wojniak on 3/12/10.
//

#import "Spread.h"
#import "Branch.h"


#define START_RADIUS		20.0
#define STRAIGHTEN_FACTOR	0.95
#define CURVINESS			0.2
#define BRANCH_SHRINK		0.95
#define BRANCH_OPACITY		0.4
#define COLOR_SPEED			0.03
#define NEW_TREE_FREQ		2.0


CGFloat RandomFloat()
{
	return (random() / (CGFloat)RAND_MAX);
}

NSUInteger RandomUInteger(NSUInteger min, NSUInteger max)
{
	return min + (random() % ((max - min) + 1));
}

CGFloat DegreesToRadians(CGFloat degrees)
{
	return ((CGFloat)((degrees) * M_PI / 180.0));
}


@implementation Spread

+ (void)initialize
{
	srandomdev();
}

- (id)initWithSize:(CGSize)size
{
	if (self = [super init])
	{
		boundsSize = size;
		newBranchFrames = 60;
		colorSpace = CGColorSpaceCreateDeviceRGB();
		branches = [[NSMutableArray alloc] init];
	}
	
	return self;
}	

- (void)dealloc
{
	[branches release];
	CGColorSpaceRelease(colorSpace);
	[super dealloc];
}

- (void)createTree:(NSPoint)location
{
	NSUInteger numberOfBranches = RandomUInteger(3, 6);
	CGFloat angle = 0.0;
	CGFloat angleIncr = 360.0 / numberOfBranches;
	for (NSUInteger i=0; i<numberOfBranches; i++)
	{
		[branches addObject:[Branch branchWithLocation:location direction:DegreesToRadians(angle) radius:START_RADIUS]];
		angle += angleIncr;
	}
}

- (void)drawInContext:(CGContextRef)ctx
{
	if (!layer)
	{
		layer = CGLayerCreateWithContext(ctx, boundsSize, NULL);	
		CGContextRef ctx = CGLayerGetContext(layer);
		CGContextSetFillColorWithColor(ctx, CGColorGetConstantColor(kCGColorBlack));
		CGContextFillRect(ctx, CGRectMake(0, 0, boundsSize.width, boundsSize.height));
	}
	
	CGContextDrawLayerAtPoint(ctx, CGPointZero, layer);
}	

- (void)animateOneFrame
{
	frameNum++;
	
	CFAbsoluteTime now = CFAbsoluteTimeGetCurrent();
	if ((now - lastTreeCreated) >= NEW_TREE_FREQ)
	{
		CGSize size = CGLayerGetSize(layer);
		NSPoint location;
		location.x = (RandomFloat() + 0.1) * size.width * 0.8;
		location.y = (RandomFloat() + 0.1) * size.height * 0.8;
		[self createTree:location];
		lastTreeCreated = now;
	}
	
	CGContextRef ctx = CGLayerGetContext(layer);
	CGContextSetStrokeColorSpace(ctx, colorSpace);
	
	CGFloat comps[4];
	comps[0] = (sin(frameNum * COLOR_SPEED) + 1.0) / 2.0;
	comps[1] = (sin(frameNum * COLOR_SPEED + M_PI * 2 / 3) + 1.0) / 2.0;
	comps[2] = (sin(frameNum * COLOR_SPEED + M_PI * 4 / 3) + 1.0) / 2.0;
	comps[3] = BRANCH_OPACITY;
	CGContextSetStrokeColor(ctx, comps);
	
	directionOffset += RandomFloat() * CURVINESS - CURVINESS / 2;
	directionOffset *= STRAIGHTEN_FACTOR;
	
	for (NSInteger i = [branches count] - 1; i >= 0; i--)
	{
		Branch *branch = [branches objectAtIndex:i];
		
		CGContextBeginPath(ctx);
		CGContextSetLineWidth(ctx, branch.radius);
		CGContextMoveToPoint(ctx, branch.location.x, branch.location.y);
		
		branch.radius *= BRANCH_SHRINK;
		branch.direction += directionOffset;
		NSPoint location = branch.location;
		location.x += cos(branch.direction) * branch.radius;
		location.y += sin(branch.direction) * branch.radius;
		branch.location = location;
		
		CGContextAddLineToPoint(ctx, branch.location.x, branch.location.y);
		CGContextStrokePath(ctx);
		
		if (branch.radius < branch.originalRadius / 2) {
			[[branch retain] autorelease]; // removeObjectAtIndex: will cause branch to deallocate, so retain/autorelease
			[branches removeObjectAtIndex:i];
			CGFloat newRadius = branch.originalRadius / 2;
			if (newRadius > 1) {
				[branches addObject:[Branch branchWithLocation:branch.location direction:branch.direction radius:newRadius]];
				[branches addObject:[Branch branchWithLocation:branch.location direction:branch.direction + 1 radius:newRadius]];
			}
		}
	}
}

@end
