# CannaryHomework


# How To Run
Open project folder and double click "CanaryHomework.xcodeproj". Project will load in xCode, select simulator and run project with Command+R.

# Issue, Issue Explanation, Solution
Issue: <strong>Device Names not loading on ViewController</strong><br>
Issue Explanation: The first issue was that the device names weren't loading into the dataSource of the tableView.<br>
Solution: Created a function called "getDeviceData" that would grab all devices from coreData and store them in a property called "devices". "devices" was used to set the # of rows and data source for setting the name of the cellForRow.
```Objective-C
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
            [self displayAlertErrorLoadingDevices];
        }
    }];
}
```

Issue: <strong>Entity invalid for Device</strong><br>
Issue Explanation: Invalid entity when inserting entity into coreData for device. <br>
Solution: Added validation for entities (Reading & Device) before saving to coreData context property.
```Objective-C
-(NSArray *) validateEntity:(NSArray *) objectsDictionary {
    NSMutableArray *validEntityObjects = [NSMutableArray new];
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterNoStyle;
    
    for (NSDictionary *entity in objectsDictionary) {
        NSMutableDictionary *validEntityObject = [NSMutableDictionary new];
        
        for(NSString *key in entity) {
            if([key isEqualToString:@"value"]) {
                [validEntityObject setValue:[numberFormatter numberFromString:[NSString stringWithFormat:@"%@",entity[key]]] forKey:[NSString stringWithFormat:@"%@",key]];
            } else {
                [validEntityObject setValue:[NSString stringWithFormat:@"%@",entity[key]] forKey:[NSString stringWithFormat:@"%@",key]];
            }
        }
        [validEntityObjects addObject:validEntityObject];
    }
    return validEntityObjects;
}
```

Issue: <strong>Not Returning Device Readings</strong><br>
Issue Explanation: When calling "getReadingsForDevice" from CoreDataController there would not be readings loaded for the device. <br>
Solution: Checked "getReadingsForDevice" definition and it was missing completionBlock to return readings.
```Objective-C
-(void)getReadingsForDevice:(NSString *)deviceID completionBlock:(CoreDataControllerCompletionBlock)completionBlock {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.reloadQueue, ^ {
        [[APIClient sharedClient] getDevice:deviceID readingsWithCompletionBlock:^(BOOL success, id responseObject) {
            if (success) {
                Device *device = [Device deviceWithID:deviceID managedObjectContext:self.privateObjectContext createIfNeeded:YES];
                [device removeReadings:device.readings];
                [weakSelf insertObjectsWithDictionaries:responseObject withCreationBlock:^NSManagedObject *(NSDictionary *dictionary, NSManagedObjectContext *insertContext) {
                    return [Reading readingFromDictionary:dictionary forDevice:deviceID managedObjectContext:insertContext];

                } completionBlock:^(NSArray *objects, NSError *error) {
                    completionBlock(true, true, objects); // <-- Added
                }];
            }
        }];
    });
}
```

# DetailViewController
Once a device was selected in ViewController it would bring the DetailViewController. Layout was built programatically rather than using storyboards since I find it easier to use constraints programatically rather than in storyboard, also because viewController was built programtically. Created "renderUI" function to layout the appearance of the view and to set the constraints.

Once I had the labels displaying I created a function called "calculateDeviceReadings" that was used to calculate the min, avg, and max of the readings of the device.  Stored calculated device readings  based on type (temperature, humidity) in a NSDictionary that would then be returned. 
```Objective-C
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
```

# CannaryHomeworkTests
```Objective-C
//Test for getting all devices from API
-(void) testAPIGetAllDevice {
    TestNeedsToWaitForBlock();
    [[APIClient sharedClient] getDeviceWithCompletionBlock:^(BOOL success, id responseObject) {
        XCTAssertTrue(success);
        XCTAssertNotNil(responseObject);
        
        BlockFinished();
    }];
    WaitForBlock();
}
//Test for getting all readings from a device from API
-(void) testAPIGetDeviceReadings {
    TestNeedsToWaitForBlock();
    [[APIClient sharedClient] getDevice:@"2" readingsWithCompletionBlock:^(BOOL success, id responseObject) {
        XCTAssertTrue(success);
        XCTAssertNotNil(responseObject);
        BlockFinished();
    }];
    WaitForBlock();
}

//Test for getting device from CoreDataController
-(void) testCoreDataControllerGetDevices{
    TestNeedsToWaitForBlock();
    [[CoreDataController sharedCache] getAllDevices:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        XCTAssertTrue(success);
        XCTAssertTrue(completed);
        XCTAssertTrue(objects.count > 0);
        BlockFinished();
    }];
    WaitForBlock();
}
//Test for getting device readings
-(void) testCoreDataGetDeviceReadings{
    TestNeedsToWaitForBlock();
    [[CoreDataController sharedCache] getReadingsForDevice:@"2" completionBlock:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        XCTAssertTrue(success);
        XCTAssertTrue(completed);
        XCTAssertTrue(objects.count > 0);
        BlockFinished();
    }];
    WaitForBlock();
}
```



