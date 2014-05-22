//
//  ViewController.m
//  Farkle
//
//  Created by tbredemeier on 5/21/14.
//  Copyright (c) 2014 Mobile Makers Academy. All rights reserved.
//

#import "ViewController.h"
#import "DieLabel.h"

@interface ViewController () <DieLabelDelegate>
@property (strong, nonatomic) IBOutlet DieLabel *dieLabel1;
@property (strong, nonatomic) IBOutlet DieLabel *dieLabel2;
@property (strong, nonatomic) IBOutlet DieLabel *dieLabel3;
@property (strong, nonatomic) IBOutlet DieLabel *dieLabel4;
@property (strong, nonatomic) IBOutlet DieLabel *dieLabel5;
@property (strong, nonatomic) IBOutlet DieLabel *dieLabel6;
@property (strong, nonatomic) IBOutlet UILabel *redScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *blueScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *redTurnLabel;
@property (strong, nonatomic) IBOutlet UILabel *blueTurnLabel;
@property NSMutableArray *selectedDice;
@property NSMutableArray *scoredDice;
@property NSInteger redScore;
@property NSInteger blueScore;
@property NSInteger turnScore;
@property NSInteger numDiesScoring;
@property BOOL isRedTurn;
@property BOOL turnOver;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dieLabel1.delegate = self;
    self.dieLabel2.delegate = self;
    self.dieLabel3.delegate = self;
    self.dieLabel4.delegate = self;
    self.dieLabel5.delegate = self;
    self.dieLabel6.delegate = self;
    self.selectedDice = [[NSMutableArray alloc]init];
    self.scoredDice = [[NSMutableArray alloc]init];
    [self resetGame];
}

- (IBAction)onRollButtonPressed:(id)sender
{
    [self scoreSelectedDice];
    if(!self.turnOver)
    {
        // fast enumerate through all the controlls in the view
        for(DieLabel *object in self.view.subviews)
        {
            // check to see if the control is a DieLabel
            if([object isKindOfClass:[DieLabel class]])
            {
                if(![self.scoredDice containsObject:object])
                {
                    [object roll];
                }
            }
        }
    }
}

- (IBAction)onDoneButtonPressed:(id)sender
{
    [self scoreSelectedDice];
    [self endTurn];
}

- (IBAction)onQuitButtonPressed:(id)sender
{
    exit(0);
}

- (void)didChooseDie:(DieLabel *)dieLabel
{
    [self.selectedDice addObject:dieLabel];
    dieLabel.backgroundColor = [UIColor purpleColor];
}

- (void)resetGame
{
    self.redScore = 0;
    self.blueScore = 0;
    self.isRedTurn = NO;
    [self endTurn];
}

- (void)endTurn
{
    self.turnScore = 0;
    self.isRedTurn = !self.isRedTurn;
    if(self.isRedTurn)
    {
        [self.redTurnLabel setBackgroundColor:[UIColor lightGrayColor]];
        [self.blueTurnLabel setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [self.blueTurnLabel setBackgroundColor:[UIColor lightGrayColor]];
        [self.redTurnLabel setBackgroundColor:[UIColor whiteColor]];
    }
    [self resetDice];
    self.turnOver = NO;
}

- (void)resetDice
{
    for(DieLabel *object in self.view.subviews)
    {
        // check to see if the control is a DieLabel
        if([object isKindOfClass:[DieLabel class]])
            [object reset];
    }
    [self.scoredDice removeAllObjects];
    self.numDiesScoring = 0;
}

- (void)scoreSelectedDice
{
    NSInteger num1s = 0;
    NSInteger num2s = 0;
    NSInteger num3s = 0;
    NSInteger num4s = 0;
    NSInteger num5s = 0;
    NSInteger num6s = 0;
    NSInteger rollScore = 0;

    // get pip totals
    for(DieLabel *dieLabel in self.selectedDice)
    {
        switch ([dieLabel.text intValue])
        {
            case 1:
                num1s ++;
                break;
            case 2:
                num2s ++;
                break;
            case 3:
                num3s ++;
                break;
            case 4:
                num4s ++;
                break;
            case 5:
                num5s ++;
                break;
            case 6:
                num6s ++;
                break;
            default:
                break;
        }
    }

    // calculate 1's score
    while (num1s > 0)
    {
        if (num1s >= 3)
        {
            rollScore += 1000;  // three 1's are 1000 points
            num1s -= 3;
            self.numDiesScoring += 3;
        }
        else
        {
            rollScore += 100;   // each additional 1 is 100 points
            num1s --;
            self.numDiesScoring ++;
        }
    }

    while(num2s >= 3)
    {
        rollScore += 200;       // three 2's are 200 points
        num2s -= 3;
        self.numDiesScoring += 3;
    }

    while(num3s >= 3)
    {
        rollScore += 300;       // three 3's are 300 points
        num3s -= 3;
        self.numDiesScoring += 3;
    }

    while(num4s >= 3)
    {
        rollScore += 400;       // three 4's are 400 points
        num4s -= 3;
        self.numDiesScoring += 3;
    }

    while (num5s > 0)
    {
        if (num5s >= 3)
        {
            rollScore += 500;   // three 5's are 500 points
            num5s -= 3;
            self.numDiesScoring += 3;
        }
        else
        {
            rollScore += 50;    // each additional 5 is worth 50 points
            num5s --;
            self.numDiesScoring ++;
        }
    }

    while(num6s >= 3)
    {
        rollScore += 600;       // three 6's are 600 points
        num6s -= 3;
        self.numDiesScoring ++;
    }

    self.turnScore += rollScore;
    if(self.isRedTurn)
    {
        if(rollScore > 0)
            self.redScore += rollScore;
        else
        {
            if(self.redScore >= self.turnScore && self.turnScore > 0)
            {
                self.redScore -= self.turnScore;
                self.turnOver = YES;
            }
        }
        [self.redScoreLabel setText:[NSString stringWithFormat:@"%d", self.redScore]];
    }
    else
    {
        if(rollScore > 0)
            self.blueScore += rollScore;
        else
        {
            if(self.blueScore >= self.turnScore && self.turnScore > 0)
            {
                self.blueScore -= self.turnScore;
                self.turnOver = YES;
            }
        }
        [self.blueScoreLabel setText:[NSString stringWithFormat:@"%d", self.blueScore]];
    }

    // add selected dice to scored dice array
    for(DieLabel *dieLabel in self.selectedDice)
    {
        if(![self.scoredDice containsObject:dieLabel])
            [self.scoredDice addObject:dieLabel];
    }
    // reset selected dice array
    [self.selectedDice removeAllObjects];

    // check for "hot dice"
    if(self.numDiesScoring == 6)
        [self resetDice];
}

@end