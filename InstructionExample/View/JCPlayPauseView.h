//
//  JCPlayPauseView.h
//  InstructionExample
//
//  Created by yingyi on 15/8/11.
//  Copyright (c) 2015年 im360 immersive. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    JCPlayPauseViewButtonTypePlayPause, //播放
    JCPlayPauseViewButtonTypeBackward,  //回退
    JCPlayPauseViewButtonTypeForward    //快进
}JCPlayPauseViewButtonType;

@class JCPlayPauseView;
@protocol JCPlayPauseViewDelegate <NSObject>
@optional
-(void)JCPlayPauseView:(JCPlayPauseView *)toolbar didClickButton:(JCPlayPauseViewButtonType)buttonType;
@end
@interface JCPlayPauseView : UIView

@property (nonatomic ,weak)id <JCPlayPauseViewDelegate> delegate;
@end
