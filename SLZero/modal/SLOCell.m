//
//  SLOCell.m
//  SLZero
//
//  Created by 李智 on 15/9/11.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "SLOCell.h"

@interface SLOCell()
{
}
@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, assign) BOOL isFlag;
@property(nonatomic, assign) BOOL isQFlag;
@property(nonatomic, assign) NSInteger number;

@end

@implementation SLOCell

- (id)initWithNumber:(NSInteger)number
{
    if(number <= 8)
    {
        if(self = [super init])
        {
            self.number = number;
            self.isOpen = NO;
            self.isFlag = NO;
            self.isQFlag = NO;
        }
    }
    else
        return nil;
    
    return self;
}

- (SLOCellStateType)setOpen
{
    if(!self.isFlag && !self.isQFlag)
        self.isOpen = YES;
    return [self getState];
}

- (BOOL)isOpened
{
    return self.isOpen;
}

- (SLOCellStateType)setFlag
{
    if(!self.isOpen)
    {
        self.isFlag = YES;
        self.isQFlag = NO;
    }
    return [self getState];
}

- (SLOCellStateType)setQFlag
{
    if(!self.isOpen)
    {
        self.isQFlag = YES;
        self.isFlag = NO;
    }
    return [self getState];
}

- (SLOCellStateType)clearFlag
{
    if(!self.isOpen)
    {
        self.isQFlag = NO;
        self.isFlag = NO;
    }
    return [self getState];
}

- (SLOCellStateType)getState
{
    NSString * stateStr = nil;
    if(self.isOpen)
    {
        stateStr = [NSString stringWithFormat:@"%@", @(self.number)];
    }
    else
    {
        stateStr = @"E";
        if(self.isFlag)
            stateStr = @"F";
        
        if(self.isQFlag)
            stateStr = @"Q";
    }
    return stateStr;
}

@end
