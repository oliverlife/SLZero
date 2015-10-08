//
//  SLOGameFormula.h
//  SLZero
//
//  Created by 李智 on 15/9/28.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLOGame.h"

@interface SLOGameFormula : NSObject<NSCopying>

@property(nonatomic, strong, readonly)NSArray *cellIndexArr;
@property(readonly) NSInteger mineNumberL;
@property(readonly) NSInteger mineNumberR;
@property(readonly) NSMutableArray *parentFormulaArr;

- (id)initWithCellIndexArr:(NSArray *)cellIndexArr mineNumber:(NSInteger)mineNumber;
//- (id)initWithCellIndexArr:(NSArray *)cellIndexArr mineNumberL:(NSInteger)mineNumberL mineNumberR:(NSInteger)mineNumberR;
- (id)initWithCellIndexArr:(NSArray *)cellIndexArr mineNumberL:(NSInteger)mineNumberL mineNumberR:(NSInteger)mineNumberR parentFormula:(NSArray *)formulaArr;
- (SLOGameFormula *)factoring:(SLOGameFormula *)otherFormula;
- (BOOL)reduceScope:(SLOGameFormula *)otherFormula;
- (BOOL)isCommon:(id)object;

@end
