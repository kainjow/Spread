//
//  Branch.m
//  Spread
//
//  Created by Kevin Wojniak on 3/5/10.
//

#import "Branch.h"


@implementation Branch

@synthesize location, direction, radius, originalRadius;

+ (Branch *)branchWithLocation:(NSPoint)location direction:(CGFloat)direction radius:(CGFloat)radius
{
	Branch *branch = [[[Branch alloc] init] autorelease];
	branch.location = location;
	branch.direction = direction;
	branch.radius = radius;
	branch.originalRadius = radius;
	return branch;
}

@end
