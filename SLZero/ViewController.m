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

#define CELLWIDTH 40
#define CELLHEIGHT 40
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
@property(nonatomic, strong)UILabel *gameCellIndexInfo;
@property(nonatomic, strong)SLOAutoRun *autoRun;
@property(nonatomic, strong)UIButton *autoRunButton;
@property(nonatomic, strong)UITextView *runInfoView;

@end

@implementation ViewController

- (SLOGame *)game
{
    if(!_game)
    {
        _game = [[SLOGame alloc] initWithWidth:self.gameWidth height:self.gameHeight mineNumber:self.mineNumber];
        [self addLogInfo:@"new game"];
        [self addLogInfo:[self.game.randomMineArr description]];
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

- (UITextView *)runInfoView
{
    if(!_runInfoView)
        _runInfoView = [[UITextView alloc] init];
    
    return _runInfoView;
}
- (UILabel *)gameCellIndexInfo
{
    if(!_gameCellIndexInfo)
        _gameCellIndexInfo = [[UILabel alloc] init];
    
    return _gameCellIndexInfo;
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

- (void)viewDidAppear:(BOOL)animated
{
    [self updateRunInfoView:@""];
}

-(void)updateAllView
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
    [self layoutRunInfoView];
}

- (void)layoutRunInfoView
{
    CGRect runInfoRect = CGRectMake(CELLWIDTH, (self.game.height + 3) * CELLHEIGHT, CELLSIZE.width * self.game.width , CELLSIZE.height * 6);
    [self.runInfoView setFrame:runInfoRect];
    [self.view addSubview:self.runInfoView];
    self.runInfoView.editable = NO;
    self.runInfoView.font = [UIFont systemFontOfSize:17];
    self.runInfoView.layer.borderWidth =1.0;
}

- (void)updateRunInfoView:(NSString *)infoString
{
    self.runInfoView.text = [self.runInfoView.text stringByAppendingString:infoString];
    [self.runInfoView scrollRangeToVisible:NSMakeRange(self.runInfoView.text.length, 1)];
    self.runInfoView.layoutManager.allowsNonContiguousLayout = NO;
}

- (void)layoutGameStateLable
{
    CGRect gameStateLabelRect = CGRectMake(CELLWIDTH * 8, (self.game.height + 1) * CELLHEIGHT, CELLSIZE.width * 2, CELLSIZE.height);
    [self.gameStateLable setFrame:gameStateLabelRect];
    [self.view addSubview:self.gameStateLable];
    [self.gameStateLable setBackgroundColor:[[UIColor alloc] initWithRed:0.0 green:162 / 255.0 blue:232 / 255.0 alpha:1.0]];
}

- (void)layoutGameCellIndexInfo
{
    CGRect gameStateLabelRect = CGRectMake(CELLWIDTH * 11, (self.game.height + 1) * CELLHEIGHT, CELLSIZE.width * 2, CELLSIZE.height);
    [self.gameCellIndexInfo setFrame:gameStateLabelRect];
    [self.view addSubview:self.gameCellIndexInfo];
    [self.gameCellIndexInfo setBackgroundColor:[[UIColor alloc] initWithRed:0.0 green:162 / 255.0 blue:232 / 255.0 alpha:1.0]];
}

- (void)updateGameCellIndexInfo:(SLOGameCellIndex *)cellIndex;
{
    [self.gameCellIndexInfo setText:[cellIndex description]];
}

- (void)autoRun:(UIButton *)sender
{
    [self pushLog:@"autoRun"];
    SLOGameCellIndex *cellIndex = [self.autoRun next];
    if(cellIndex)
    {
        OCellButton *cellButton = [self getCellButtonWithCellIndex:cellIndex];
        [cellButton setBackgroundColor:[UIColor greenColor]];
    }
    [self popLog];
}

- (void)clickCellButton:(UIButton *)sender
{
    SLOGameCellIndex *cellIndex = [self.game translateCellIndexWithSingleIndex:[self findCellButton:sender]];
    [self addLogInfo:[cellIndex debugDescription]];
    NSArray *openedCellIndexArr = [self.game openCellWithCellIndex:cellIndex];
    [self addLogInfo:[NSString stringWithFormat:@"openedCell = %lu", [openedCellIndexArr count]]];
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
        [self addLogInfo:@"Wined"];
    }
    else
    {
        if(self.game.isLost)
        {
            [self.gameStateLable setText:@"LLLLosted"];
            [self addLogInfo:@"LLLLosted"];
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

- (NSString*)addLogInfo:(NSString*)string
{
    NSString *logInfo = [OLog addStringInfo:string];
    NSLog(@"%@", logInfo);
    [self updateRunInfoView:logInfo];
    return logInfo;
}

- (NSString*)pushLog:(NSString*)string
{
    NSString *logInfo = [OLog pushLog:string];
    NSLog(@"%@", logInfo);
    [self updateRunInfoView:logInfo];
    return logInfo;
}

- (NSString*)popLog
{
    NSString *logInfo = [OLog popLog];
    NSLog(@"%@", logInfo);
    [self updateRunInfoView:logInfo];
    return logInfo;
}

@end
