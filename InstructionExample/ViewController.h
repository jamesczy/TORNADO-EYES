//
//  ViewController.h
//  InstructionExample
//
//  Created by im360 immersive on 8/27/13.
//  Copyright (c) 2013 im360 immersive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <im360/im360.h>
#import "TouchFilterUIView.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController<IM360ViewDelegate> {
    IM360View *                     _im360View;
    im360::player::Player::pointer  _imPlayer;
    
    // objective-c <-> c++ support
    void *                          _mediaData;
    
    UIView *                        _nonRotatingView;
        
    //Playbar
    UIToolbar *                     _playbar;
	UIBarButtonItem *               _rewindBtn;
	UIBarButtonItem *               _playBtn;
	UIBarButtonItem *               _pauseBtn;
	UIBarButtonItem *               _progressTrackItem;
	UISlider *                      _progressTrack;
	NSArray *                       _playbarItemsPlay;
	NSArray *                       _playbarItemsPause;
    NSTimer *                       _progressTimer;
    BOOL                            _sliding;

    
}
// Methods to gracefully stop/start player if app is minimized/maximized
- (void) willResign;
- (void) willAWake;

// Player media events
- (void)onMediaPlayStateChange:(im360::event::MediaEvent::pointer)event;
- (void)onMediaTimeChange:(im360::event::TimeChangeEvent::pointer)event;

// play bar
@property (nonatomic, retain) IBOutlet UIToolbar * _playbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * _rewindBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * _playBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * _pauseBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * _progressTrackItem;
@property (nonatomic, retain) IBOutlet UISlider * _progressTrack;
//@property (nonatomic, retain) IBOutlet UINavigationBar * _navBar;

@property (nonatomic, retain) NSString * currentSourceId;


// playbar button pushes.
- (IBAction)playPausedPushed:(id)sender;
- (IBAction)rewindPushed:(id)sender;
- (IBAction)progressStart:(id)sender;
- (IBAction)progressEnd:(id)sender;

@end

