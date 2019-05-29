//
//  EmojiHorizontalLayout.h
//  WXLogin
//
//  Created by 任珅 on 2019/5/28.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmojiHorizontalLayout : UICollectionViewFlowLayout
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;
@property (strong, nonatomic) NSMutableArray *allAttributes;

@end

NS_ASSUME_NONNULL_END
