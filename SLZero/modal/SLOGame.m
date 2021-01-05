//
//  SLOGame.m
//  SLZero
//
//  Created by 李智 on 15/9/14.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <Foundation/NSObjCRuntime.h>
#import "SLOGame.h"

#define MineFlag @(1)
#define NonMineFlag @(0)

@interface SLOGame()

@property(nonatomic, strong)NSMutableArray * cellArr;
@property(nonatomic, assign)BOOL isLost;
@property(nonatomic, assign)BOOL isWin;
@property(nonatomic, strong, readwrite)NSArray* randomMineArr;

@property(nonatomic, strong, readwrite) NSMutableArray* observerArray;

- (NSArray *)openCellWithXIndex:(NSInteger)xIndex yIndex:(NSInteger)yIndex;
- (SLOCell *)getCellWithXIndex:(NSInteger)xIndex yIndex:(NSInteger)yIndex;

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

- (NSMutableArray *)observerArray {
    //TODO: 持有observer可能导致内存泄露
    if (!_observerArray) {
        _observerArray = [NSMutableArray array];
    }
    
    return _observerArray;
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
            self.cellArr;
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
    [self notifyGameOpenedCells:openedCellArr];
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

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass: SLOGame.class]) {
        return NO;
    }
    
    SLOGame * other = object;
    return self.height == other.height
        && self.width == other.width
        && self.mineNumber == other.mineNumber
        && self.isLost == other.isLost
        && self.isWin == other.isWin
        && [self.randomMineArr isEqualToArray: other.randomMineArr]
        && [self.cellArr isEqualToArray: other.cellArr];
}

- (NSData *)toData {
    NSMutableArray * cellDataArr = [NSMutableArray array];
    for(NSUInteger i = 0; i < self.cellArr.count; ++i) {
        [cellDataArr addObject:[self.cellArr[i] toData]];
    }
    
    NSDictionary * dict = @{
        @"height": @(self.height),
        @"width": @(self.width),
        @"mineNumber": @(self.mineNumber),
        @"isLost": @(self.isLost),
        @"isWin": @(self.isWin),
        @"randomMineArr": self.randomMineArr,
        @"cellArr": cellDataArr,
    };
    
    return [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
}

+ (SLOGame *)fromWithData: (NSData *) data {
    NSDictionary * dict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:nil error:nil];
    
    NSUInteger height = [dict[@"height"] unsignedIntegerValue];
    NSUInteger width = [dict[@"width"] unsignedIntegerValue];
    NSUInteger mineNumber = [dict[@"mineNumber"] unsignedIntegerValue];
    NSUInteger isLost = [dict[@"isLost"] boolValue];
    NSUInteger isWin = [dict[@"isWin"] boolValue];
    NSArray * randomMineArr = dict[@"randomMineArr"];
    
    NSArray * cellDataArr = dict[@"cellArr"];
    NSMutableArray * cellArr = [NSMutableArray array];
    for(NSUInteger i = 0; i < cellDataArr.count; ++i) {
        [cellArr addObject:[SLOCell fromWithData:cellDataArr[i]]];
    }
    
    SLOGame * result = [[SLOGame alloc] initWithWidth:width height:height mineNumber:mineNumber];
    result.isLost = isLost;
    result.isWin = isWin;
    result.randomMineArr = randomMineArr;
    result.cellArr = cellArr;
    return result;
}

- (void)notifyGameOpenedCells: (NSArray *)cells {
    for(NSUInteger i = 0; i < self.observerArray.count; ++i) {
        id<SLOGameObserver> observer = self.observerArray[i];
        if ([observer respondsToSelector: @selector(updateOpenedCells:withGame:)]) {
            [self.observerArray[i] updateOpenedCells:cells withGame:self];
        }
    }
}

- (void)addGameObserver:(id<SLOGameObserver>)observer {
    [self.observerArray addObject:observer];
}

- (void)removeGameObserver:(id<SLOGameObserver>)observer {
    [self.observerArray removeObject:observer];
}

@end
