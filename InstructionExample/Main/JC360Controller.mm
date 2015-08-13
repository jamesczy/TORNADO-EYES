//
//  JC360Controller.m
//  InstructionExample
//
//  Created by jamesczy on 15/7/28.
//  Copyright (c) 2015年 im360 immersive. All rights reserved.
//

#import "JC360Controller.h"
#import "UIView+Extension.h"
#import "JCPlayPauseView.h"
//
//static BOOL isPortraitIn_;
//static BOOL isSettingStatusBar_;
@interface JC360Controller ()
- (void)playerInitialized:(id)sender;
@end

@implementation JC360Controller
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
    
    JC360Controller * owner;
};


- (void)viewDidLoad {
    [super viewDidLoad];
//    JCPlayPauseView *playPauseView = [[JCPlayPauseView alloc]init];
//    [playPauseView setBackgroundColor:[UIColor yellowColor]];
//    [self.view addSubview:playPauseView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    CGRect rect = self.view.frame;
    if( self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight )
    {
        
        _im360View = [[IM360View alloc] initWithFrame:rect];
//        NSLog(@"%lf ___%lf",rect.size.width,rect.size.height);
    }
    _im360View.im360ViewDelegate = self;
    
    [self.view addSubview:_im360View];
    
    [_im360View startAnimation];
    
}
//设置暂停和播放
- (void)setPlaybarBtnStates
{
//    NSLog(@"setPlaybarStates");
    if( !_player) return;
    
    scene::BasicScene::pointer scene = _player->getScene<scene::BasicScene>();
    if( !scene )
    {
//        _rewindBtn.enabled = NO;
//        _playBtn.enabled = NO;
        return;
    }
    
//    _rewindBtn.enabled = scene->getTime()>0;
    
    if( scene->getPaused() /*&& _playbar.items!=_playbarItemsPlay */)
    {
//        NSLog(@"setItems play,%d",scene->getPaused());
        scene->setPaused(NO);
        
//        [_playbar setItems:_playbarItemsPlay animated:NO];
    }
    else if( !scene->getPaused() /* && _playbar.items!=_playbarItemsPause */)
    {
//        NSLog(@"setItems pause");
        scene->setPaused(YES);
//        [_playbar setItems:_playbarItemsPause animated:NO];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
    [_im360View stopAnimation];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            
            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"触摸界面");
    //控制导航栏的显示和隐藏
    if ([self navigationController].navigationBarHidden) {
        [[self navigationController]setNavigationBarHidden:NO animated:YES];
    }else{
        [[self navigationController]setNavigationBarHidden:YES animated:YES];
    }
    [self setPlaybarBtnStates];
    
}


- (void)playerInitialized:(id)sender
{
    NSLog(@"playerInitialized");
    _player = _im360View.player;
    [_im360View setOrientation:UIInterfaceOrientationLandscapeRight];
    im360::scene::BasicScene::pointer scene = _player->getScene<im360::scene::BasicScene>();
    std::string videoURL = [[[NSBundle mainBundle]pathForResource:@"Aquarium.Of.The.Bay_10973_1280x506_f12_2M_a0.webm" ofType:nil]UTF8String];
    std::string audeoURL = [[[NSBundle mainBundle]pathForResource:@"Aquarium.Of.The.Bay.mp3" ofType:nil]UTF8String];

//    std::string videoURL1 = [@"http://v.youku.com/v_show/id_XMTMwNzMzMzUwOA==.html?from=y1.3-sports-test1-126-20290.201479-201480.2-1" UTF8String];
//    std::string videoURL = [[[NSBundle mainBundle]pathForResource:@"Bay.Bridge.Flying.Pass.2_11031_1280x506_f12_2M_a0.webm" ofType:nil]UTF8String];
//    std::string audeoURL = [[[NSBundle mainBundle]pathForResource:@"Bay.Bridge.Flying.Pass.2.mp3" ofType:nil]UTF8String];
    scene->resetScene();
    scene->loadVideo(videoURL,audeoURL);
    scene->setLoopEnabled(FALSE);
    //不让手机锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}



#define MEDIADATA (*((MediaData*)_mediaData))

- (void)onMediaPlayStateChange:(im360::event::MediaEvent::pointer)event
{
    if (event->getEventId() == event->MEDIA_LOADED){
        // Media has loaded fully
        NSLog(@"MEDIA_LOADED");
    }
    if (event->getEventId() == event->MEDIA_ENDED){
        // Media has ended. For example, the video has played all the way through.
        NSLog(@"media ended");
    }
}
- (void)onMediaTimeChange:(im360::event::TimeChangeEvent::pointer)event
{
    
    if (!_player) return;
    
    im360::scene::BasicScene::pointer scene = _player->getScene<im360::scene::BasicScene>();
    if( !scene ) return;
    
    // Percent of video played
    
    //float percent =  event->time / scene->getDuration() ;
    // Can be used to update a playbar timeline
    //NSLog([NSString stringWithFormat:@"%1.6f", percent]);
    //_progressTrack.value = percent;
    
    
}
@end
