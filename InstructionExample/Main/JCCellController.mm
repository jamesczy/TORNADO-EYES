//
//  JCCellController.m
//  InstructionExample
//
//  Created by jamesczy on 15/7/27.
//  Copyright (c) 2015年 im360 immersive. All rights reserved.
//

#import "JCCellController.h"
#import "JCCollectionCell.h"
#import "ViewController.h"
#import "JC360Controller.h"
#import "JCNavigationController.h"

@interface JCCellController ()

@end

@implementation JCCellController

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(150, 200);
    
//    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    //设置itme的左右两边间距
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    [self.collectionView registerClass:[JCCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JCCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[JCCollectionCell alloc]init];
    }
    [cell setCellTitle:@"标题" Name:@"介绍"];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
//UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"这是第 %d 行被点击了。",indexPath.row);
//    JC360Controller *vc = [[JC360Controller alloc]init];
//    [self presentViewController:vc animated:YES completion:nil];
////    [self presentModalViewController:vc animated:YES];
////    [self.navigationController pushViewController:vc animated:TRUE];
//    
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"这是第 %d 行被点击了。",indexPath.row);
    JC360Controller *vc = [[JC360Controller alloc]init];
//    ViewController *vc = [[ViewController alloc]init];
    JCNavigationController *nav = [[JCNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:TRUE];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
