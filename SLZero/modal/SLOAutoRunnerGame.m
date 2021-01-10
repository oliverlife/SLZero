//
//  SLOAutoRunnerGame.m
//  SLZero
//
//  Created by 李智 on 2021/1/6.
//  Copyright © 2021 李智. All rights reserved.
//

#import "SLOAutoRunnerGame.h"

@interface SLOAutoRunnerGame()

@property(nonatomic, strong)SLOAutoRunner *runner;
@property(nonatomic, strong)SLOGame *game;

@end

@implementation SLOAutoRunnerGame

- (id)initWithAutoRunner:(SLOAutoRunner *)runner withGame:(SLOGame *)game {
    if (self = [super init]) {
        _runner = runner;
        _game = game;
    }
    
    return self;
}

- (void)run {
    [self.runner addAutoRunnerObserver:self];
    [self.game addGameObserver:self.runner];
    [self.game addGameObserver:self];
    
    [self openNextCellIndex];
}

- (void) openNextCellIndex {
    if(![self.game isWin]) {
        [self.runner next];
    }
}

- (void)nextOpenCell:(SLOGameCellIndex *)cell withRunner:(SLOAutoRunner *)runner {
    [self.game openCellWithCellIndex:cell];
}

- (void)updateCellsOpenedStatus:(NSArray *)cells withGame:(SLOGame *)game {
    [self openNextCellIndex];
}

@end
