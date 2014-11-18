//
//  MenuAlert.m
//  shooter
//
//  Created by Julien Sagot on 18/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "MenuAlert.h"

@implementation MenuAlert
@end

@implementation MainMenuAlert

-(instancetype)init
{
    self = [super init] ;
    self.messageText = @"ARROW SHOOTER -  Main menu" ;
    self.informativeText = @"Are you leaving, coward?";
    [self addButtonWithTitle:@"New game (N)" ] ; // 1000
    [[[self buttons] objectAtIndex:0] setKeyEquivalent:@"n"] ;
    [self addButtonWithTitle:@"Quit (Q)" ] ;     // 1001
    [[[self buttons] objectAtIndex:1] setKeyEquivalent:@"q"] ;
    return self ;
}
@end

@implementation PausedMenuAlert
-(instancetype)init
{
    self = [super init] ;
    self.messageText = @"ARROW SHOOTER - Paused" ;
    self.informativeText = @"Seems like you are afraid of the ghost...";
    [self addButtonWithTitle:@"New game (N)" ] ;      // 1000
    [[[self buttons] objectAtIndex:0] setKeyEquivalent:@"n"] ;
    [self addButtonWithTitle:@"Main menu (Q)" ] ;     // 1001
    [[[self buttons] objectAtIndex:1] setKeyEquivalent:@"q"] ;
    [self addButtonWithTitle:@"Resume (ESC)"] ;       // 1002
    [[[self buttons] objectAtIndex:2] setKeyEquivalent:@"\33"] ;
    return self ;
}
@end