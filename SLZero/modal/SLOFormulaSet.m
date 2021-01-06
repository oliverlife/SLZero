//
//  SLOFormulaSet.m
//  SLZero
//
//  Created by 李智 on 15/9/29.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "SLOFormulaSet.h"
#import "../OLog.h"

@interface SLOFormulaSet()

@property(nonatomic, weak)SLOGame *game;
@property(nonatomic, strong)NSMutableArray *coreFormulaSet;

@end

@implementation SLOFormulaSet

- (id)initWithGame:(SLOGame *)game
{
    if(self = [super init])
        _game = game;
    
    return self;
}

- (id)coreFormulaSet
{
    if(!_coreFormulaSet)
    {
        _coreFormulaSet = [NSMutableArray array];
        [self resetFormulaSet];
    }
    
    return _coreFormulaSet;
}

- (void)resetFormulaSet
{
    //[self addBasicFormulaSet];
    [OLog pushLog:@"resetFormulaSet"];
    for(SLOGameCellIndex * cellIndex in [self.game allCellIndex])
    {
        if([self.game getCellWithCellIndex:cellIndex].isOpened)
        {
            [self updateFormulaSetWithCellIndex:cellIndex];
            [self updateFormulaSetWithCellIndexArr:[self.game aroundCellIndex:cellIndex]];
        }
    }
    [OLog popLog];
}

- (void)addBasicFormulaSet
{
    NSArray *allCellIndexArr = [self.game allCellIndex];
    SLOGameFormula *totalFormula = [[SLOGameFormula alloc] initWithCellIndexArr:allCellIndexArr mineNumber:self.game.mineNumber];
    //[self addObject:totalFormula];
}

- (void)updateFormulaSetWithCellIndexArr:(NSArray *)cellIndexArr
{
    for(SLOGameCellIndex *cellIndex in cellIndexArr)
        [self updateFormulaSetWithCellIndex:cellIndex];
}

- (void)updateFormulaSetWithCellIndex:(SLOGameCellIndex *)cellIndex
{
    SLOCell *cell = [self.game getCellWithCellIndex:cellIndex];
    if(!cell)
        return ;
    
    if(cell.isOpened)
    {
        NSInteger cellNumber = [[cell getState] intValue];
        if(cellNumber >= 0)
        {
            SLOGameFormula *formula1 = [[SLOGameFormula alloc] initWithCellIndexArr:[NSArray arrayWithObject:cellIndex] mineNumber:0];
            [self addObject:formula1];
            if(cellNumber > 0)
            {
                NSArray *aroundCellIndexArr = [self.game aroundCellIndex:cellIndex];
                NSMutableArray *nonOpenedAroundCellIndexArr = [NSMutableArray array];
                for(SLOGameCellIndex *cellIndex2 in aroundCellIndexArr)
                {
                    SLOCell *cell = [self.game getCellWithCellIndex:cellIndex2];
                    if(cell && !cell.isOpened)
                    {
                        [nonOpenedAroundCellIndexArr addObject:cellIndex2];
                    }
                }
                SLOGameFormula *formula2 = [[SLOGameFormula alloc] initWithCellIndexArr:nonOpenedAroundCellIndexArr mineNumber:cellNumber];
                [self addObject:formula2];
            }
        }
    }
    else
    {
        [self addObject:[[SLOGameFormula alloc] initWithCellIndexArr:[NSArray arrayWithObject:cellIndex] mineNumberL:0 mineNumberR:2 parentFormula:nil]];
    }
}

- (BOOL)addObject:(SLOGameFormula *)anFormula
{
    BOOL isChanged = NO;
    BOOL isExist = NO;
    for(SLOGameFormula *formula in self.coreFormulaSet)
    {
        if([formula reduceScope:anFormula])
        {
            isChanged = YES;
            isExist = YES;
        }
        else
        {
            isExist = [formula isCommon:anFormula];
        }
        if(isExist)
            break;
    }
    if(!isExist)
    {
        SLOGameFormula *newFormula = [[SLOGameFormula alloc] initWithCellIndexArr:anFormula.cellIndexArr mineNumberL:0 mineNumberR:[anFormula.cellIndexArr count] + 1 parentFormula:nil];
        [newFormula reduceScope:anFormula];
        [self addObjectToCoreFormulaSet:newFormula];
        isChanged = YES;
    }
    if(isChanged)
    {
        //for(SLOGameCellIndex *cellIndex in anFormula.cellIndexArr)
            //NSLog(@"%ld %ld",cellIndex.x, cellIndex.y);
        //NSLog(@"%ld %ld", anFormula.mineNumberL, anFormula.mineNumberR);
    }
    
    return isChanged;
}

- (void)addObjectToCoreFormulaSet:(SLOGameFormula *)anFormula {
    [_coreFormulaSet addObject:anFormula];
}

@end
