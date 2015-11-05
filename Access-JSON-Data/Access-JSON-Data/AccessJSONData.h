//
//  AccessJSONData.h
//  Demo
//
//  Created by YouXianMing on 15/11/5.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessJSONData : NSObject

/**
 *  处理bundle上的JSON数据
 *
 *  @param name json数据的全名
 *
 *  @return 字典或者数组
 */
+ (id)accessJSONDataWithFileName:(NSString *)name;

@end
