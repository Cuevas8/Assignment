//
//  JYMoviePlayerView.m
//  JYMoviePlayer
//
//  Created by Junaid on 04/04/2014.
//  Copyright (c) 2014 Junaid Younus. All rights reserved.
//

#import "JYMoviePlayerView.h"

@implementation JYMoviePlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(Class)layerClass
{
    return [AVPlayerLayer class]; // UIView will instantiate AVPlayerLayer
}

-(AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

-(void)setPlayer:(AVPlayer *)player
{
    [self generateLoadingView];
    
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (NSTimeInterval) playableDuration
{
    //  use loadedTimeRanges to compute playableDuration.
    AVPlayerItem * item = self.player.currentItem;
    
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        NSArray * timeRangeArray = item.loadedTimeRanges;
        
        CMTimeRange aTimeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        
        double startTime = CMTimeGetSeconds(aTimeRange.start);
        double loadedDuration = CMTimeGetSeconds(aTimeRange.duration);
        
        // FIXME: shoule we sum up all sections to have a total playable duration,
        // or we just use first section as whole?
        
        DLog(@"get time range, its start is %f seconds, its duration is %f seconds.", startTime, loadedDuration);
        
        
        return (NSTimeInterval)(startTime + loadedDuration);
    }
    else
    {
        return(CMTimeGetSeconds(kCMTimeInvalid));
    }
}

- (void) generateLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.loadingView.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1];
    [self insertSubview:self.loadingView atIndex:0];
    
    self.videoLoadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.videoLoadingActivityIndicator.center = self.loadingView.center;
    self.videoLoadingActivityIndicator.color = [UIColor blackColor];
    [self.loadingView addSubview:self.videoLoadingActivityIndicator];
    [self.videoLoadingActivityIndicator startAnimating];
    
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)[self.layer.sublayers lastObject];
    playerLayer.hidden = YES;
}

- (void)resetLoadingView {
    self.loadingView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.videoLoadingActivityIndicator.center = self.loadingView.center;
}

@end
