//
//  SLOGameCellIndex.h
//  SLZero
//
//  Created by 李智 on 15/9/26.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLOGameCellIndex : NSObject

@property(nonatomic, readonly)NSInteger x;
@property(nonatomic, readonly)NSInteger y;
- (id)initWithIndexX:(NSInteger) x indexY:(NSInteger) y;

@end
