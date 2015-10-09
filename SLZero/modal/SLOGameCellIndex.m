//
//  SLOGameCellIndex.m
//  SLZero
//
//  Created by 李智 on 15/9/26.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "SLOGameCellIndex.h"

@implementation SLOGameCellIndex

- (id)initWithIndexX:(NSInteger) x indexY:(NSInteger) y
{
    if(self = [super init])
    {
        _x = x;
        _y = y;
    }
    
    return self;
}

- (NSString*)debugDescription
{
    return [NSString stringWithFormat:@"%@:\nx = %ld,y = %ld \n", @"<SLOGameCellIndex>", self.x, self.y];
}

@end
