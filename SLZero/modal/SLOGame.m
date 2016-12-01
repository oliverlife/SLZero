//
//  SLOGame.m
//  SLZero
//
//  Created by 李智 on 15/9/14.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "SLOGame.h"
#define MineFlag @(1)
#define NonMineFlag @(0)

@interface SLOGame()

@property(nonatomic, strong)NSMutableArray * cellArr;
@property(nonatomic, assign)BOOL isLost;
@property(nonatomic, assign)BOOL isWin;
@property(nonatomic, strong, readwrite)NSArray* randomMineArr;

@end

@implementation SLOGame

- (NSMutableArray *)cellArr
{
    if(!_cellArr)
        [self constructCellArr];
    
    return _cellArr;
}

- (NSArray *)randomMineArr
{
    if(!_randomMineArr)
        _randomMineArr = [self randomMine:self.size mineNumber:self.mineNumber];
        
    return _randomMineArr;
}

- (NSArray *)aroundCellIndex:(SLOGameCellIndex *)cellIndex
{
    static const int aroundCellNumber = 8;
    static int offsetxy[8][2] = {{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}};
    NSMutableArray * aroundCellIndexArr = [NSMutableArray array];
    for(int i = 0;i < aroundCellNumber;++i)
    {
        SLOGameCellIndex *newCellIndex = [[SLOGameCellIndex alloc] initWithIndexX:cellIndex.x + offsetxy[i][0] indexY:cellIndex.y + offsetxy[i][1]];
        [aroundCellIndexArr addObject:newCellIndex];
    }
    return aroundCellIndexArr;
}

- (void)constructCellArr
{
    _cellArr = [[NSMutableArray alloc] initWithCapacity:self.height * self.width];
    NSArray *randomMineArr = self.randomMineArr;
    for(NSInteger yIndex = 0;yIndex < self.height;++yIndex)
    {
        for(NSInteger xIndex = 0;xIndex < self.width;++xIndex)
        {
            SLOGameCellIndex *cellIndex = [self translateCellIndexWithXIndex:xIndex yIndex:yIndex];
            NSUInteger index = [self translateSingleIndexWithCellIndex:cellIndex];
            NSInteger aroundMineNumber = -1;
            if([randomMineArr[index] isEqualToNumber:NonMineFlag])
            {
                aroundMineNumber = 0;
                for(SLOGameCellIndex *aroundCellIndex in [self aroundCellIndex:cellIndex])
                {
                    if([self isValidIndexWithXIndex:aroundCellIndex.x yIndex:aroundCellIndex.y])
                        if([randomMineArr[[self translateSingleIndexWithCellIndex:aroundCellIndex]] isEqualToNumber:MineFlag])
                            ++aroundMineNumber;
                }
            }
            _cellArr[index] = [[SLOCell alloc] initWithNumber:aroundMineNumber];
        }
    }
    [self openCellWithXIndex:9 yIndex:7];
    [self openCellWithXIndex:8 yIndex:7];
//    [self openCellWithXIndex:27 yIndex:7];
//    [self openCellWithXIndex:21 yIndex:6];
//    [self openCellWithXIndex:13 yIndex:9];
//    [self openCellWithXIndex:15 yIndex:5];
//    [self openCellWithXIndex:18 yIndex:10];
//    [self openCellWithXIndex:23 yIndex:12];
//    [self openCellWithXIndex:9 yIndex:10];
//    [self openCellWithXIndex:7 yIndex:4];
//    [self openCellWithXIndex:0 yIndex:15];
//    [self openCellWithXIndex:0 yIndex:13];
//    [self openCellWithXIndex:1 yIndex:11];
//    [self openCellWithXIndex:2 yIndex:15];
//    [self openCellWithXIndex:0 yIndex:14];
}

- (NSArray *)randomMine:(NSUInteger)cellNumber mineNumber:(NSUInteger)mineNumber
{
    NSMutableArray * returnValue = nil;
    if(mineNumber <= cellNumber)
    {
        returnValue = [NSMutableArray arrayWithCapacity:cellNumber];
        for(NSUInteger index = 0;index < mineNumber;++index)
            returnValue[index] = MineFlag;

        for(NSUInteger index = mineNumber;index < cellNumber;++index)
            returnValue[index] = NonMineFlag;
        
        for(NSUInteger index1 = 0;index1 < cellNumber;++index1)
        {
            NSUInteger index2 = (arc4random() % (cellNumber - index1)) + index1;
            id t = returnValue[index1];
            returnValue[index1] = returnValue[index2];
            returnValue[index2] = t;
            
        }
        int temp[] = {
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
            1,
            0,
            1,
            1,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            1,
            0,
            0,
            1,
            1,
            0,
            0,
            1,
            1,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            1,
            0,
            1,
            0,
            1,
            0,
            0,
            0,
            1,
            1,
            0,
            0,
            0,
            0,
            1,
            1,
            0,
            1,
            0,
            1,
            0,
            0,
            1,
            1,
            0,
            0,
            0,
            0,
            0,
            1,
            1,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            1,
            1,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            0
        };
        for(NSUInteger index1 = 0;index1 < cellNumber;++index1)
        {
            returnValue[index1] = @(temp[index1]);
        }
    }
    return returnValue;
}

- (BOOL)isValidIndexWithCellIndex:(SLOGameCellIndex *)cellIndex
{
    return [self isValidIndexWithXIndex:cellIndex.x yIndex:cellIndex.y];
}

- (BOOL)isValidIndexWithXIndex:(NSInteger)xIndex yIndex:(NSInteger)yIndex
{
    BOOL returnValue = NO;
    if(xIndex >= 0 && xIndex < self.width && yIndex >= 0 && yIndex < self.height)
        returnValue = YES;
    
    return returnValue;
}

- (id)initWithWidth:(NSUInteger)width height:(NSUInteger)height mineNumber:(NSUInteger)mineNumber
{
    if(width * height > mineNumber)
    {
        if(self = [super init])
        {
            _width = width;
            _height = height;
            _mineNumber = mineNumber;
            _size = self.width * self.height;
            _isLost = NO;
            _isWin = NO;
        }
    }
    else
        return nil;
    return self;
}

- (NSArray *)openCellWithXIndex:(NSInteger)xIndex yIndex:(NSInteger)yIndex
{
    NSMutableArray *openedCellArr = [NSMutableArray array];
    SLOCell *cell = [self getCellWithXIndex:xIndex yIndex:yIndex];
    if(cell && ![cell isOpened])
    {
        [cell  setOpen];
        int mineNumber = [[cell getState] intValue];
        if(mineNumber < 0)
        {
            self.isLost = YES;
        }
        else if(mineNumber == 0)
        {
            SLOGameCellIndex *cellIndex = [self translateCellIndexWithXIndex:xIndex yIndex:yIndex];
            for(SLOGameCellIndex *aroundCellIndex in [self aroundCellIndex:cellIndex])
                [openedCellArr addObjectsFromArray:[self openCellWithXIndex:aroundCellIndex.x yIndex:aroundCellIndex.y]];
        }
    }
    if([cell isOpened])
        [openedCellArr addObject:[self translateCellIndexWithXIndex:xIndex yIndex:yIndex]];
    
    [self updateGameState];
    return openedCellArr;
}

- (void)updateGameState
{
    int openedCount = 0;
    for(int i = 0;i < self.size;++i)
    {
        SLOGameCellIndex *cellIndex = [self translateCellIndexWithSingleIndex:i];
        SLOCell *cell = [self getCellWithCellIndex:cellIndex];
        if(cell.isOpened)
            ++openedCount;
        
        if(self.size - openedCount == self.mineNumber)
            self.isWin = YES;
    }
}

- (NSArray *)openCellWithCellIndex:(SLOGameCellIndex *)cellIndex
{
    return [self openCellWithXIndex:cellIndex.x yIndex:cellIndex.y];
}


- (SLOCell *)getCellWithXIndex:(NSInteger)xIndex yIndex:(NSInteger)yIndex
{
    SLOCell *returnValue = nil;
    if([self isValidIndexWithXIndex:xIndex yIndex:yIndex])
        returnValue = self.cellArr[xIndex + yIndex * self.width];
    
    return returnValue;
}

- (SLOCell *)getCellWithCellIndex:(SLOGameCellIndex *) cellIndex
{
    return [self getCellWithXIndex:cellIndex.x yIndex:cellIndex.y];
}

- (SLOGameCellIndex *)translateCellIndexWithXIndex:(NSInteger)xIndex yIndex:(NSInteger)yIndex
{
    return [[SLOGameCellIndex alloc] initWithIndexX:xIndex indexY:yIndex];

}

- (SLOGameCellIndex *)translateCellIndexWithSingleIndex:(NSUInteger)index
{
    return [[SLOGameCellIndex alloc] initWithIndexX:index%self.width indexY:index/self.width];
}

- (NSUInteger)translateSingleIndexWithCellIndex:(SLOGameCellIndex *)cellIndex
{
    return cellIndex.y * self.width + cellIndex.x;
}

- (NSArray *)allCellIndex
{
    NSMutableArray *allCellIndexArr = [NSMutableArray array];
    for(int i = 0;i < self.size;++i)
        [allCellIndexArr addObject:[self translateCellIndexWithSingleIndex:i]];

    return allCellIndexArr;
}

@end
