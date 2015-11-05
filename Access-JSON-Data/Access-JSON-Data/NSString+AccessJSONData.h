//
//  NSString+AccessJSONData.h
//  Demo
//
//  Created by YouXianMing on 15/11/5.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AccessJSONData)

/**
 *  转换成集合数据
 *
 *  @return 集合数据
 */
- (id)JSONDataToListProperty;

@end
