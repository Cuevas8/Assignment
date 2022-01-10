//
//  RMSyslogFormatter.m
//  Pods
//
//  Created by Malayil Philip George on 5/7/14.
//  Copyright (c) 2014 Rogue Monkey Technologies & Systems Private Limited. All rights reserved.
//
//

#import "RMSyslogFormatter.h"
#import "User.h"

static NSString * const RMAppUUIDKey = @"RMAppUUIDKey";

@implementation RMSyslogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    User *user = [User sharedUser];
    NSString *msg = logMessage->logMsg;
    
    NSString *logLevel;
    switch (logMessage->logFlag)
    {
        case LOG_FLAG_ERROR     : logLevel = @"11"; break;
        case LOG_FLAG_WARN      : logLevel = @"12"; break;
        case LOG_FLAG_INFO      : logLevel = @"14"; break;
        case LOG_FLAG_DEBUG     : logLevel = @"15"; break;
        case LOG_FLAG_VERBOSE   : logLevel = @"15" ; break;
        default                 : logLevel = @"15"; break;
    }
    
    //Also display the file the logging occurred in to ease later debugging
    NSString *file = [[[NSString stringWithUTF8String:logMessage->file] lastPathComponent] stringByDeletingPathExtension];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:logMessage->timestamp];
    
    NSString *machineName;
    if (user.email) {
        machineName = user.email;
    }
    else    {
        //Get vendor id
        machineName = [self machineName];
    }
    
    
    //Get program name
    NSString *programName = [NSString stringWithFormat:@"%@_%@", [self programName], [self stringForAppType]];
    
    NSString *log = [NSString stringWithFormat:@"<%@>%@ %@ %@: %x %@@%s@%i \"%@\"", logLevel, timestamp, machineName, programName, logMessage->machThreadID, file, logMessage->function, logMessage->lineNumber, msg];
    
    return log;
}

- (NSString *)stringForAppType {
#if defined(CYMainApplication)
    return @"main_app";
#elif defined(CYWidgetApplication)
    return @"widget";
#elif defined(CYWatchApplication)
    return @"watch";
#elif defined(CYTVApplication)
    return @"tv_app";
#else
    return @"notification";
#endif
}

-(NSString *) machineName
{
    //We will generate and use a app-specific UUID to maintain user privacy.
    NSString *uuid = [[NSUserDefaults standardUserDefaults] stringForKey:RMAppUUIDKey];
    if (uuid == nil) {
        uuid = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:RMAppUUIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return uuid;
}

-(NSString *) programName
{
    NSString *programName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (programName == nil) {
        programName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    
    //Remove all whitespace characters from appname
    if (programName != nil) {
        NSArray *components = [programName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        programName = [components componentsJoinedByString:@""];
    }
    
    return programName;
}

@end
