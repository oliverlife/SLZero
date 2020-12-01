//
//  SLZeroTests.m
//  SLZeroTests
//
//  Created by 李智 on 15/9/11.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLOCell.h"
#import "SLOGame.h"

@interface SLZeroTests : XCTestCase

@end

@implementation SLZeroTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testSLOCellIsEqual {
    SLOCell * cell = [[SLOCell alloc] initWithNumber:7];
    
    SLOCell * cell2 = [[SLOCell alloc] initWithNumber:7];
    XCTAssertEqualObjects(cell, cell2);
    
    SLOCell * cell3 = [[SLOCell alloc] initWithNumber:7];
    [cell3 setQFlag];
    XCTAssertNotEqualObjects(cell, cell3);
    
    SLOCell * cell4 = [[SLOCell alloc] initWithNumber:7];
    [cell4 setFlag];
    XCTAssertNotEqualObjects(cell, cell4);
    
    SLOCell * cell5 = [[SLOCell alloc] initWithNumber:7];
    [cell5 setOpen];
    XCTAssertNotEqualObjects(cell, cell5);
    
    SLOCell * cell6 = [[SLOCell alloc] initWithNumber:6];
    XCTAssertNotEqualObjects(cell, cell6);
}

- (void)testSLOCellSeri {
    SLOCell * cell = [[SLOCell alloc] initWithNumber:7];
    XCTAssertEqualObjects(cell, [SLOCell fromWithData:[cell toData]]);
    
    [cell setQFlag];
    XCTAssertEqualObjects(cell, [SLOCell fromWithData:[cell toData]]);
    
    [cell setFlag];
    XCTAssertEqualObjects(cell, [SLOCell fromWithData:[cell toData]]);
    
    [cell isOpen];
    XCTAssertEqualObjects(cell, [SLOCell fromWithData:[cell toData]]);
}

- (void)testSLGameIsEqual {
    SLOGame * game1 = [[SLOGame alloc] initWithWidth:30 height:16 mineNumber:99];
    SLOGame * game2 = [[SLOGame alloc] initWithWidth:30 height:16 mineNumber:99];
    XCTAssertEqualObjects(game1, game2);
    
    SLOGame * game3 = [[SLOGame alloc] initWithWidth:30 height:16 mineNumber:98];
    SLOGame * game4 = [[SLOGame alloc] initWithWidth:30 height:16 mineNumber:99];
    XCTAssertNotEqualObjects(game3, game4);
}

- (void)testSLOGameSeri {
    SLOGame * game = [[SLOGame alloc] initWithWidth:30 height:16 mineNumber:99];
    SLOGame * game2 = [SLOGame fromWithData: [game toData]];
    XCTAssertEqualObjects(game, game2);
}

- (NSString *)testFilePath: (NSString *)name {
    return [NSString stringWithFormat:@"%@/%@", [NSBundle bundleForClass:SLZeroTests.class].bundlePath, name];
}

- (void)testPerformanceExample {
    NSLog(@"%@", [NSBundle bundleForClass:SLZeroTests.class]);
    NSLog(@"%@", [NSBundle mainBundle]);
    NSString * path = [self testFilePath:@"game.w20.h10.m40.plist"];
    SLOGame * game = [SLOGame fromWithData: [NSFileManager.defaultManager contentsAtPath:path]];
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        NSUInteger a = 1 + 1;
    }];
}

@end
