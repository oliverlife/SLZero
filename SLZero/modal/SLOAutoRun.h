//
//  SLOAutoRun.h
//  SLZero
//
//  Created by 李智 on 15/9/29.
//  Copyright © 2015年 李智. All rights reserved.
//

//公式集缩减
//时间显示
//自动游戏
//旧公式更新

#import <Foundation/Foundation.h>
#import "SLOGame.h"

@interface SLOAutoRun : NSObject

- (id)initWithSLOGame:(SLOGame *)game;
- (void)clearFormulaSet;
- (SLOGameCellIndex *)next;
- (void)updateFormulaSetWithCellIndexArr:(NSArray *)cellIndexArr;

@end
