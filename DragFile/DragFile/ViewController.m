//
//  ViewController.m
//  DragFile
//
//  Created by YouXianMing on 15/11/9.
//  Copyright © 2015年 ZiPeiYi. All rights reserved.
//

#import "ViewController.h"
#import "DragView.h"

@interface ViewController ()

@property (nonatomic, strong) DragView  *dragView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // The pasteboard can hold a list of file paths, a single URL, a file’s complete contents, or a promise to create files at a location to be determined by the destination. 
    
    self.dragView = [[DragView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.dragView];
}

@end
