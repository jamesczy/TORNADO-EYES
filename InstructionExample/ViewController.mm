//
//  ViewController.mm
//
//  The im360 player contains custom orientation code,
//  which makes the 360 video render correctly based
//  on device orientation.
//
//  Because of this, we wish to disable the default
//  iOS orientation behavior on the im360 player view,
//  yet enable it for all other views.
//  This example demonstrates a method to achieve this.
//
//  We use two UIViews in the same window, and at the same
//  level. The 'front' UIView will not pass touch input
//  to the 'behind' UIView, even if the touch occurs in
//  an 'empty' are of the front view.
//
//  The TouchFilterUIView class makes the front view pass
//  touch input to the back view, if the touch did not hit
//  any elements of the front view.
//
//  ======================================================
//  ======= IMPORTANT ====================================
//  ======================================================
//
//  Please ensure that the 'View' in both *.storyboard
//  files is set to use the 'TouchFilterUIView' class.
//
//  ======================================================
//
//  Created by im360 immersive on 8/13/13.
//  Copyright (c) 2013 im360 immersive. All rights reserved.
//

#import "ViewController.h"


@interface ViewController (Private)
- (void)playerInitialized:(id)sender;


@end

@implementation ViewController

@synthesize _playbar;
@synthesize _rewindBtn;
@synthesize _playBtn;
@synthesize _pauseBtn;
@synthesize _progressTrack;
@synthesize _progressTrackItem;
//@synthesize _navBar;

class PlayerProxy : public im360::event::EventListener   //EventListener
{
public:
    typedef core::SharedPointer<PlayerProxy>::pointer pointer;
    
    PlayerProxy() : EventListener()
    {
        
    }
    
    virtual ~PlayerProxy()
    {
        
    }
    
    void onEvent(event::Event::pointer event)
    {
        if( event->getPointer<im360::event::MediaEvent>() ) [owner onMediaPlayStateChange:event->getPointer<im360::event::MediaEvent>()];
        else if( event->getPointer<im360::event::TimeChangeEvent>() ) [owner onMediaTimeChange:event->getPointer<im360::event::TimeChangeEvent>()];
    }
    
    ViewController * owner;
};

class MediaData
{
public:
    MediaData()
    {
        playerProxy = PlayerProxy::pointer(new PlayerProxy());
    }
    
    PlayerProxy::pointer playerProxy;
    
};

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"别摸我ok？");
    if ([self navigationController].navigationBarHidden) {
        
        [[self navigationController]setNavigationBarHidden:YES animated:YES];
    }else{
        [[self navigationController]setNavigationBarHidden:NO animated:YES];
    }
    
//    [self popoverPresentationController];
}

#define MEDIADATA (*((MediaData*)_mediaData))

- (void)onMediaPlayStateChange:(im360::event::MediaEvent::pointer)event
{
    if (event->getEventId() == event->MEDIA_LOADED){
        // Media has loaded fully
        
    }
    if (event->getEventId() == event->MEDIA_ENDED){
        // Media has ended. For example, the video has played all the way through.
        NSLog(@"media ended");
    }
}
- (void)onMediaTimeChange:(im360::event::TimeChangeEvent::pointer)event
{
    
    if (!_imPlayer) return;
    
    im360::scene::BasicScene::pointer scene = _imPlayer->getScene<im360::scene::BasicScene>();
    if( !scene ) return;
    
    // Percent of video played
    
    //float percent =  event->time / scene->getDuration() ;
    // Can be used to update a playbar timeline
    //NSLog([NSString stringWithFormat:@"%1.6f", percent]);
    //_progressTrack.value = percent;
    
    
}


- (void)playerInitialized:(id)sender
{
    _imPlayer = _im360View.player;
    player::Player::installLicense("yingyi");
    im360::scene::BasicScene::pointer scene = _imPlayer->getScene<scene::BasicScene>();
    if( !scene ) return;
    
    scene->setLoopEnabled(true);
    
    _mediaData = new MediaData();
    MEDIADATA.playerProxy->owner = self;
    _imPlayer->addEventListener(MEDIADATA.playerProxy);
    
    _imPlayer = _im360View.player;
    std::string videoUrl = [[[NSBundle mainBundle] pathForResource:@"Aquarium.Of.The.Bay_10973_1280x506_f12_2M_a0.webm" ofType:nil] UTF8String];
    std::string audioUrl = [[[NSBundle mainBundle] pathForResource:@"Aquarium.Of.The.Bay.mp3" ofType:nil] UTF8String];
    
    scene->loadVideo(videoUrl, audioUrl);
    scene->setLoopEnabled(true);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view, typically from a nib.
    
    // setup play bar defaults
	_progressTrack.minimumValue = 0;
	_progressTrack.maximumValue = 1.0f;
	_progressTrack.value = 0;
    
	_playbarItemsPlay = [NSArray arrayWithObjects:_rewindBtn,_playBtn,_progressTrackItem,nil] ;
	_playbarItemsPause = [NSArray arrayWithObjects:_rewindBtn,_pauseBtn,_progressTrackItem,nil];
	
	[_playbar setItems:_playbarItemsPause animated:NO];
    

}
// Methods to gracefully stop/start player if app is minimized/maximized
- (void) willResign
{
    NSLog(@"willResign");
    if (_im360View){
        [_im360View stopAnimation];
        [_im360View removeFromSuperview];
        [_im360View cleanup];
        //[_im360View release]; Only if not using ARC
        _im360View = nil;
    }
    _imPlayer = im360::player::Player::pointer();
    im360::event::EventManager::instance().dispatchEvents(); // empty the event queue
    [self stopProgressTimer];
}
- (void) willAWake
{
    NSLog(@"%s",__FUNCTION__);
    [self create360];
    [_playbar setItems:_playbarItemsPause animated:NO];
}


- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s",__FUNCTION__);
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    // the view you don't want rotated (there could be a heierarchy of views here):
    _nonRotatingView = [[UIView alloc] initWithFrame:self.view.frame];
    _nonRotatingView.backgroundColor = [UIColor blackColor];
    // make sure self.view and its children are transparent so you can see through to this view that will not be rotated behind self.view.
    self.view.backgroundColor = [UIColor clearColor];
    [delegate.window insertSubview:_nonRotatingView  belowSubview:self.view];
    
    [self create360];
    
}
- (void) create360
{
    NSLog(@"%s",__FUNCTION__);
//    CGRect rect = self.view.frame;
    CGRect rect = [UIScreen mainScreen].bounds;
    if( self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight )
    {
//        float t = rect.size.width;
//        rect.size.width = rect.size.height;
//        rect.size.height = t;
        
    }
    
//    rect.origin.x = 0;
    // Create the im360 view.
//    CGRect marblerect = self.view.frame;
    
    rect.origin.x = 0;
    _im360View = [[IM360View alloc] initWithFrame:rect];
    _im360View.im360ViewDelegate = self;
    _im360View.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//    TouchFilterUIView * filterView = (TouchFilterUIView*)self.view;
//    filterView.im360View = _im360View;
    [_im360View setUserInteractionEnabled:YES];
    [_nonRotatingView insertSubview:_im360View atIndex:0];
    [_im360View startAnimation];
    [self startProgressTimer];

}
// Playbar

- (void)setPlaybarBtnStates
{
    NSLog(@"setPlaybarStates");
    if( !_imPlayer) return;
    
    scene::BasicScene::pointer scene = _imPlayer->getScene<scene::BasicScene>();
	if( !scene )
	{
		_rewindBtn.enabled = NO;
		_playBtn.enabled = NO;
		return;
	}
	
	_rewindBtn.enabled = scene->getTime()>0;
    
	if( scene->getPaused() && _playbar.items!=_playbarItemsPlay )
	{
        NSLog(@"setItems play");
		[_playbar setItems:_playbarItemsPlay animated:NO];
	}
	else if( !scene->getPaused() && _playbar.items!=_playbarItemsPause )
	{
        NSLog(@"setItems pause");
		[_playbar setItems:_playbarItemsPause animated:NO];
	}
	
}

- (void)startProgressTimer
{
    NSLog(@"startProgressTimer");
	if( _progressTimer ) return; // its already started.
	
	// start timer to update progress bar
	_progressTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 3.0)) target:self selector:@selector(updateProgress:) userInfo:nil repeats:TRUE];
}

- (void)stopProgressTimer
{
	if( !_progressTimer ) return; // its already stopped.
    
	[_progressTimer invalidate];
	_progressTimer = nil;
}

- (void)updateProgress:(id)sender
{
    //NSLog(@"updateProgress");
    if( !_imPlayer ) return;
    
    scene::BasicScene::pointer scene = _imPlayer->getScene<scene::BasicScene>();
    
	if( !scene || scene->getDuration()<=0 ) return;
    
    float time = scene->getTime();
    float duration = scene->getDuration();
    //NSLog(@"updateProgress time:%f",time);
    
	_progressTrack.value = time / duration;
	_rewindBtn.enabled = time>0;
    if( time>=duration )
        [self setPlaybarBtnStates];
    
//    _timeLabel.text = [NSString stringWithFormat:@"%0.02f / %0.02f", time, duration];
    
}

- (IBAction)progressStart:(id)sender
{
    _sliding = true;
    [self stopProgressTimer];
    
	
}

- (IBAction)progressEnd:(id)sender
{
    
    if( !_imPlayer ) return;
    
    scene::BasicScene::pointer scene = _imPlayer->getScene<scene::BasicScene>();
	if( !scene ) return;
    
	scene->setTime( _progressTrack.value * scene->getDuration() );
    [self startProgressTimer];
    
}

- (IBAction)playPausedPushed:(id)sender
{
    if( !_imPlayer ) return;
    
    scene::BasicScene::pointer scene = _imPlayer->getScene<scene::BasicScene>();
	if( !scene ) return;
    
	scene->setPaused(!scene->getPaused());
	[self setPlaybarBtnStates];
}


- (IBAction)rewindPushed:(id)sender
{
    if( !_imPlayer ) return;
    
    scene::BasicScene::pointer scene = _imPlayer->getScene<scene::BasicScene>();
	if( !scene ) return;
    
	scene->setTime(0);
}


// ----------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s",__FUNCTION__);
    if (_im360View){
        [_im360View stopAnimation];
        [_im360View removeFromSuperview];
        [_im360View cleanup];
        //[_im360View release]; Only if not using ARC
        _im360View = nil;
    }
    _imPlayer = im360::player::Player::pointer();
    im360::event::EventManager::instance().dispatchEvents(); // empty the event queue
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

@end
