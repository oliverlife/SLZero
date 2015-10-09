//
//  OLog.m
//  SLZero
//
//  Created by 李智 on 15/10/9.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "OLog.h"

@implementation OLog

+ (BOOL)addStringInfo:(NSString *)string
{
    BOOL returnValue = YES;
    NSString* logDirectory = [NSString stringWithFormat:@"%@", NSHomeDirectory()];
    NSString* logFileName = @"olog.txt";
    NSString* logPath = [NSString stringWithFormat:@"%@/%@", logDirectory, logFileName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:logPath isDirectory:nil])
        [fileManager createFileAtPath:logPath contents:nil attributes:nil];
    
    NSFileHandle *logHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
    returnValue = NO;
    [logHandle seekToFileOffset:[logHandle seekToEndOfFile]];
    if(logHandle)
    {
        [logHandle writeData:[[NSString stringWithFormat:@"%@\n", [self currentTime]] dataUsingEncoding:NSUTF8StringEncoding]];
        string = [NSString stringWithFormat:@"%@\n", string];
        [logHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
        returnValue = YES;
    }
    [logHandle closeFile];
    return returnValue;
}

+ (NSString*)currentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
