//
//  EmojiView.m
//  WXLogin
//
//  Created by RenShen on 2019/5/28.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import "EmojiView.h"
#import "EmojiManager.h"
#import <Masonry.h>
#define cellID @"emojiCell"

#define spacing 0
#define baseTag 1312
@interface EmojiView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong)EmojiManager *manager;
@property (nonatomic) NSInteger numRowOfLine;
@property (nonatomic) NSInteger sectionNum;
@end

@implementation EmojiView

-(instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUIWithFrame:frame];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)setUIWithFrame:(CGRect )frame{
    CGFloat W = frame.size.width;
    CGFloat H = frame.size.height;
    _manager = [[EmojiManager alloc]init];
    //计算每行多少个表情
    _numRowOfLine = [UIScreen mainScreen].bounds.size.width>=375?9:7;
    
    //计算有多少页
    NSInteger num = _manager.emojiDataArray.count/(_numRowOfLine*3);
    NSInteger remainder = _manager.emojiDataArray.count%(_numRowOfLine*3);
    _sectionNum = remainder>0?num+1:num;
    
    //计算每个row的宽高
    CGFloat itemW = (W-(_numRowOfLine-1)*spacing)/(CGFloat )_numRowOfLine;
    CGFloat itemH = (H - 2*spacing)/3;
    
    //初始化scrollview
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
    scrollView.contentSize = CGSizeMake(W*_sectionNum, H);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    for (int i=0; i<_sectionNum; i++) {
        UIView *view =[[UIView alloc]initWithFrame:CGRectMake(W*i, 0, W, H)];
        [scrollView addSubview:view];
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, W, H) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.tag = baseTag +i;
        [view addSubview:collectionView];
        collectionView.collectionViewLayout = layout;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    [self addSubview:scrollView];
    
    
    
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _numRowOfLine*3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return spacing;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return spacing;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSInteger tag = 12312312;
    UIImageView *imageView = [cell.contentView viewWithTag:tag];
    if (!imageView) {
        imageView = [[UIImageView alloc]init];
        imageView.tag = tag;
        [cell.contentView addSubview:imageView];
        imageView.frame = CGRectMake(0, 0, 24, 24);
        imageView.center= cell.contentView.center;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    NSInteger index = (_numRowOfLine*3)*(collectionView.tag-baseTag)+indexPath.row;
    if (index<_manager.emojiDataArray.count) {
        NSDictionary *data = _manager.emojiDataArray[index];
        NSString *imageName = data[@"image"];
        imageView.image = [UIImage imageNamed:imageName];
    }else{
        imageView.image = nil;
        
    }


    return cell;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
