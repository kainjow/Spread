//
//  Branch.h
//  Spread
//
//  Created by Kevin Wojniak on 3/5/10.
//

#import <Foundation/Foundation.h>


@interface Branch : NSObject
{
	NSPoint location;
	CGFloat direction;
	CGFloat radius;
	CGFloat originalRadius;
}

+ (Branch *)branchWithLocation:(NSPoint)location direction:(CGFloat)direction radius:(CGFloat)radius;

@property NSPoint location;
@property CGFloat direction;
@property CGFloat radius;
@property CGFloat originalRadius;

@end
