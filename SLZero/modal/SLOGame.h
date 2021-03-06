//
//  SLOGame.h
//  SLZero
//
//  Created by 李智 on 15/9/14.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLOCell.h"
#import "SLOGameCellIndex.h"

@class SLOGame;

@protocol SLOGameObserver <NSObject>
- (void)updateCellsOpenedStatus: (NSArray *)cells withGame: (SLOGame *)game;
@end

@interface SLOGame : NSObject

@property(nonatomic, assign, readonly)NSUInteger height;
@property(nonatomic, assign, readonly)NSUInteger width;
@property(nonatomic, assign, readonly)NSUInteger mineNumber;
@property(nonatomic, assign, readonly)NSUInteger size;
@property(nonatomic, assign, readonly)BOOL isLost;
@property(nonatomic, assign, readonly)BOOL isWin;
@property(nonatomic, strong, readonly)NSArray* randomMineArr;

- (id)initWithWidth:(NSUInteger)width height:(NSUInteger)height mineNumber:(NSUInteger)mineNumber;
- (NSArray *)openCellWithCellIndex:(SLOGameCellIndex *)cellIndex;
- (void)unopenCellWithCellIndex:(SLOGameCellIndex *)cellIndex;
- (SLOCell *)getCellWithCellIndex:(SLOGameCellIndex *)cellIndex;
- (SLOGameCellIndex *)translateCellIndexWithXIndex:(NSInteger)xIndex yIndex:(NSInteger)yIndex;
- (SLOGameCellIndex *)translateCellIndexWithSingleIndex:(NSUInteger)index;
- (BOOL)isValidIndexWithCellIndex:(SLOGameCellIndex *)cellIndex;
- (NSArray *)aroundCellIndex:(SLOGameCellIndex *)cellIndex;
- (NSArray *)allCellIndex;

- (NSData *)toData;
+ (SLOGame *)fromWithData: (NSData *) data;

- (void)addGameObserver: (id<SLOGameObserver>) observer;
- (void)removeGameObserver: (id<SLOGameObserver>) observer;

@end
