//
//  SLOAutoRun.h
//  SLZero
//
//  Created by 李智 on 15/9/29.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLOGame.h"

@protocol SLOAutoRunObserver <NSObject>
- (void)nextOpenCell: (SLOGameCellIndex *) cell withGame: (SLOGame *)game;
@end

@interface SLOAutoRun : NSObject<SLOGameObserver>

- (id)initWithSLOGame:(SLOGame *)game;
- (void)clearFormulaSet;
- (SLOGameCellIndex *)next;
- (void)updateFormulaSetWithCellIndexArr:(NSArray *)cellIndexArr;

- (void)addObserver:(id<SLOAutoRunObserver>) observer;
- (void)removeObserver:(id<SLOAutoRunObserver>) observer;

@end
