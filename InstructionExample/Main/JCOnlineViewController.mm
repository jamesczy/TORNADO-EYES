//
//  JCOnlineViewController.m
//  InstructionExample
//
//  Created by jamesczy on 15/7/27.
//  Copyright (c) 2015年 im360 immersive. All rights reserved.
//

#import "JCOnlineViewController.h"
#import "UIView+Extension.h"
#import "UIBarButtonItem+Extension.h"
#import "ViewController.h"
#import "JCCollectionCell.h"
#import "JC360Controller.h"
#import "JCNavigationController.h"
#import "JCLocalVideoController.h"

@interface JCOnlineViewController ()
@property (nonatomic ,strong)NSMutableArray *titleArray;
@property (nonatomic ,strong)NSMutableArray *titlePathArray;


@end

static NSString * const reuseIdentifier = @"Cell";

@implementation JCOnlineViewController

//-(NSMutableArray *)titleArray
//{
//    if (_titleArray == nil) {
//        NSMutableArray *array = [[NSMutableArray alloc]init ];
//        self.titleArray = array;
//    }
//    return _titleArray;
//}
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
    
    // self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    [self.collectionView registerClass:[JCCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
//    
//    UIButton *OnlineTitleButton = [[UIButton alloc]init];
//    OnlineTitleButton.width = 150;
//    OnlineTitleButton.height = 30;
//    
//    [OnlineTitleButton setTitle:@"本地视频" forState:UIControlStateNormal];
//    [OnlineTitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    OnlineTitleButton.titleLabel.font = [UIFont systemFontOfSize:17];
//    
//    self.navigationItem.titleView = OnlineTitleButton;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"];
//    [self logFilePathInDocumentsDir];
 
    self.titlePathArray = [self getFilenamelistOfType:@"mp4" fromDirPath:docsDir];
}

-(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"];
    
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *filenamePathlist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
                [filenamePathlist  addObject:[docsDir stringByAppendingPathComponent:filename]];
            }
        }
    }
    
    self.titleArray = filenamelist;
//    NSLog(@"filenamelist -->%@",filenamelist);
    
    return filenamePathlist;
}
-(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}
/**
//读取本地文件
- (void)logFilePathInDocumentsDir
{
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:  @"Documents"];
    NSLog(@"docsDir ---> %@",docsDir);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //枚举出目录的内容
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:docsDir];
    
    NSArray *array = [fileManager contentsOfDirectoryAtPath:docsDir error:nil];
    NSString *fileName;
    NSString *fileNamePath;
    int i = 0;
    
    while (fileName = [dirEnum nextObject]) {
        i++;
        
        NSLog(@"FielName : %@" , fileName);
        NSLog(@"FileFullPath : %@" , [docsDir stringByAppendingPathComponent:fileName]) ;
        fileNamePath = [docsDir stringByAppendingPathComponent:fileName];
    }
    
    self.titleArray = array;
    NSLog(@"%d",self.titleArray.count);
}
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JCCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[JCCollectionCell alloc]init];
    }
    [cell setCellTitle:self.titleArray[indexPath.row] Name:self.titleArray[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"这是第 %d 行被点击了。",indexPath.row);
    JCLocalVideoController *vc = [[JCLocalVideoController alloc]init];
    vc.videoURL = self.titlePathArray[indexPath.row];
    
    JCNavigationController *nav = [[JCNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    //    [self.navigationController pushViewController:vc animated:TRUE];
}

@end
