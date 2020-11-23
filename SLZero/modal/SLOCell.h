//
//  SLOCell.h
//  SLZero
//
//  Created by 李智 on 15/9/11.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * SLOCellStateType;

@interface SLOCell : NSObject

@property(nonatomic, assign) BOOL isOpen;
@property(nonatomic, assign) BOOL isFlag;
@property(nonatomic, assign) BOOL isQFlag;
@property(nonatomic, assign) NSInteger number;

- (id)initWithNumber:(NSInteger)number;
- (SLOCellStateType)setOpen;
- (SLOCellStateType)setFlag;
- (SLOCellStateType)setQFlag;
- (SLOCellStateType)clearFlag;
- (SLOCellStateType)getState;
- (BOOL)isOpened;

- (NSData *)toData;
+ (SLOCell *)fromWithData: (NSData *) data;

@end
