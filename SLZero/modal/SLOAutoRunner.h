//
//  SLOAutoRun.h
//  SLZero
//
//  Created by 李智 on 15/9/29.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLOGame.h"

@class SLOAutoRunner;

@protocol SLOAutoRunnerObserver <NSObject>
- (void)nextOpenCell: (SLOGameCellIndex *) cell withRunner: (SLOAutoRunner *)runner;
@end

@interface SLOAutoRunner : NSObject<SLOGameObserver>

- (id)initWithSLOGame:(SLOGame *)game;
- (void)clearFormulaSet;
- (void)next;
- (void)updateFormulaSetWithCellIndexArr:(NSArray *)cellIndexArr;

- (void)addAutoRunnerObserver:(id<SLOAutoRunnerObserver>) observer;
- (void)removeAutoRunnerObserver:(id<SLOAutoRunnerObserver>) observer;

@end
