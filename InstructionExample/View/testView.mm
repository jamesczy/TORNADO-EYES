//
//  testView.m
//  InstructionExample
//
//  Created by yingyi on 15/8/12.
//  Copyright (c) 2015年 im360 immersive. All rights reserved.
//

#import "testView.h"
#import "JCPlayPauseView.h"

@implementation testView

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    JCPlayPauseView *jcppv = [[JCPlayPauseView alloc] init];
    [self.view addSubview:jcppv];
    jcppv.backgroundColor = [UIColor grayColor];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 100, 30)];
    lable.text = @"这是标题";
    lable.textColor = [UIColor blackColor];
    [self.view addSubview:lable];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"it's touch");
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

//设置界面为横屏
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
@end
