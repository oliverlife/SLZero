//
//  SLOGameFormula.m
//  SLZero
//
//  Created by 李智 on 15/9/28.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "SLOGameFormula.h"
@interface SLOGameFormula()

@property(nonatomic, strong)NSArray *cellIndexArr;
@property NSInteger mineNumberL;
@property NSInteger mineNumberR;
@property(readwrite) NSMutableArray *parentFormulaArr;

@end

@implementation SLOGameFormula

- (id)copyWithZone:(nullable NSZone *)zone
{
    return self;
}

- (id)initWithCellIndexArr:(NSArray *)cellIndexArr mineNumber:(NSInteger)mineNumber
{
    return [self initWithCellIndexArr:cellIndexArr mineNumberL:mineNumber mineNumberR:mineNumber + 1 parentFormula:nil];
}

- (NSString *)description
{
    NSString *dStr = @"";
    dStr = [dStr stringByAppendingFormat:@"################\n"];
    for(SLOGameCellIndex *cellIndex in self.cellIndexArr)
        dStr = [dStr stringByAppendingFormat:@"%ld %ld\n",cellIndex.x, cellIndex.y];
    
    dStr = [dStr stringByAppendingFormat:@"================\n"];
    dStr = [dStr stringByAppendingFormat:@"%ld %ld\n", self.mineNumberL, self.mineNumberR];
    
//    dStr = [dStr stringByAppendingFormat:@"cccccccccccccc\n"];
//    for(SLOGameFormula *p in self.parentFormulaArr)
//        dStr = [dStr stringByAppendingFormat:@"%@\n", p];
//    
//    dStr = [dStr stringByAppendingFormat:@"cccccccccccccc\n"];
    dStr = [dStr stringByAppendingFormat:@"!!!!!!!!!!!!!!!!"];
    
    return dStr;
}

- (id)initWithCellIndexArr:(NSArray *)cellIndexArr mineNumberL:(NSInteger)mineNumberL mineNumberR:(NSInteger)mineNumberR parentFormula:(NSArray *)formulaArr
{
    if(self = [self initWithCellIndexArr:cellIndexArr mineNumberL:mineNumberL mineNumberR:mineNumberR])
    _parentFormulaArr = [NSMutableArray arrayWithArray:formulaArr];
    if(!formulaArr)
        _parentFormulaArr = [NSMutableArray array];
    
    return self;
}

- (id)initWithCellIndexArr:(NSArray *)cellIndexArr mineNumberL:(NSInteger)mineNumberL mineNumberR:(NSInteger)mineNumberR
{
    if(self = [super init])
    {
        BOOL isAllCellIndexObject = YES;
        for(NSUInteger i = 0;isAllCellIndexObject && i < [cellIndexArr count];++i)
            isAllCellIndexObject = [cellIndexArr[i] isKindOfClass:[SLOGameCellIndex class]];
        
        if(!isAllCellIndexObject)
            return nil;
        
        self.cellIndexArr = [cellIndexArr sortedArrayUsingComparator:
                             ^(SLOGameCellIndex *cellIndex1, SLOGameCellIndex *cellIndex2)
                             {
                                 NSComparisonResult returnValue = NSOrderedDescending;
                                 if(cellIndex1.x < cellIndex2.x)
                                 {
                                     returnValue = NSOrderedAscending;
                                 }
                                 else if(cellIndex1.x == cellIndex2.x)
                                 {
                                     if(cellIndex1.y < cellIndex2.y)
                                         returnValue = NSOrderedAscending;
                                     else if(cellIndex1.y == cellIndex2.y)
                                         returnValue = NSOrderedSame;
                                 }
                                 
                                 return returnValue;
                             }];
        self.mineNumberL = mineNumberL;
        self.mineNumberR = mineNumberR;
    }
    
    return self;

}

- (SLOGameFormula *)factoring:(SLOGameFormula *)otherFormula
{
    SLOGameFormula *newFormula = nil;
    if([self isSubCellIndexArr:otherFormula])
    {
        NSArray *differentCellIndexArr = [self differentCellIndexArr:otherFormula];
        if([differentCellIndexArr count] > 0)
        {
            if(otherFormula.mineNumberR - otherFormula.mineNumberL == 1)
            {
                NSInteger newL = self.mineNumberL - otherFormula.mineNumberL;
                NSInteger newR = self.mineNumberR - otherFormula.mineNumberL;
                newFormula = [[SLOGameFormula alloc] initWithCellIndexArr:differentCellIndexArr mineNumberL:newL mineNumberR:newR parentFormula:@[self, otherFormula]];
            }
            else
            {
                if(self.mineNumberR - self.mineNumberL == 1)
                {
                    NSInteger newL = self.mineNumberL - otherFormula.mineNumberR + 1;
                    NSInteger newR = self.mineNumberL - otherFormula.mineNumberL + 1;
                    newFormula = [[SLOGameFormula alloc] initWithCellIndexArr:differentCellIndexArr mineNumberL:newL mineNumberR:newR parentFormula:@[self, otherFormula]];
                }
            }
            
        }
        else
            [self reduceScope:otherFormula];
    }
    return newFormula;
}

- (NSArray *)differentCellIndexArr:(SLOGameFormula *)otherFormula
{
    NSMutableArray *retainedArr = [NSMutableArray array];
    for(int i = 0;i < [self.cellIndexArr count];++i)
    {
        BOOL isSub = NO;
        for(int j = 0;(!isSub) && j < [otherFormula.cellIndexArr count];++j)
        {
            SLOGameCellIndex *cellIndex = self.cellIndexArr[i];
            SLOGameCellIndex *otherCellIndex = otherFormula.cellIndexArr[j];
            if(cellIndex.x == otherCellIndex.x && cellIndex.y == otherCellIndex.y)
                isSub = YES;
        }
        if(!isSub)
            [retainedArr addObject:self.cellIndexArr[i]];
    }
    return retainedArr;
}

- (BOOL)isSubCellIndexArr:(SLOGameFormula *)otherFormula
{
    BOOL isSub = [self.cellIndexArr count] >= [otherFormula.cellIndexArr count];
    for(int i = 0;isSub && i < [otherFormula.cellIndexArr count];++i)
    {
        isSub = NO;
        for(int j = 0;(!isSub) && j < [self.cellIndexArr count];++j)
        {
            SLOGameCellIndex *otherCellIndex = otherFormula.cellIndexArr[i];
            SLOGameCellIndex *cellIndex = self.cellIndexArr[j];
            if(cellIndex.x == otherCellIndex.x && cellIndex.y == otherCellIndex.y)
                isSub = YES;
        }
    }
    return isSub;
}

- (BOOL)isCommon:(id)object
{
    BOOL returnValue = NO;
    if([object isKindOfClass:[SLOGameFormula class]])
    {
        SLOGameFormula *otherFormula = object;
        returnValue = [self.cellIndexArr count] == [otherFormula.cellIndexArr count]
        && [self isSubCellIndexArr:otherFormula];
    }
    
    return returnValue;
}

- (BOOL)isEqual:(id)object
{
    BOOL returnValue = NO;
    if([object isKindOfClass:[SLOGameFormula class]])
    {
        SLOGameFormula *otherFormula = object;
        returnValue = [self isCommon:otherFormula]
                        && self.mineNumberL == otherFormula.mineNumberL
                        && self.mineNumberR == otherFormula.mineNumberR;
    }
    
    return returnValue;
}

- (BOOL)reduceScope:(SLOGameFormula *)otherFormula
{
    BOOL isReducedScope = NO;
    if([self isCommon:otherFormula])
    {
        NSInteger l = self.mineNumberL;
        NSInteger r = self.mineNumberR;
        NSInteger otherL = otherFormula.mineNumberL;
        NSInteger otherR = otherFormula.mineNumberR;
        if(l < otherL || r > otherR)
        {
            isReducedScope = YES;
            NSInteger newL = l > otherL?l:otherL;
            NSInteger newR = r < otherR?r:otherR;
            self.mineNumberL = newL;
            self.mineNumberR = newR;
            //[self.parentFormulaArr addObjectsFromArray:otherFormula.parentFormulaArr];
        }
    }
    return isReducedScope;
}

@end
