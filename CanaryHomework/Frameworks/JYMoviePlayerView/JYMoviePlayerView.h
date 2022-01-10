//
//  JYMoviePlayerView.h
//  JYMoviePlayer
//
//  Created by Junaid on 04/04/2014.
//  Copyright (c) 2014 Junaid Younus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AVQueuePlayerPrevious.h"

@interface JYMoviePlayerView : UIView

@property (nonatomic, weak) AVQueuePlayerPrevious *player;
- (NSTimeInterval) playableDuration;
- (void) resetLoadingView;
@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UIActivityIndicatorView *videoLoadingActivityIndicator;

@end
