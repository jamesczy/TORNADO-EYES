//
//  JCPlayPauseView.m
//  InstructionExample
//
//  Created by yingyi on 15/8/11.
//  Copyright (c) 2015年 im360 immersive. All rights reserved.
//

#import "JCPlayPauseView.h"
#import "UIView+Extension.h"

@interface JCPlayPauseView()
/** 暂停播放界面 */
@property (nonatomic ,strong)UIView *buttomView;
/** 播放暂停按钮 */
@property (nonatomic ,strong)UIButton *playPauseBtn;
/** 回退按钮 */
@property (nonatomic ,strong)UIButton *moveBackBtn;
/** 快进按钮 */
@property (nonatomic ,strong)UIButton *moveForwordBtn;

@end
@implementation JCPlayPauseView

#define buttomViewH 100

-(id)init
{
    if (self = [super init]) {
        self.buttomView.width = [UIScreen mainScreen].bounds.size.width;
        self.buttomView.height = buttomViewH;
        self.buttomView.x = 0;
        self.buttomView.y = [UIScreen mainScreen].bounds.size.height - buttomViewH;
        
        //添加回退按钮
        UIButton *moveBackBtn =[[UIButton alloc]init];
        [moveBackBtn setBackgroundImage:[UIImage imageNamed:@"movieBackward@2x.png"] forState:UIControlStateNormal];
        [moveBackBtn setBackgroundImage:[UIImage imageNamed:@"movieBackwardSelected@2x.png"] forState:UIControlStateSelected];
        moveBackBtn.x = 15;
        moveBackBtn.y = 0;
        
        [self.buttomView addSubview:moveBackBtn];
        self.moveBackBtn = moveBackBtn;
        //添加播放暂停按钮
        UIButton *playPauseBtn =[[UIButton alloc]init];
        [playPauseBtn setBackgroundImage:[UIImage imageNamed:@"moviePlay@2x.png"] forState:UIControlStateNormal];
        [playPauseBtn setBackgroundImage:[UIImage imageNamed:@"moviePause@2x.png"] forState:UIControlStateSelected];
        [self.buttomView addSubview:playPauseBtn];
        self.playPauseBtn = playPauseBtn;
        //添加快进按钮
        UIButton *moveForwordBtn =[[UIButton alloc]init];
        [moveForwordBtn setBackgroundImage:[UIImage imageNamed:@"movieForward@2x.png"] forState:UIControlStateNormal];
        [moveForwordBtn setBackgroundImage:[UIImage imageNamed:@"movieForwardSelected@2x.png"] forState:UIControlStateSelected];
        [self.buttomView addSubview:moveForwordBtn];
        self.moveForwordBtn = moveForwordBtn;
    }
    return self;
}
-(void)layoutSubviews
{
    
}


@end
