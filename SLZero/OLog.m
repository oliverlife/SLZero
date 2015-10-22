//
//  OLog.m
//  SLZero
//
//  Created by 李智 on 15/10/9.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "OLog.h"

static NSMutableArray* _logStack = nil;

@implementation OLog

+ (NSString*)addStringInfo:(NSString*)string
{
    NSString* logString = @"";
    NSFileHandle *logHandle = [self openLogFileHandle];
    if(logHandle)
    {
        logString = [logString stringByAppendingString:[NSString stringWithFormat:@"%@\n", [self currentTime]]];
        logString = [logString stringByAppendingString:[NSString stringWithFormat:@"%@\n", string]];
        [self fileHandleWriteStringData:logHandle string:logString];
    }
    [logHandle closeFile];
    return logString;
}

+ (BOOL) fileHandleWriteStringData:(NSFileHandle*) logHandle string:(NSString*)string
{
    [logHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    return YES;
}

+ (NSFileHandle *)openLogFileHandle
{
    NSString* logDirectory = [NSString stringWithFormat:@"%@", NSHomeDirectory()];
    NSString* logFileName = @"olog.txt";
    NSString* logPath = [NSString stringWithFormat:@"%@/%@", logDirectory, logFileName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:logPath isDirectory:nil])
        [fileManager createFileAtPath:logPath contents:nil attributes:nil];
    
    NSFileHandle *logHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
    [logHandle seekToFileOffset:[logHandle seekToEndOfFile]];
    return logHandle;
}

+ (NSMutableArray*)getLogStack
{
    if(_logStack == nil)
        _logStack = [NSMutableArray array];
    
    return _logStack;
}

+ (NSString*)pushLog:(NSString*)string
{
    NSString* logString = @"";
    if([self getLogStack])
    {
        NSDate* currentDate = [NSDate date];
        NSDictionary *logDict = @{@"time":[NSDate date], @"logString":[NSString stringWithFormat:@"%@(time::%@)", string, [self formatNSDate:currentDate]]};
        logString = [self addStringInfo:[NSString stringWithFormat:@"%@::%@", @"pushLog", logDict[@"logString"]]];
        [[self getLogStack] addObject:logDict];
    }
    return logString;
}

+ (NSString*)popLog
{
    NSString* logString = @"";
    if([[self getLogStack] count] > 0)
    {
        NSDate* currentDate = [NSDate date];
        NSDictionary *logDict = [[self getLogStack] lastObject];
        NSDate* oldDate = logDict[@"time"];
        [[self getLogStack] removeLastObject];
        logString = [self addStringInfo:[NSString stringWithFormat:@"%@::%@(interval::%@)",@"popLog", logDict[@"logString"], [self formatTimeInterval:[currentDate timeIntervalSinceDate:oldDate]]]];
    }
    return logString;
}

+ (NSString*)formatTimeInterval:(NSTimeInterval) timeInterval
{
    NSInteger hs = 3600;
    NSInteger ti = timeInterval;
    NSInteger h = ti / hs;
    ti %= hs;
    NSInteger ms = 60;
    NSInteger m = ti / ms;
    ti %= ms;
    
    return [NSString stringWithFormat:@"h:%ld m:%ld s:%.3lf", h, m, timeInterval - h * hs - m * ms];
}

+ (NSString*)formatNSDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return [dateFormatter stringFromDate:date];

}

+ (NSString*)currentTime
{
    return [self formatNSDate:[NSDate date]];
}

@end
