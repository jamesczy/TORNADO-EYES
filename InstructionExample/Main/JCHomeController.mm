//
//  JCHomeController.m
//  InstructionExample
//
//  Created by jamesczy on 15/7/24.
//  Copyright (c) 2015年 im360 immersive. All rights reserved.
//

#import "JCHomeController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "ViewController.h"
#import "JCViewCell.h"

@interface JCHomeController ()

@end

@implementation JCHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *homeTitleButton = [[UIButton alloc]init];
    homeTitleButton.width =150;
    homeTitleButton.height = 30;
//    homeTitleButton.backgroundColor = [UIColor yellowColor];
    
    [homeTitleButton setTitle:@"我的360视频" forState:UIControlStateNormal];
    [homeTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    homeTitleButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    self.navigationItem.titleView = homeTitleButton;

    UIBarButtonItem *rightButton = [UIBarButtonItem itemWithTarget:self action:@selector(im360show) image:@"tabbar_profile" highImage:@"tabbar_profile_selected"];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)im360show
{
    NSLog(@"im360show");
    ViewController * vc = [[ViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = vc;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    JCViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[JCViewCell alloc]initWithStyle:UITableViewCellSelectionStyleDefault reuseIdentifier:ID];
    }
    cell.cellView.backgroundColor = [UIColor yellowColor];
    cell.nameLable.text = [NSString stringWithFormat: @"测试表名-->%d",indexPath.row];
    cell.nameLable.textAlignment = NSTextAlignmentCenter;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105 ;
    
}

@end
