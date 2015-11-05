//
//  CreateModel.h
//  WallPaper
//
//  Created by YouXianMing on 15/6/2.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateModel : NSObject

/**
 *  文件名字
 */
@property (nonatomic, strong) NSString      *modelName;

/**
 *  输入的字典
 */
@property (nonatomic, strong) NSDictionary  *inputDictionary;

/**
 *  创建出model
 */
- (void)createModel;

/**
 *  便利的创建model的方法
 *
 *  @param modelName  model的名字
 *  @param dictionary 输入的字典
 */
+ (void)createFileWithModelName:(NSString *)modelName dictionary:(NSDictionary *)dictionary;

@end
