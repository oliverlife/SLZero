//
//  SLOAutoRun.m
//  SLZero
//
//  Created by 李智 on 15/9/29.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "SLOAutoRun.h"
#import "SLOGameFormula.h"
#import "SLOFormulaSet.h"

@interface SLOAutoRun()

@property(nonatomic, weak)SLOGame *game;
@property(nonatomic, strong)SLOFormulaSet *formulaSet;

@end

@implementation SLOAutoRun

- (id)initWithSLOGame:(SLOGame *)game
{
    if(!game || game.isLost || game.isWin)
        return nil;
    
    if(self = [super init])
    {
        _game = game;
    }
    return self;
}

- (SLOFormulaSet *)formulaSet
{
    if(!_formulaSet)
        _formulaSet = [[SLOFormulaSet alloc] initWithGame:self.game];
    
    return _formulaSet;
}

- (void)clearFormulaSet
{
    self.formulaSet = nil;
}

- (SLOGameCellIndex *)nextEmptyCell
{
    for(SLOGameFormula *formula in self.formulaSet.coreFormulaSet)
    {
        if([formula.cellIndexArr count] == 1 && formula.mineNumberL == 0 && formula.mineNumberR == 1 && ![self.game getCellWithCellIndex:formula.cellIndexArr[0]].isOpened)
        {
            return formula.cellIndexArr[0];
        }
    }
    return nil;
}

- (void)updateFormulaSetWithCellIndexArr:(NSArray *)cellIndexArr
{
    [self.formulaSet updateFormulaSetWithCellIndexArr:cellIndexArr];
}

- (void)updateFormulaSet
{
    const NSUInteger newFormulaArrCount = 3;
    NSArray *newFormulaArr[newFormulaArrCount] = {nil, nil, nil};
    BOOL isChanged = NO;
    NSRange range1 = NSMakeRange(0, 0);
    NSRange range2 = NSMakeRange(0, self.formulaSet.coreFormulaSet.count);
    while(range2.length > 0)
    {
        newFormulaArr[0] = [self findNewSingleFormulaWithRange:range1 withOtherRange:range2];
        newFormulaArr[1] = [self findNewSingleFormulaWithRange:range2 withOtherRange:range1];
        newFormulaArr[2] = [self findNewSingleFormulaWithRange:range2 withOtherRange:range2];
        
        for(NSUInteger i = 0;i < newFormulaArrCount;++i)
        {
            for(SLOGameFormula *formula in newFormulaArr[i])
                isChanged = [self.formulaSet addObject:formula] || isChanged;
        }
        
        range1 = NSMakeRange(0, range2.location + range2.length);
        range2 = NSMakeRange(range1.length, self.formulaSet.coreFormulaSet.count - range1.length);
    }
    NSLog(@"count = %lu", [self.formulaSet.coreFormulaSet count]);
}

- (NSArray *)findNewSingleFormulaWithRange:(NSRange)range withOtherRange:(NSRange)otherRange
{
    NSMutableArray *newFormulaArr = [NSMutableArray array];
    for(NSUInteger i = range.location;i < range.location + range.length;++i)
    {
        SLOGameFormula *formula1 = self.formulaSet.coreFormulaSet[i];
        if([formula1.cellIndexArr count] > 1)
        {
            for(NSUInteger j = otherRange.location;j < otherRange.location + otherRange.length;++j)
            {
                SLOGameFormula *formula2 = self.formulaSet.coreFormulaSet[j];
                if(formula1 != formula2)
                {
                    SLOGameFormula * newFormula = [formula1 factoring:formula2];
                    if(newFormula)
                        [newFormulaArr addObject:newFormula];
                }
            }
        }
    }
    return newFormulaArr;
}

- (NSArray *)findNewSingleFormula
{
    NSMutableArray *newFormulaArr = [NSMutableArray array];
    //NSLog(@"%lu",[self.formulaSet.coreFormulaSet count]);
    for(int i = 0;i < [self.formulaSet.coreFormulaSet count];++i)
    {
        SLOGameFormula *formula1 = self.formulaSet.coreFormulaSet[i];
        if([formula1.cellIndexArr count] > 1)
        {
            for(int j = 0;j < [self.formulaSet.coreFormulaSet count];++j)
            {
                SLOGameFormula *formula2 = self.formulaSet.coreFormulaSet[j];
                if(formula1 != formula2)
                {
                    SLOGameFormula * newFormula = [formula1 factoring:formula2];
                    if(newFormula)
                       [newFormulaArr addObject:newFormula];
                }
            }
        }
    }
    return newFormulaArr;
}

- (SLOGameCellIndex *)next
{
    SLOGameCellIndex *returnValue = nil;
    if(self.game.isLost || self.game.isWin)
        return returnValue;
    
    returnValue = [self nextEmptyCell];
    if(!returnValue)
    {
        //[self updateFormulaSet];
        //returnValue = [self nextEmptyCell];
        //if(!returnValue)
        //{
            //[self clearFormulaSet];
            //returnValue = [self nextEmptyCell];
            //if(!returnValue)
            {
                [self updateFormulaSet];
                returnValue = [self nextEmptyCell];
            }
        //}
    }
    return returnValue;
}

@end
