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
    [self renderUI:[self calculateDeviceReadings:self.device.readings]];
}

#pragma Draw UI
-(void) renderUI: (NSDictionary *)deviceData {
    NSDictionary *tempData = deviceData[@"tempData"];
    NSDictionary *humidData = deviceData[@"humidData"];
    
    CGFloat padding = 10.00;
    
    //Temperature Label
    UILabel *tempLabel = [UILabel new];
    tempLabel.backgroundColor = [UIColor systemGrayColor];
    tempLabel.text = [NSString stringWithFormat:@"Temperature"];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [[self view]addSubview:tempLabel];

    [[tempLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor]setActive:true];
    [[tempLabel.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor]setActive:true];
    [[tempLabel.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor]setActive:true];
    [[tempLabel.heightAnchor constraintEqualToConstant:50]setActive:true];
    
    //Temp Min Label
    UILabel *tempMinLabel = [UILabel new];
    tempMinLabel.backgroundColor = [UIColor systemRedColor];
    tempMinLabel.text = (tempData[@"min"]) ? [NSString stringWithFormat:@"Min: %@", tempData[@"min"]] : @"-";
    tempMinLabel.textAlignment = NSTextAlignmentCenter;
    tempMinLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [[self view]addSubview:tempMinLabel];
    
    [[tempMinLabel.topAnchor constraintEqualToAnchor:tempLabel.bottomAnchor constant:padding]setActive:true];
    [[tempMinLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]setActive:true];
    [[tempMinLabel.widthAnchor constraintEqualToConstant:200]setActive:true];
    [[tempMinLabel.heightAnchor constraintEqualToConstant:50]setActive:true];
  
    //Temp Avg Label
    UILabel *tempAvgLabel = [UILabel new];
    tempAvgLabel.backgroundColor = [UIColor systemBlueColor];
    tempAvgLabel.text = (tempData[@"avg"]) ? [NSString stringWithFormat:@"Avg: %@", tempData[@"avg"]] : @"-";
    tempAvgLabel.textAlignment = NSTextAlignmentCenter;
    tempAvgLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [[self view] addSubview:tempAvgLabel];
    
    [[tempAvgLabel.topAnchor constraintEqualToAnchor:tempMinLabel.bottomAnchor constant:padding]setActive:true];
    [[tempAvgLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]setActive:true];
    [[tempAvgLabel.widthAnchor constraintEqualToConstant:200]setActive:true];
    [[tempAvgLabel.heightAnchor constraintEqualToConstant:50]setActive:true];
    
    //Temp Max Label
    UILabel *tempMaxLabel = [UILabel new];
    tempMaxLabel.backgroundColor = [UIColor systemYellowColor];
    tempMaxLabel.text = (tempData[@"max"]) ? [NSString stringWithFormat:@"Max: %@", tempData[@"max"]] : @"-";
    tempMaxLabel.textAlignment = NSTextAlignmentCenter;
    tempMaxLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [[self view] addSubview:tempMaxLabel];
    
    [[tempMaxLabel.topAnchor constraintEqualToAnchor:tempAvgLabel.bottomAnchor constant:padding]setActive:true];
    [[tempMaxLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]setActive:true];
    [[tempMaxLabel.widthAnchor constraintEqualToConstant:200]setActive:true];
    [[tempMaxLabel.heightAnchor constraintEqualToConstant:50]setActive:true];
    
    //Humidity Label
    UILabel *humidLabel = [UILabel new];
    humidLabel.backgroundColor = [UIColor systemGrayColor];
    humidLabel.text = [NSString stringWithFormat:@"Humidity"];
    humidLabel.textAlignment = NSTextAlignmentCenter;
    humidLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [[self view]addSubview:humidLabel];

    [[humidLabel.topAnchor constraintEqualToAnchor:tempMaxLabel.bottomAnchor constant:padding]setActive:true];
    [[humidLabel.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor]setActive:true];
    [[humidLabel.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor]setActive:true];
    [[humidLabel.heightAnchor constraintEqualToConstant:50]setActive:true];

    //Humidity Min Label
    UILabel *humidMinLabel = [UILabel new];
    humidMinLabel.backgroundColor = [UIColor systemRedColor];
    humidMinLabel.text = (humidData[@"min"]) ? [NSString stringWithFormat:@"Min: %@", humidData[@"min"]] : @"-";
    humidMinLabel.textAlignment = NSTextAlignmentCenter;
    humidMinLabel.translatesAutoresizingMaskIntoConstraints = false;
    [[self view] addSubview:humidMinLabel];
    
    [[humidMinLabel.topAnchor constraintEqualToAnchor:humidLabel.bottomAnchor constant:padding]setActive:true];
    [[humidMinLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]setActive:true];
    [[humidMinLabel.widthAnchor constraintEqualToConstant:200]setActive:true];
    [[humidMinLabel.heightAnchor constraintEqualToConstant:50]setActive:true];
    
    //Humidity Avg Label
    UILabel *humidAvgLabel = [UILabel new];
    humidAvgLabel.backgroundColor = [UIColor systemBlueColor];
    humidAvgLabel.text = (humidData[@"avg"]) ? [NSString stringWithFormat:@"Avg: %@", humidData[@"avg"]] : @"-";
    humidAvgLabel.textAlignment = NSTextAlignmentCenter;
    humidAvgLabel.translatesAutoresizingMaskIntoConstraints = false;
    [[self view] addSubview:humidAvgLabel];
    
    [[humidAvgLabel.topAnchor constraintEqualToAnchor:humidMinLabel.bottomAnchor constant:padding]setActive:true];
    [[humidAvgLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]setActive:true];
    [[humidAvgLabel.widthAnchor constraintEqualToConstant:200]setActive:true];
    [[humidAvgLabel.heightAnchor constraintEqualToConstant:50]setActive:true];
    
    //Humidity Max Label
    UILabel *humidMaxLabel = [UILabel new];
    humidMaxLabel.backgroundColor = [UIColor systemYellowColor];
    humidMaxLabel.text = (humidData[@"max"]) ? [NSString stringWithFormat:@"Max: %@", humidData[@"max"]] : @"-";
    humidMaxLabel.textAlignment = NSTextAlignmentCenter;
    humidMaxLabel.translatesAutoresizingMaskIntoConstraints = false;
    [[self view] addSubview:humidMaxLabel];
    
    [[humidMaxLabel.topAnchor constraintEqualToAnchor:humidAvgLabel.bottomAnchor constant:padding]setActive:true];
    [[humidMaxLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]setActive:true];
    [[humidMaxLabel.widthAnchor constraintEqualToConstant:200]setActive:true];
    [[humidMaxLabel.heightAnchor constraintEqualToConstant:50]setActive:true];
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
