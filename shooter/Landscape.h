//
//  Landscape.h
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Character.h"

@interface Landscape : SKSpriteNode
@end

@interface Ground : Landscape
-(instancetype)initWithWidth:(float)width ;
@end

@interface Wall : Landscape
-(instancetype)initWithHeight:(float)height ;
@end

@interface Trap : Landscape
@property float damage ;
-(instancetype) initWithSize:(CGSize)size ;
-(void)hitCharacter:(Character *)c ;
-(void) activate ;
-(void) deactivate ;
@end

