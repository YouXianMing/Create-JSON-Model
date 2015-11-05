//
//  NSString+AccessJSONData.m
//  Demo
//
//  Created by YouXianMing on 15/11/5.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "NSString+AccessJSONData.h"
#import "AccessJSONData.h"

@implementation NSString (AccessJSONData)

- (id)JSONDataToListProperty {

    if (self.length) {
    
        return [AccessJSONData accessJSONDataWithFileName:self];
        
    } else {
    
        return nil;
    }
}

@end
