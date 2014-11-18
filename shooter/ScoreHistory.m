//
//  ScoreHistory.m
//  shooter
//
//  Created by Julien Sagot on 18/11/14.
//  Copyright (c) 2014 ju. All rights reserved.
//

#import "ScoreHistory.h"

@implementation ScoreHistory

- (instancetype)init
{
    self = [super init];
    self.scoreDir = [NSString stringWithFormat:@"%@/%@",
               [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                    NSUserDomainMask,
                                                    YES)
                firstObject],
               @"arrow-shooter"];
    
    self.scoreFile = [NSString stringWithFormat:@"%@/%@",
                            self.scoreDir,
                            @"arrow-shooter.score"] ;
    return self;
}

-(void)saveScore:(NSDate *)date :(float)time :(float)health
{
    
    NSString * record = [NSString stringWithFormat:@"%@ | %d seconds (%d health points).\n",
                         [[date description] substringToIndex:18],
                         (int)time,
                         (int)health] ;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:self.scoreDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil] ;
    
    NSFileHandle * f = [NSFileHandle fileHandleForWritingAtPath:self.scoreFile];
    
    if(f == nil) {
        
        [[NSFileManager defaultManager] createFileAtPath:self.scoreFile contents:nil attributes:nil];
        f = [NSFileHandle fileHandleForWritingAtPath:self.scoreFile];
    }
    
    [f seekToEndOfFile];
    [f writeData:[record dataUsingEncoding:NSUTF8StringEncoding]];
    [f closeFile];
    
}

@end
