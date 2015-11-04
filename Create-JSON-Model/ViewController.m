//
//  ViewController.m
//  Create-JSON-Model
//
//  Created by YouXianMing on 15/11/4.
//  Copyright © 2015年 YouXianMing. All rights reserved.
//

#import "ViewController.h"
#import "NSString+JSONData.h"
#import "CreateModel.h"

typedef enum : NSUInteger {
    
    kClearButton = 0x11,
    kCreateButton,
    
    kContentField,
    kModelNameField,
    
} ViewControllerEnums;

@interface ViewController () <NSTextFieldDelegate>

@property (nonatomic, strong) NSButton     *clearButton;
@property (nonatomic, strong) NSButton     *createButton;

@property (nonatomic, strong) NSTextField  *contentField;
@property (nonatomic, strong) NSTextField  *modelNameField;

@property (nonatomic, strong) NSTextField  *jsonDataText;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
    
    [self buildView];
}

#pragma mark - 初始化设置
- (void)setup {
    
    self.view.frame = CGRectMake(0, 0, 641, 436);
}

#pragma mark - 构建控件
- (void)buildView {

    self.clearButton = [self buttonWithFrame:CGRectMake(20, 50, 97, 25) tag:kClearButton title:@"Clear"];
    [self.view addSubview:self.clearButton];
    
    self.createButton = [self buttonWithFrame:CGRectMake(524, 50, 97, 25) tag:kCreateButton title:@"Create"];
    [self.view addSubview:self.createButton];
    
    self.contentField          = [[NSTextField alloc] initWithFrame:CGRectMake(20, 92, 601, 291)];
    self.contentField.delegate = self;
    [self.view addSubview:self.contentField];
    
    self.modelNameField          = [[NSTextField alloc] initWithFrame:CGRectMake(483, 396, 138, 22)];
    self.modelNameField.delegate = self;
    [self.view addSubview:self.modelNameField];
    
    NSTextField *versionText    = [[NSTextField alloc] initWithFrame:CGRectMake(462, 20, 172, 17)];
    versionText.bezeled         = NO;
    versionText.drawsBackground = NO;
    versionText.editable        = NO;
    versionText.stringValue     = @"Made by YouXianMing V 1.0";
    versionText.textColor       = [NSColor grayColor];
    [self.view addSubview:versionText];
    
    NSTextField *modelText    = [[NSTextField alloc] initWithFrame:CGRectMake(394, 399, 77, 17)];
    modelText.bezeled         = NO;
    modelText.drawsBackground = NO;
    modelText.editable        = NO;
    modelText.stringValue     = @"ModelName";
    [self.view addSubview:modelText];
    
    self.jsonDataText                 = [[NSTextField alloc] initWithFrame:CGRectMake(18, 399, 96, 17)];
    self.jsonDataText.bezeled         = NO;
    self.jsonDataText.drawsBackground = NO;
    self.jsonDataText.editable        = NO;
    [self.view addSubview:self.jsonDataText];
    
    [self notJsonData];
    [self cannotCreateFile];
}

#pragma mark - 按钮相关
- (NSButton *)buttonWithFrame:(CGRect)frame tag:(NSInteger)tag title:(NSString *)title {

    NSButton *button = [[NSButton alloc] initWithFrame:frame];
    button.target    = self;
    button.action    = @selector(buttonsEvent:);
    button.tag       = tag;
    button.title     = title;
    
    return button;
}

- (void)buttonsEvent:(NSButton *)button {

    if (button.tag == kClearButton) {
    
        self.contentField.stringValue = @"";
        [self notJsonData];
        [self cannotCreateFile];
        
    } else if (button.tag == kCreateButton) {
    
        [CreateModel createFileWithModelName:self.modelNameField.stringValue
                                  dictionary:[self.contentField.stringValue toListProperty]];
    }
}

#pragma mark - NSTextField代理
- (void)controlTextDidChange:(NSNotification *)obj {

    // 判断是不是JSON串
    id list = [self.contentField.stringValue toListProperty];
    if (list && [list isKindOfClass:[NSDictionary class]]) {
        
        [self isJsonData];
        [self canCreateFile];
        
    } else {
    
        [self notJsonData];
        [self cannotCreateFile];
    }
    
    // 判断是否输入了文件名
    if (self.modelNameField.stringValue.length == 0) {
        
        [self cannotCreateFile];
    }
}

#pragma mark - 状态值
- (void)isJsonData {

    self.jsonDataText.stringValue = @"JSON Data";
    self.jsonDataText.textColor   = [NSColor yellowColor];
}

- (void)notJsonData {

    self.jsonDataText.stringValue = @"Not JSON Data";
    self.jsonDataText.textColor   = [NSColor redColor];
}

- (void)canCreateFile {

    self.createButton.enabled = YES;
}

- (void)cannotCreateFile {

    self.createButton.enabled = NO;
}

@end
