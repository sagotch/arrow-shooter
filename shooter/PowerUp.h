//
//  PowerUp.h
//  shooter
//
//  Created by Julien Sagot on 17/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Character.h"

@interface PowerUp : SKSpriteNode
-(instancetype)initWithSize:(CGSize)size ;
-(void)powerUpCharacter:(Character *)c;
@property NSString * soundPowerUp ;
@end


@interface HealthPack : PowerUp
-(instancetype)init ;
@end