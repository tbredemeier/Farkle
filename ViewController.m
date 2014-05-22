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
@property (strong, nonatomic) IBOutlet UILabel *userScoreLabel;
@property NSMutableArray *selectedDice;
@property NSMutableArray *scoredDice;
@property NSInteger score;
@property NSInteger numDiesScoring;

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

- (IBAction)onDoneButtonPressed:(id)sender
{
    [self scoreSelectedDice];
    [self resetGame];
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
    self.score = 0;
    self.numDiesScoring = 0;
    [self.scoredDice removeAllObjects];
    for(DieLabel *object in self.view.subviews)
    {
        // check to see if the control is a DieLabel
        if([object isKindOfClass:[DieLabel class]])
            [object reset];
    }
}

- (void)scoreSelectedDice
{
    NSInteger num1s = 0;
    NSInteger num2s = 0;
    NSInteger num3s = 0;
    NSInteger num4s = 0;
    NSInteger num5s = 0;
    NSInteger num6s = 0;
    NSInteger turnScore = 0;

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
            turnScore += 1000;  // three 1's are 1000 points
            num1s -= 3;
            self.numDiesScoring += 3;
        }
        else
        {
            turnScore += 100;   // each additional 1 is 100 points
            num1s --;
            self.numDiesScoring ++;
        }
    }

    while(num2s >= 3)
    {
        turnScore += 200;       // three 2's are 200 points
        num2s -= 3;
        self.numDiesScoring += 3;
    }

    while(num3s >= 3)
    {
        turnScore += 300;       // three 3's are 300 points
        num3s -= 3;
        self.numDiesScoring += 3;
    }

    while(num4s >= 3)
    {
        turnScore += 400;       // three 4's are 400 points
        num4s -= 3;
        self.numDiesScoring += 3;
    }

    while (num5s > 0)
    {
        if (num5s >= 3)
        {
            turnScore += 500;   // three 5's are 500 points
            num5s -= 3;
            self.numDiesScoring += 3;
        }
        else
        {
            turnScore += 50;    // each additional 5 is worth 50 points
            num5s --;
            self.numDiesScoring ++;
        }
    }

    while(num6s >= 3)
    {
        turnScore += 600;       // three 6's are 600 points
        num6s -= 3;
        self.numDiesScoring ++;
    }

    if(turnScore > 0)
        self.score += turnScore;
    else
        self.score = 0;

    self.userScoreLabel.text = [NSString stringWithFormat:@"%d", self.score];

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
    {
        [self.scoredDice removeAllObjects];
        for(DieLabel *object in self.view.subviews)
        {
            // check to see if the control is a DieLabel
            if([object isKindOfClass:[DieLabel class]])
            {
                [object reset];
            }
        }
    }
}

@end