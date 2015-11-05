//
//  AccessJSONData.m
//  Demo
//
//  Created by YouXianMing on 15/11/5.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "AccessJSONData.h"

@implementation AccessJSONData

+ (id)accessJSONDataWithFileName:(NSString *)name {
    
    NSParameterAssert(name);
    id data = nil;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    
    if (filePath) {
        
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
        data             = [NSJSONSerialization JSONObjectWithData:jsonData
                                                           options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                             error:nil];
    }
    
    return data;
}

@end
