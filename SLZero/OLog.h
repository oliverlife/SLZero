//
//  OLog.h
//  SLZero
//
//  Created by 李智 on 15/10/9.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLog : NSObject

+ (NSString*)addStringInfo:(NSString*)string;
+ (NSString*)pushLog:(NSString*)string;
+ (NSString*)popLog;

@end
