//
//  Collidable.h
//  shooter
//
//  Created by Julien Sagot on 25/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

/**
 * The idea behind this interface is that every class will handle
 * the collision it is interested in.
 * Objects need to set their physicsBody's contactTestBitmask
 * to detect collision with a set of categories, and provide
 * didBeginContactWithBody and didEndContactWithBody methods
 * to handle this collision.
 */

#import <SpriteKit/SpriteKit.h>

enum category {
    OUT_OF_BOUNDS = 0x1,

    ENEMY         = 0x1 << 1,
    ALLY          = 0x1 << 2,
    NEUTRAL       = 0x1 << 3,

    LANDSCAPE     = 0x1 << 4,
    
    TRAP          = 0x1 << 5,
    
    SOLID         = 0x1 << 6,
    MAGICAL       = 0x1 << 7
    
};

@protocol Collidable <NSObject>
-(void) didBeginContactWithBody :(SKNode <Collidable> *)b ;
-(void) didEndContactWithBody :(SKNode <Collidable> *)b ;
@end
