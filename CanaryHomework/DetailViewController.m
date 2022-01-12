//
//  DetailViewController.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"About Device";
    
   // NSLog(@"Selected Device: %@", self.device);
    NSLog(@"Readings: %@", [self.device valueForKey:@"readings"]);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self drawUI];
}

#pragma Draw UI
-(void) drawUI {
    
    //Min Label
    UILabel *minLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    minLabel.backgroundColor = [UIColor systemRedColor];
    minLabel.text = [NSString stringWithFormat:@"Min: XX"];
    minLabel.textAlignment = NSTextAlignmentCenter;
    
    //Avg Label
    UILabel *avgLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 100, 100, 100)];
    avgLabel.backgroundColor = [UIColor systemBlueColor];
    avgLabel.text = [NSString stringWithFormat:@"Avg: XX"];
    avgLabel.textAlignment = NSTextAlignmentCenter;
    
    //Max Label
    UILabel *maxLabel = [[UILabel alloc]initWithFrame:CGRectMake(300, 100, 100, 100)];
    maxLabel.backgroundColor = [UIColor systemYellowColor];
    maxLabel.text = [NSString stringWithFormat:@"Avg: XX"];
    maxLabel.textAlignment = NSTextAlignmentCenter;
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[weakSelf view]addSubview:minLabel];
        [[weakSelf view]addSubview:avgLabel];
        [[weakSelf view]addSubview:maxLabel];
    });
    
}


@end
