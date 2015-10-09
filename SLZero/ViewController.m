//
//  ViewController.m
//  SLZero
//
//  Created by 李智 on 15/9/11.
//  Copyright © 2015年 李智. All rights reserved.
//

#import "ViewController.h"
#import "SLOGame.h"
#import "OCellButton.h"
#import "modal/SLOGameCellIndex.h"
#import "modal/SLOAutoRun.h"
#import "OLog.h"

#define CELLWIDTH 50
#define CELLHEIGHT 50
#define CELLSIZE CGSizeMake(CELLWIDTH, CELLHEIGHT)
#define CELLZONEORIGIN CGPointMake(10,10)

@interface ViewController ()

@property(nonatomic, strong)SLOGame *game;
@property NSUInteger gameWidth;
@property NSUInteger gameHeight;
@property NSUInteger mineNumber;
@property (nonatomic, strong)NSArray *cellArr;
@property(nonatomic, strong)UIButton *resetGameButton;
@property(nonatomic, strong)UILabel *gameStateLable;
@property(nonatomic, strong)SLOAutoRun *autoRun;
@property(nonatomic, strong)UIButton *autoRunButton;

@end

@implementation ViewController

- (SLOGame *)game
{
    if(!_game)
    {
        _game = [[SLOGame alloc] initWithWidth:self.gameWidth height:self.gameHeight mineNumber:self.mineNumber];
        [OLog addStringInfo:@"new game"];
        [OLog addStringInfo:[self.game.randomMineArr description]];
    }
    
    return _game;
}

- (SLOAutoRun *)autoRun
{
    if(!_autoRun)
        _autoRun = [[SLOAutoRun alloc] initWithSLOGame:self.game];
    
    return _autoRun;
}

 - (UIButton *)autoRunButton
{
    if(!_autoRunButton)
        _autoRunButton = [[UIButton alloc] init];
    
    return _autoRunButton;
}

- (UIButton *)resetGameButton
{
    if(!_resetGameButton)
        _resetGameButton = [[UIButton alloc] init];
    
    return _resetGameButton;
}

- (UILabel *)gameStateLable
{
    if(!_gameStateLable)
        _gameStateLable = [[UILabel alloc] init];
    
    return _gameStateLable;
}

- (NSArray *)cellArr
{
    if(!_cellArr)
    {
        NSMutableArray *initedCellArr = [[NSMutableArray alloc] initWithCapacity:self.game.size];
        for(int index = 0;index < self.game.size;++index)
            initedCellArr[index] = [[OCellButton alloc] init];
        
        _cellArr = initedCellArr;
    }
        
    return _cellArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.gameWidth = 20;
    self.gameHeight = 10;
    self.mineNumber = 40;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self layoutCell];
    [self updateAllView];
}

- (void)updateAllView
{
    [self updateMineView];
    [self updateGameStateLable];
}

- (void)layoutCell
{
    for(int index = 0;index < self.game.size;++index)
    {
        SLOGameCellIndex * cellIndex = [self.game translateCellIndexWithSingleIndex:index];
        OCellButton * cellButton = [self getCellButtonWithCellIndex:cellIndex];
        
        [cellButton addTarget:self
                    action:@selector(clickCellButton:)
          forControlEvents:UIControlEventTouchUpInside
         ];
        
        [self.view addSubview:cellButton];
        CGPoint localOrigin = CELLZONEORIGIN;
        localOrigin.y += cellIndex.y * CELLHEIGHT;
        localOrigin.x += cellIndex.x * CELLWIDTH;
        
        CGRect localRect = CGRectMake(localOrigin.x, localOrigin.y, CELLSIZE.width, CELLSIZE.height);
        [cellButton setFrame:localRect];
    }
    
    CGRect resetGameButtonRect = CGRectMake(CELLWIDTH, (self.game.height + 1) * CELLHEIGHT, CELLSIZE.width * 2, CELLSIZE.height);
    [self.resetGameButton setFrame:resetGameButtonRect];
    [self.view addSubview:self.resetGameButton];
    [self.resetGameButton setTitle:@"restart" forState:UIControlStateNormal];
    [self.resetGameButton setBackgroundColor:[[UIColor alloc] initWithRed:181 / 256.0 green:230 / 256.0 blue:29/256.0 alpha:1.0]];
    [self.resetGameButton addTarget:self action:@selector(resetGame:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect autoRunButtonRect = CGRectMake(CELLWIDTH * 5, (self.game.height + 1) * CELLHEIGHT, CELLSIZE.width * 2, CELLSIZE.height);
    [self.autoRunButton setFrame:autoRunButtonRect];
    [self.view addSubview:self.autoRunButton];
    [self.autoRunButton setTitle:@"autoRun" forState:UIControlStateNormal];
    [self.autoRunButton setBackgroundColor:[[UIColor alloc] initWithRed:181 / 256.0 green:230 / 256.0 blue:29/256.0 alpha:1.0]];
    [self.autoRunButton addTarget:self action:@selector(autoRun:) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutGameStateLable];
}

- (void)layoutGameStateLable
{
    CGRect gameStateLabelRect = CGRectMake(CELLWIDTH * 8, (self.game.height + 1) * CELLHEIGHT, CELLSIZE.width * 2, CELLSIZE.height);
    [self.gameStateLable setFrame:gameStateLabelRect];
    [self.view addSubview:self.gameStateLable];
    [self.gameStateLable setBackgroundColor:[[UIColor alloc] initWithRed:0.0 green:162 / 255.0 blue:232 / 255.0 alpha:1.0]];
}

- (void)autoRun:(UIButton *)sender
{
    SLOGameCellIndex *cellIndex = [self.autoRun next];
    if(cellIndex)
    {
        OCellButton *cellButton = [self getCellButtonWithCellIndex:cellIndex];
        [cellButton setBackgroundColor:[UIColor greenColor]];
    }
}

- (void)clickCellButton:(UIButton *)sender
{
    SLOGameCellIndex *cellIndex = [self.game translateCellIndexWithSingleIndex:[self findCellButton:sender]];
    BOOL testBool = [OLog addStringInfo:[cellIndex debugDescription]];
    NSArray *openedCellIndexArr = [self.game openCellWithCellIndex:cellIndex];
    {
        for(SLOGameCellIndex *openCellIndex in openedCellIndexArr)
        {
            [self.autoRun updateFormulaSetWithCellIndexArr:[self.game aroundCellIndex:openCellIndex]];
        }
        [self.autoRun updateFormulaSetWithCellIndexArr:openedCellIndexArr];
    }
    [self updateCellButton:openedCellIndexArr];
    [self updateGameStateLable];
}

- (void)updateGameStateLable
{
    if(self.game.isWin)
    {
        [self.gameStateLable setText:@"Winer!"];
        [OLog addStringInfo:@"Wined"];
    }
    else
    {
        if(self.game.isLost)
        {
            [self.gameStateLable setText:@"LLLLosted"];
            [OLog addStringInfo:@"LLLLosted"];
        }
        else
            [self.gameStateLable setText:@"gogo...."];
    }
}

- (void)resetGame:(UIButton *)sender
{
    self.game = nil;
    self.autoRun = nil;
    [self updateAllView];

}

- (void)updateMineView
{
    [self updateCellButton:nil];
}

- (NSUInteger)findCellButton:(UIButton *)cellButton
{
   return [self.cellArr indexOfObject:cellButton];
}

- (void)updateCellButton:(NSArray *)cellButtonArr
{
    if(cellButtonArr == nil)
    {
        NSMutableArray * tempArr = [NSMutableArray array];
        for(int index = 0;index < self.game.size;++index)
            [tempArr addObject:[self.game translateCellIndexWithSingleIndex:index]];
        
        cellButtonArr = tempArr;
    }
    for(SLOGameCellIndex * cellIndex in cellButtonArr)
        [self updateSingleCellButton:cellIndex];
}

- (void)updateSingleCellButton:(SLOGameCellIndex *)cellIndex
{
    [[self getCellButtonWithCellIndex:cellIndex] updateView:[self.game getCellWithCellIndex:cellIndex]];
}

- (OCellButton *)getCellButtonWithCellIndex:(SLOGameCellIndex *)cellIndex
{
    return self.cellArr[cellIndex.y * self.game.width + cellIndex.x];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
