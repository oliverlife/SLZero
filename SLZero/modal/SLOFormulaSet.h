//
//  SLOFormulaSet.h
//  SLZero
//
//  Created by 李智 on 15/9/29.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLOGame.h"
#import "SLOGameFormula.h"

@interface SLOFormulaSet : NSObject

@property(nonatomic, strong, readonly)NSArray *coreFormulaSet;
- (id)initWithGame:(SLOGame *)game;
- (void)updateFormulaSetWithCellIndexArr:(NSArray *)cellIndexArr;
- (BOOL)addObject:(SLOGameFormula *)anFormula;

@end
