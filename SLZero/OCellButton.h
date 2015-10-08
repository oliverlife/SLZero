//
//  OCellButton.h
//  SLZero
//
//  Created by 李智 on 15/9/26.
//  Copyright © 2015年 李智. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "modal/SLOCell.h"

@interface OCellButton : UIButton

- (id)init;
- (void)updateView:(SLOCell *)cell;

@end
