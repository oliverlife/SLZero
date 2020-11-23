//
//  SLZeroTests.m
//  SLZeroTests
//
//  Created by 李智 on 15/9/11.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLOCell.h"

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

- (void)testSLOCell: (SLOCell *)cell other: (SLOCell *)other {
    XCTAssertEqual(cell.number, other.number);
    XCTAssertEqual(cell.isOpen, other.isOpen);
    XCTAssertEqual(cell.isFlag, other.isFlag);
    XCTAssertEqual(cell.isQFlag, other.isQFlag);
}

- (void)testSLOCellSeri {
    SLOCell * cell = [[SLOCell alloc] initWithNumber:7];
    [self testSLOCell: cell other: [SLOCell fromWithData:[cell toData]]];
    
    [cell setQFlag];
    [self testSLOCell: cell other: [SLOCell fromWithData:[cell toData]]];
    
    [cell setFlag];
    [self testSLOCell: cell other: [SLOCell fromWithData:[cell toData]]];
    
    [cell isOpen];
    [self testSLOCell: cell other: [SLOCell fromWithData:[cell toData]]];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
