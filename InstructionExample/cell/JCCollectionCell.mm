//
//  JCCollectionCell.m
//  InstructionExample
//
//  Created by jamesczy on 15/7/27.
//  Copyright (c) 2015年 im360 immersive. All rights reserved.
//

#import "JCCollectionCell.h"

@implementation JCCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.imageView];
        
        self.nameLable = [[UILabel alloc]init];
        self.nameLable.text = @"标题";
        self.nameLable.backgroundColor = [UIColor yellowColor];
        self.nameLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLable];
        
        self.button = [[UIButton alloc]init];
        [self.button setTitle:@"介绍" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.button];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 5, 150, 120);
    self.nameLable.frame = CGRectMake(0, 130, 150, 20);
    self.button.frame = CGRectMake(0, 155, 150, 15);
}
@end
