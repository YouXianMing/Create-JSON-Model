//
//  DragView.m
//  DragFile
//
//  Created by YouXianMing on 15/11/9.
//  Copyright © 2015年 ZiPeiYi. All rights reserved.
//

#import "DragView.h"
#import "NSArray+JSONData.h"
#import "NSDictionary+JSONData.h"

@interface DragView ()

@property (nonatomic) BOOL  highlight;

@end

@implementation DragView

- (id)initWithFrame:(NSRect)frame {
    
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/DragandDrop/Tasks/acceptingdrags.html#//apple_ref/doc/uid/20000993-BABHHIHC
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 注册拖拽事件
        [self registerForDraggedTypes:@[NSFilenamesPboardType]];
        
        // 默认不高亮
        self.highlight = NO;
    }
    
    return self;
}

#pragma mark - 拖拽事件
- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSArray *filenames   = [pboard propertyListForType:NSFilenamesPboardType];
    
    // 处理数组
    [self accessFiles:filenames];
    
    [self showHighlight:NO];
    
    return YES;
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    
    [self showHighlight:YES];
    
    return NSDragOperationEvery;
}

- (void)draggingExited:(nullable id <NSDraggingInfo>)sender {
    
    [self showHighlight:NO];
}

-(void)drawRect:(NSRect)rect {
    
    [super drawRect:rect];
    
    if (self.highlight == YES) {
        
        [[NSColor redColor] set];
        [NSBezierPath setDefaultLineWidth:2];
        [NSBezierPath strokeRect:rect];
    }
}

/**
 *  是否显示高亮
 *
 *  @param highlight YES为显示，NO为不显示
 */
- (void)showHighlight:(BOOL)highlight {
    
    self.highlight    = highlight;
    self.needsDisplay = YES;
}

- (void)accessFiles:(NSArray *)files {
    
    for (NSString *filePath in files) {
        
        BOOL isDirectory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:filePath
                                             isDirectory:&isDirectory];
        
        if (isDirectory == NO) {
            
            NSString *fileName = filePath.lastPathComponent;
            NSString *fileType = [fileName componentsSeparatedByString:@"."].lastObject;
            
            // 如果检测出来是json数据
            if ([fileType isEqualToString:@"json"]) {
                
                // 获取json数据
                NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
                id      data     = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                                     error:nil];
                
                // 组合出新的文件名
                fileName = [fileName stringByReplacingCharactersInRange:NSMakeRange(fileName.length - 4, 4)
                                                             withString:@"plist"];
                NSString *newFilePath = [filePath.stringByDeletingLastPathComponent stringByAppendingPathComponent:fileName];

                // 写文件
                if ([data isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *dic = data;
                    [dic writeToFile:newFilePath atomically:YES];
                }
                
                if ([data isKindOfClass:[NSArray class]]) {
                    
                    NSArray *array = data;
                    [array writeToFile:newFilePath atomically:YES];
                }
            }
            
            // 如果检测出来是plist数据
            if ([fileType isEqualToString:@"plist"]) {
                
                // 检测是不是字典
                NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
                if (dictionary == nil) {
                    
                    // 检测如果是数组
                    NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
                    NSData *data   = [array toJSONData];
                    
                    // 组合出新的文件名
                    fileName = [fileName stringByReplacingCharactersInRange:NSMakeRange(fileName.length - 5, 5)
                                                                 withString:@"json"];
                    NSString *newFilePath = [filePath.stringByDeletingLastPathComponent stringByAppendingPathComponent:fileName];
                    [data writeToFile:newFilePath atomically:YES];
                    
                } else {
                
                    NSData *data = [dictionary toJSONData];
                    
                    // 组合出新的文件名
                    fileName = [fileName stringByReplacingCharactersInRange:NSMakeRange(fileName.length - 5, 5)
                                                                 withString:@"json"];
                    NSString *newFilePath = [filePath.stringByDeletingLastPathComponent stringByAppendingPathComponent:fileName];
                    [data writeToFile:newFilePath atomically:YES];
                }
            }
        }
    }
}

@end
