//
//  Weapon.m
//  shooter
//
//  Created by Julien Sagot on 25/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "Weapon.h"
#import "CGVectorAdditions.h"

@interface Weapon ()
-(void) throwProjectile:(Projectile *)projectile withForce:(float)force toward:(CGPoint)point ;
@end

@implementation Weapon

-(void)throwProjectile:(Projectile *)projectile withForce:(float)force toward:(CGPoint)point
{
    CGVector v = CGVectorMake(point.x - self.position.x, point.y - self.position.y) ;
    v = CGVectorMultiplyByScalar(CGVectorNormalize(v), force) ;
    [projectile fire:self.position :v] ;
    [self.parent addChild:projectile] ;
}
@end

@implementation Bow

-(void)charge
{
    self.chargeStart = [NSDate date] ;
}

-(void)fireToward:(CGPoint)point
{
    float charge = fmin(3, 1 + 2 * fabsf([self.chargeStart timeIntervalSinceNow])) ;
    [super throwProjectile:[[Arrow alloc] init] withForce:(500 * charge) toward:point] ;
}

@end

@implementation FireBallLauncher
-(void)fireToward:(CGPoint)point
{
    [super throwProjectile:[[FireBall alloc] init] withForce:750 toward:point] ;
}
@end