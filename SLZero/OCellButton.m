//
//  OCellButton.m
//  SLZero
//
//  Created by 李智 on 15/9/26.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "OCellButton.h"

@implementation OCellButton

-(id)init
{
    return [super init];
}

- (void)updateView:(SLOCell *)cell
{
    //[self setBackgroundColor:[UIColor redColor]];
    [self setTitle:[cell getState] forState:UIControlStateNormal];
    if(cell.isOpened)
    {
        [self setBackgroundColor:[[UIColor alloc] initWithRed:240/255.0 green:237/255.0 blue:196/255.0 alpha:1.0]];
        [self setTitleColor:[[UIColor alloc] initWithRed:255/255.0 green:127/255.0 blue:39/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundColor:[[UIColor alloc] initWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0]];
        [self setTitleColor:[[UIColor alloc] initWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    }

}

@end
