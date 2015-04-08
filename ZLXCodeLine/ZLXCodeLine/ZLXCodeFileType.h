//
//  ZLXCodeFileType.h
//  MyFile
//
//  Created by 张磊 on 15-4-8.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLXCodeFileType : NSObject

// 类型名字
@property (copy,nonatomic) NSString *typeName;
// 行数
@property (assign,nonatomic) NSInteger lines;
// 有多少个文件
@property (assign,nonatomic) NSInteger counts;

@end
