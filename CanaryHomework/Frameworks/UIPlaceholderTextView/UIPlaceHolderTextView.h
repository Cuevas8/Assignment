//
//  UIPlaceHolderTextView.h
//  Canary V4
//
//  Created by Michael Klein on 5/2/14.
//  Copyright (c) 2014 Michael Klein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
