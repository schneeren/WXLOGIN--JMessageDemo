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
@interface EmojiView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong)EmojiManager *manager;
@end

@implementation EmojiView
-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    NSInteger numRowOfLine = screenW>=375?9:7;
    
    
    CGFloat W = ([UIScreen mainScreen].bounds.size.width-28)/numRowOfLine;
    CGFloat H = (240-24)/3;
    layout.itemSize = CGSizeMake(W, H);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _manager = [[EmojiManager alloc]init];
}
-(instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUIWithFrame:frame];
    }
    return self;
}
-(void)setUIWithFrame:(CGRect )frame{
    UICollectionView *collectionView = [[UICollectionView alloc]init];
    [self addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 14, 12, 14));
    }];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    NSInteger numRowOfLine = screenW>=375?9:7;
    
    
    CGFloat W = (frame.size.width-28)/numRowOfLine;
    CGFloat H = (frame.size.height-24)/3;
    layout.itemSize = CGSizeMake(W, H);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionView.collectionViewLayout = layout;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _manager = [[EmojiManager alloc]init];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (cell) {
        UIImageView *imageView = [[UIImageView alloc]init];
//        ce
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
