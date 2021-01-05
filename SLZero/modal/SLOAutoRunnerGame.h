//
//  SLOAutoRunnerGame.h
//  SLZero
//
//  Created by 李智 on 2021/1/6.
//  Copyright © 2021 李智. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLOAutoRunner.h"
#import "SLOGame.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLOAutoRunnerGame : NSObject<SLOAutoRunnerObserver, SLOGameObserver>

- (id)initWithAutoRunner:(SLOAutoRunner *)runner withGame:(SLOGame *)game;
- (void)run;

@end

NS_ASSUME_NONNULL_END
