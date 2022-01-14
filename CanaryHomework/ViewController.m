//
//  ViewController.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/19/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "CoreDataController.h"
#import "Device+CoreDataProperties.h"

@interface ViewController ()

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UILayoutGuide *safeArea;
@property(nonatomic, retain) NSArray *devices;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Devices";
    // Do any additional setup after loading the view.
    [self getDeviceData];
    self.safeArea = self.view.layoutMarginsGuide;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [UITableView new];
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.tableView];
    [[self.tableView.topAnchor constraintEqualToAnchor:self.safeArea.topAnchor] setActive:true];
    [[self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:true];
    [[self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:true];
    [[self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:true];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableView Data Source

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *device = [self.devices objectAtIndex:indexPath.row];
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[device valueForKey:@"name"]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}

#pragma mark UITableView Delegate 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *dc = [DetailViewController new];
    dc.device = [self.devices objectAtIndex:indexPath.row];
    
    [[CoreDataController sharedCache] getReadingsForDevice:dc.device.deviceID completionBlock:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController pushViewController:dc animated:YES];
            });
        } else {
            NSLog(@"Error getting device readings");
        }
    }];
}

#pragma  mark Get Device Data

-(void) getDeviceData {
    __weak typeof(self) weakSelf = self;
    [[CoreDataController sharedCache]getAllDevices:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        
        if (success == true) {
            weakSelf.devices = objects;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
            
        } else {
            NSLog(@"Error: Could not retrieve device data");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Error loading data" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *tryLoadingData = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf getDeviceData];
                }];
                [alert addAction:tryLoadingData];
                [weakSelf presentViewController:alert animated:true completion:nil];
            });
        }
    }];
}

@end
