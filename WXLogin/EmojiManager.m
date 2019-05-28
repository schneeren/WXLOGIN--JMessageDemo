//
//  EmojiManager.m
//  WXLogin
//
//  Created by RenShen on 2019/5/28.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import "EmojiManager.h"
#import <UIKit/UIKit.h>
@interface EmojiManager ()

@end

@implementation EmojiManager

-(instancetype)init{
    
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"emoji" ofType:@"plist"];
        _emojiDataArray = [NSArray arrayWithContentsOfFile:path];

    }
    
    return self;
    
}
-(NSAttributedString *)getEmojiString:(NSString *)string{


    //转成可变属性字符串
    NSMutableAttributedString * mAttributedString = [[NSMutableAttributedString alloc]initWithString:string];
    
    //创建匹配正则表达式的类型描述模板
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";

    //创建匹配对象
    NSError * error;
    NSRegularExpression * regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    //判断
    if (!regularExpression)//如果匹配规则对象为nil
    {
        NSLog(@"正则创建失败！");
        NSLog(@"error = %@",[error localizedDescription]);
        return mAttributedString;
    }
    
    NSArray * resultArray = [regularExpression matchesInString:mAttributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, mAttributedString.string.length)];
    
    //开始遍历 逆序遍历
    for (NSInteger i = resultArray.count - 1; i >= 0; i --)
    {
        //获取检查结果，里面有range
        NSTextCheckingResult * result = resultArray[i];
        
        //根据range获取字符串
        NSString * rangeString = [mAttributedString.string substringWithRange:result.range];
        
        //获取图片
        UIImage * image = [self getImageWithRangeString:rangeString];//这是个自定义的方法
        
        
        if (image != nil)
        {
            //创建附件对象
            NSTextAttachment * imageTextAttachment = [[NSTextAttachment alloc]init];
            //设置图片属性
            imageTextAttachment.image = image;
            
            //根据图片创建属性字符串
            NSAttributedString * imageAttributeString = [NSAttributedString attributedStringWithAttachment:imageTextAttachment];
            
            //开始替换
            [mAttributedString replaceCharactersInRange:result.range withAttributedString:imageAttributeString];
            
        }
    }
    return mAttributedString;


}
-(UIImage *)getImageWithRangeString:(NSString *)rangeString
{
    //开始遍历
    for (NSDictionary * tempDict in self.emojiDataArray)
    {
        if ([tempDict[@"name"] isEqualToString:rangeString])
        {
            //获得字典中的图片名
            NSString * imageName = tempDict[@"png"];
            
            //根据图片名获取图片
            UIImage * image = [UIImage imageNamed:imageName];
            
            //返回图片
            return  image;
        }
    }
    
    return nil;
    
}
@end
