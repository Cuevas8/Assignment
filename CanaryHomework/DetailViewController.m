//
//  DetailViewController.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "DetailViewController.h"
#import "Reading+CoreDataClass.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"About: %@", self.device.name];
    

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self drawUI:[self calculateDeviceReadings:self.device.readings]];
}

#pragma Draw UI
-(void) drawUI: (NSDictionary *)deviceData {
    NSDictionary *tempData = deviceData[@"tempData"];
    NSDictionary *humidData = deviceData[@"humidData"];
    
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    //Temp Label
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 - 100, 100, 200, 50)];
    tempLabel.backgroundColor = [UIColor systemGrayColor];
    tempLabel.text = [NSString stringWithFormat:@"Temperature"];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    
    //Min Label
    UILabel *tempMinLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 100, 100)];
    tempMinLabel.backgroundColor = [UIColor systemRedColor];
    tempMinLabel.text = (tempData[@"min"]) ? [NSString stringWithFormat:@"Min: %@", tempData[@"min"]] : @"-";
    tempMinLabel.textAlignment = NSTextAlignmentCenter;
    
    //Avg Label
    UILabel *tempAvgLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 200, 100, 100)];
    tempAvgLabel.backgroundColor = [UIColor systemBlueColor];
    tempAvgLabel.text = (tempData[@"avg"]) ? [NSString stringWithFormat:@"Avg: %@", tempData[@"avg"]] : @"-";
    tempAvgLabel.textAlignment = NSTextAlignmentCenter;
    
    //Max Label
    UILabel *tempMaxLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 200, 100, 100)];
    tempMaxLabel.backgroundColor = [UIColor systemYellowColor];
    tempMaxLabel.text = (tempData[@"max"]) ? [NSString stringWithFormat:@"Max: %@", tempData[@"max"]] : @"-";
    tempMaxLabel.textAlignment = NSTextAlignmentCenter;
    
    //Humidity Label
    UILabel *humidLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 - 100, 400, 200, 50)];
    humidLabel.backgroundColor = [UIColor systemGrayColor];
    humidLabel.text = [NSString stringWithFormat:@"Humidity"];
    humidLabel.textAlignment = NSTextAlignmentCenter;
    
    //Min Label
    UILabel *humidMinLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 500, 100, 100)];
    humidMinLabel.backgroundColor = [UIColor systemRedColor];
    humidMinLabel.text = (humidData[@"min"]) ? [NSString stringWithFormat:@"Min: %@", humidData[@"min"]] : @"-";
    humidMinLabel.textAlignment = NSTextAlignmentCenter;
    
    //Avg Label
    UILabel *humidAvgLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 500, 100, 100)];
    humidAvgLabel.backgroundColor = [UIColor systemBlueColor];
    humidAvgLabel.text = (humidData[@"avg"]) ? [NSString stringWithFormat:@"Avg: %@", humidData[@"avg"]] : @"-";
    humidAvgLabel.textAlignment = NSTextAlignmentCenter;
    
    //Max Label
    UILabel *humidMaxLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 500, 100, 100)];
    humidMaxLabel.backgroundColor = [UIColor systemYellowColor];
    humidMaxLabel.text = (humidData[@"max"]) ? [NSString stringWithFormat:@"Max: %@", humidData[@"max"]] : @"-";
    humidMaxLabel.textAlignment = NSTextAlignmentCenter;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[weakSelf view]addSubview:tempLabel];
        [[weakSelf view]addSubview:tempMinLabel];
        [[weakSelf view]addSubview:tempAvgLabel];
        [[weakSelf view]addSubview:tempMaxLabel];
        
        [[weakSelf view]addSubview:humidLabel];
        [[weakSelf view]addSubview:humidMinLabel];
        [[weakSelf view]addSubview:humidAvgLabel];
        [[weakSelf view]addSubview:humidMaxLabel];
    });
}


-(NSDictionary *) calculateDeviceReadings:(NSSet *) readings {
    
    NSMutableDictionary *deviceReading = [NSMutableDictionary new];
    NSMutableArray *tempValues = [NSMutableArray new];
    NSMutableArray *humidValues = [NSMutableArray new];
    
    float tempTotal = 0.00;
    float humidTotal = 0.00;
    
    for (Reading *reading in readings) {
        if([reading.type isEqualToString:@"temperature"]) {
            [tempValues addObject:[NSNumber numberWithFloat:reading.value.floatValue]];
            tempTotal += reading.value.floatValue;
            
        } else if ([reading.type isEqualToString:@"humidity"]) {
            [humidValues addObject:[NSNumber numberWithFloat:reading.value.floatValue]];
            humidTotal += reading.value.floatValue;
        }
    }
    
    //Sort Values
    tempValues = [tempValues sortedArrayUsingSelector:@selector((compare:))].mutableCopy;
    humidValues = [humidValues sortedArrayUsingSelector:@selector((compare:))].mutableCopy;
    
    //Prep Data
    if (tempValues.count > 0) {
        [deviceReading setValue:@{@"min": tempValues.firstObject, @"max": tempValues.lastObject, @"avg": [NSNumber numberWithFloat:(tempTotal/tempValues.count)]} forKey:@"tempData"];
    }
    if (humidValues.count > 0) {
        [deviceReading setValue:@{@"min": humidValues.firstObject, @"max": humidValues.lastObject, @"avg": [NSNumber numberWithFloat:(humidTotal/humidValues.count)]} forKey:@"humidData"];
    }
    
    return deviceReading;
}


@end
