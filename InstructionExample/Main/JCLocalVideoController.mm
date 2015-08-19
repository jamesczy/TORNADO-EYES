//
//  JCLocalVideoController.m
//  TORNADO EYES
//
//  Created by yingyi on 15/8/18.
//  Copyright (c) 2015年 im360 immersive. All rights reserved.
//

#import "JCLocalVideoController.h"
#import "UIView+Extension.h"
#import "JCPlayPauseView.h"
#import "JCMideoModeView.h"

@interface JCLocalVideoController () <JCPlayPauseViewDelegate>
@property (nonatomic ,weak)JCPlayPauseView *toolbar;
@property (nonatomic ,weak)UISegmentedControl *segmentView;
@property (nonatomic ,weak)JCMideoModeView *modeView;
- (void)playerInitialized:(id)sender;
@end

@implementation JCLocalVideoController

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
    
    JCLocalVideoController* owner;
};
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setnavUp];
    
    [self setupToolbar];
    
    [self setupLookMode];
}
-(void)setnavUp
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"模式" style:UIBarButtonItemStyleDone target:self action:@selector(tabarIsHidden)];
    UISegmentedControl *segmentView = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [segmentView insertSegmentWithTitle:@"MOTION" atIndex:0 animated:YES];
    [segmentView insertSegmentWithTitle:@"FINGER" atIndex:1 animated:YES];
//    segmentView.backgroundColor = [UIColor redColor];
    segmentView.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentView;
    self.segmentView = segmentView;
    [segmentView addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventValueChanged];
  
}
-(void)controlPressed
{
    if( !_player) return;
    scene::BasicScene::pointer scene = _player->getScene<scene::BasicScene>();
    if( !scene )
    {
        NSLog(@"!scene");
        return;
    }
    int selecteIndex = self.segmentView.selectedSegmentIndex;
    if (selecteIndex == 0) {

        scene->setLookFlags(im360::scene::BasicScene::LM_FINGER | im360::scene::BasicScene::LM_GRAVITY | im360::scene::BasicScene::LM_MOTION);
//        NSLog(@"LM_MOTION");
    }else{
        scene->setLookFlags(im360::scene::BasicScene::LM_FINGER);
//        NSLog(@"LM_FINGER");
    }
    NSLog(@"LookFlags %d",scene->getLookFlags());
}

-(void)setupLookMode
{

    JCMideoModeView *modeView = [[JCMideoModeView alloc]init];
    modeView.height = 45;
    modeView.width= self.view.width;
    modeView.x = 0;
    modeView.y = self.view.height - modeView.height;
    [self.view addSubview:modeView];
    modeView.hidden = YES;
    self.modeView = modeView;
    
}
-(void)tabarIsHidden
{
//    self.toolbar.hidden = !self.toolbar.isHidden;
    self.modeView.hidden = !self.modeView.isHidden;
}
/**
     enum LookMode
     {
     LM_FINGER = 1,          // (mutualy exclusive with LM_HOLD_AND_DRAG)
     LM_GRAVITY = 2,
     LM_MOTION = 4,
     LM_HOLD_AND_DRAG = 8    // (mutualy exclusive with LM_FINGER)
     };
     
     void setLookFlags(int flags);
     int getLookFlags();
     void resetMotionData();
     
 */
-(void)setupToolbar
{
    NSLog(@"setupToolbar");
    JCPlayPauseView *toolbar = [[JCPlayPauseView alloc]init ];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.x = 0;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}
-(void)cancel
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    CGRect rect = self.view.frame;
    if( self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight )
    {
        
        _im360View = [[IM360View alloc] initWithFrame:rect];
        //        NSLog(@"%lf ___%lf",rect.size.width,rect.size.height);
    }else{
        CGFloat im360ViewY = self.view.size.height * 0.25 ;
        _im360View = [[IM360View alloc] initWithFrame:CGRectMake(self.view.origin.x, im360ViewY, self.view.size.width, self.view.size.height * 0.5)];
    }
    _im360View.im360ViewDelegate = self;
    
    [self.view addSubview:_im360View];
    
    [_im360View startAnimation];
    
}
//设置暂停和播放
- (void)setPlaybarBtnStates
{
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
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            
            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //控制导航栏的显示和隐藏
    /**
    if ([self navigationController].navigationBarHidden) {//显示
        [[self navigationController]setNavigationBarHidden:NO animated:YES];
        self.toolbar.hidden = NO;
//        [self setPlaybarBtnStates];
    }else{//隐藏
        [[self navigationController]setNavigationBarHidden:YES animated:YES];
        self.toolbar.hidden = YES;
    }  */
    [self navigationController].navigationBarHidden = ![self navigationController].isNavigationBarHidden;
    self.toolbar.hidden = [self navigationController].navigationBarHidden;
    self.modeView.hidden = [self navigationController].navigationBarHidden;
}


- (void)playerInitialized:(id)sender
{
    NSLog(@"playerInitialized");
    _player = _im360View.player;
    [_im360View setOrientation:UIInterfaceOrientationLandscapeLeft];
    im360::scene::BasicScene::pointer scene = _player->getScene<im360::scene::BasicScene>();
    std::string videoURL = [self.videoURL UTF8String];
//    std::string audeoURL = [self.audeoURL UTF8String];
//    NSLog(@"%s",videoURL.c_str());
    //    std::string videoURL1 = [@"http://101.231.87.94:8888/images/1.mp4" UTF8String];
    //    std::string videoURL = [[[NSBundle mainBundle]pathForResource:@"Bay.Bridge.Flying.Pass.2_11031_1280x506_f12_2M_a0.webm" ofType:nil]UTF8String];
    //    std::string audeoURL = [[[NSBundle mainBundle]pathForResource:@"Bay.Bridge.Flying.Pass.2.mp3" ofType:nil]UTF8String];
    scene->resetScene();

    scene->loadVideo(videoURL);

    scene->setLoopEnabled(FALSE);
    
    //设置logo图标，需要授权许可
    /**
     std::string logourl = [[[NSBundle mainBundle]pathForResource:@"icon@2x.png" ofType:nil]UTF8String];
    scene->setLogoImage(logourl); // requires license
    NSLog(@"%d",scene->setLogoImage(logourl));
    */
     //不让手机锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self setupToolbar];
    [self setupLookMode];
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
#pragma mark - JCPlayPauseDelegate
-(void)JCPlayPauseView:(JCPlayPauseView *)toolbar didClickButton:(JCPlayPauseViewButtonType)buttonType
{
    switch (buttonType) {
        case JCPlayPauseViewButtonTypeBackward:
            NSLog(@"JCPlayPauseViewButtonTypeBackward");
            break;
        case JCPlayPauseViewButtonTypePlayPause:
            NSLog(@"JCPlayPauseViewButtonTypePlayPause");
            [self setPlaybarBtnStates];
            break;
        case JCPlayPauseViewButtonTypeForward:
            NSLog(@"JCPlayPauseViewButtonTypeForward");
            break;
            
        default:
            break;
    }
}
@end
