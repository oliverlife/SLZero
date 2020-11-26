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

#define CELLWIDTH 30
#define CELLHEIGHT 30
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
@property(nonatomic, strong)UIButton *starButton;
@property(nonatomic, strong)UIButton *nextStepButton;
@property(nonatomic, strong)UIButton *saveButton;
@property(nonatomic, strong)UITextView *runInfoView;
@property(nonatomic, strong)NSOperationQueue *backgroundQueue;

@end

@implementation ViewController

- (NSOperationQueue *)backgroundQueue
{
    if(!_backgroundQueue)
        _backgroundQueue = [[NSOperationQueue alloc] init];
    
    return _backgroundQueue;
}

- (SLOGame *)game
{
    if(!_game)
    {
        _game = [[SLOGame alloc] initWithWidth:self.gameWidth height:self.gameHeight mineNumber:self.mineNumber];
        [self pushLog:@"startGame"];
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

- (UIButton *)nextStepButton
{
    if(!_nextStepButton)
        _nextStepButton = [[UIButton alloc] init];
    
    return _nextStepButton;
}

- (UIButton *)saveButton
{
    if(!_saveButton)
        _saveButton = [[UIButton alloc] init];
    
    return _saveButton;
}

- (UIButton *)starButton
{
    if(!_starButton)
        _starButton = [[UIButton alloc] init];
    
    return _starButton;
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
    [self layoutStarButton];
    [self layoutNextStepButton];
    [self layoutSaveButton];
}

- (void)layoutSaveButton
{
    CGRect nextStepButtonRect = CGRectMake(CELLWIDTH * 17, (self.game.height + 1) * CELLHEIGHT, CELLSIZE.width * 2, CELLSIZE.height);
    [self.saveButton setFrame:nextStepButtonRect];
    [self.view addSubview:self.saveButton];
    [self.saveButton setTitle:@"save" forState:UIControlStateNormal];
    [self.saveButton setBackgroundColor:[[UIColor alloc] initWithRed:251 / 256.0 green:194 / 256.0 blue:44/256.0 alpha:1.0]];
    [self.saveButton addTarget:self action:@selector(saveGame:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutNextStepButton
{
    CGRect nextStepButtonRect = CGRectMake(CELLWIDTH * 14, (self.game.height + 1) * CELLHEIGHT, CELLSIZE.width * 2, CELLSIZE.height);
    [self.nextStepButton setFrame:nextStepButtonRect];
    [self.view addSubview:self.nextStepButton];
    [self.nextStepButton setTitle:@"nextStep" forState:UIControlStateNormal];
    [self.nextStepButton setBackgroundColor:[[UIColor alloc] initWithRed:251 / 256.0 green:194 / 256.0 blue:44/256.0 alpha:1.0]];
    [self.nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nextStep:(UIButton *)sender
{
    [self backgroundAutoRun:^(OCellButton *cellButton)
     {
         //[NSThread sleepForTimeInterval:0.5];
         //[self clickCellButton:cellButton];
     }];
}

- (void)saveGame:(UIButton *)sender {
    NSString * appDirectory = NSHomeDirectory();
    NSString * path = [NSString stringWithFormat:@"%@/%@", appDirectory, @"game.save.plist"];
    [NSFileManager.defaultManager createFileAtPath:path contents:[self.game toData] attributes:nil];
}

- (void)layoutStarButton
{
    CGRect starButtonRect = CGRectMake(CELLWIDTH * 11, (self.game.height + 1) * CELLHEIGHT, CELLSIZE.width * 2, CELLSIZE.height);
    [self.starButton setFrame:starButtonRect];
    [self.view addSubview:self.starButton];
    [self.starButton setTitle:@"star" forState:UIControlStateNormal];
    [self.starButton setBackgroundColor:[[UIColor alloc] initWithRed:251 / 256.0 green:194 / 256.0 blue:44/256.0 alpha:1.0]];
    [self.starButton addTarget:self action:@selector(addStar:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addStar:(UIButton *)sender
{
    [self addLogInfo:@"=============star=================="];
}

- (void)layoutRunInfoView
{
    CGRect runInfoRect = CGRectMake(CELLWIDTH, (self.game.height + 3) * CELLHEIGHT, CELLSIZE.width * self.game.width , CELLSIZE.height * 6);
    [self.runInfoView setFrame:runInfoRect];
    [self.view addSubview:self.runInfoView];
    self.runInfoView.editable = NO;
    self.runInfoView.font = [UIFont systemFontOfSize:17];
    self.runInfoView.layer.borderWidth =1.0;
    self.runInfoView.layoutManager.allowsNonContiguousLayout = NO;
}

- (void)updateRunInfoView:(NSString *)infoString
{
    self.runInfoView.text = [self.runInfoView.text stringByAppendingString:infoString];
    [self.runInfoView scrollRangeToVisible:NSMakeRange(self.runInfoView.text.length, 1)];
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
    [self backgroundAutoRun:^(OCellButton *cellButton)
     {
         [NSThread sleepForTimeInterval:0.5];
         [self clickCellButton:cellButton];
         [self autoRun:nil];
     }];
}

- (void)backgroundAutoRun:(void(^)(OCellButton *))block
{
    [self pushLog:@"backgroundAutoRun"];
    NSOperation *autoRunOpeation = [NSBlockOperation blockOperationWithBlock:^{
        SLOGameCellIndex *cellIndex = [self.autoRun next];
        NSBlockOperation *autoRunFinishedOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self autoRunFinished:cellIndex block:block];
        }];
        [[NSOperationQueue mainQueue] addOperation:autoRunFinishedOperation];
    }];
    [self.backgroundQueue addOperation:autoRunOpeation];
}

- (void)autoRunFinished:(SLOGameCellIndex *)cellIndex block:(void(^)(OCellButton *))block
{
    [self popLog];
    OCellButton *cellButton = [self getCellButtonWithCellIndex:cellIndex];
    if(cellButton)
    {
        [cellButton setBackgroundColor:[UIColor greenColor]];
        [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
            block(cellButton);
        }]];
    }
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
        [self popLog];
    }
    else
    {
        if(self.game.isLost)
        {
            [self.gameStateLable setText:@"LLLLosted"];
            [self addLogInfo:@"LLLLosted"];
            [self popLog];
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
    if(cellIndex)
        return self.cellArr[cellIndex.y * self.game.width + cellIndex.x];
    else
        return nil;
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
