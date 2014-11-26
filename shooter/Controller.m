//
//  Controller.m
//  shooter
//
//  Created by Julien Sagot on 25/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "Controller.h"
#import "Weapon.h"

@interface CharacterController ()
@property int keyPressed ;
@end

@implementation CharacterController

-(instancetype) initWithCharacter:(Character *)character
{
    self = [super init] ;
    self.character = character ;
    return self ;
}

-(void) setVelocity:(float)dx :(float)dy
{
    self.character.physicsBody.velocity = CGVectorMake(dx, dy) ;
}

-(void) setVelocityDY:(float) dy
{
    [self setVelocity :self.character.physicsBody.velocity.dx :dy] ;
}

-(void) setVelocityDX:(float) dx
{
    [self setVelocity :dx :self.character.physicsBody.velocity.dy] ;
}

-(void)keyDown:(int)keyCode
{
    switch (keyCode)
    {
        case 0:  // A
            if (self.keyPressed & LEFT) return ;
            self.keyPressed |= LEFT ;
            break ;
        case 2:  // D
            if (self.keyPressed & RIGHT) return ;
            self.keyPressed |= RIGHT ;
            break ;
        case 13: // W
            if (self.keyPressed & UP) return ;
            self.keyPressed |= UP ;
            break ;
    }
    [self onKeyDown:keyCode] ;
}

-(void)keyUp:(int) keyCode
{
    switch (keyCode)
    {
        case 0:  // A
            self.keyPressed &= ~LEFT ;
            break ;
        case 2: // D
            self.keyPressed &= ~RIGHT ;
            break ;
        case 13: // W
            self.keyPressed &= ~UP ;
            break ;
    }
    [self onKeyUp:keyCode] ;
}

@end

@implementation HumanController

-(void)onKeyDown:(int)keyCode
{
    switch (keyCode)
    {
        case 0:  // A
            [self setVelocityDX: -self.character.maxSpeed] ;
            break ;
        case 2:  // D
            [self setVelocityDX :self.character.maxSpeed] ;
            break ;
        case 13: // W
            if (self.character.contact != 0)
            {
                self.character.physicsBody.velocity = CGVectorMake(self.character.physicsBody.velocity.dx, 0) ;
                [self.character.physicsBody applyImpulse:CGVectorMake(0, 150)] ;
            }
            break ;
    }
}

-(void)onKeyUp:(int) keyCode
{
    switch (keyCode)
    {
        case 0:  // A
            [self setVelocityDX: (self.keyPressed & RIGHT ? self.character.maxSpeed : 0)] ;
            break ;
        case 2: // D
            [self setVelocityDX: (self.keyPressed & LEFT ? -self.character.maxSpeed : 0)] ;
            break ;
    }
}
@end

@implementation GhostController

-(void)onKeyDown:(int)keyCode
{
    switch (keyCode)
    {
        case 0:  // A
            [self setVelocityDX: -self.character.maxSpeed] ;
            break ;
        case 2:  // D
            [self setVelocityDX :self.character.maxSpeed] ;
            break ;
        case 13: // W
            [self setVelocityDY:self.character.maxSpeed] ;
            break ;
        case 1: // S
            [self setVelocityDY:-self.character.maxSpeed] ;
            break ;
    }
}

-(void)onKeyUp:(int) keyCode
{
    switch (keyCode)
    {
        case 0:  // A
            [self setVelocityDX: (self.keyPressed & RIGHT ? self.character.maxSpeed : 0)] ;
            break ;
        case 2: // D
            [self setVelocityDX: (self.keyPressed & LEFT ? -self.character.maxSpeed : 0)] ;
            break ;
        case 13: // W
            [self setVelocityDY: (self.keyPressed & DOWN ? -self.character.maxSpeed : 0)] ;
            break ;
        case 1: // S
            [self setVelocityDY: (self.keyPressed & UP ? self.character.maxSpeed : 0)] ;
            break ;
    }
}
@end

@implementation WeaponController
-(instancetype) initWithWeapon:(Weapon *) weapon
{
    self = [super init] ;
    self.weapon = weapon ;
    return self ;
}
@end

@implementation BowController
-(void)mouseDown:(int)btnCode :(CGPoint)at
{
    [self.weapon charge] ;
}

-(void)mouseUp:(int)btnCode :(CGPoint)at
{
    [self.weapon fireToward:at] ;
}
@end