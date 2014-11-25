//
//  Collidable.h
//  shooter
//
//  Created by Julien Sagot on 25/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

enum category {
    OUT_OF_BOUNDS = 0x1 << 1,
    ENEMY         = 0x1 << 2,
    HERO          = 0x1 << 3,
    GROUND        = 0x1 << 4,
    WALL          = 0x1 << 5,
    TRAP          = 0x1 << 6,
    ARROW         = 0x1 << 7,
    FIREBALL      = 0x1 << 8,
    POWERUP       = 0x1 << 9,
    SIGHT         = 0x1 << 10
};

@protocol Collidable <NSObject>
-(void) didBeginContactWithBody :(SKNode <Collidable> *)b ;
-(void) didEndContactWithBody :(SKNode <Collidable> *)b ;
@end
