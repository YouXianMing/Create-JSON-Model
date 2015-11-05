//
//  ViewController.m
//  Access-JSON-Data
//
//  Created by YouXianMing on 15/11/5.
//  Copyright © 2015年 ZiPeiYi. All rights reserved.
//

#import "ViewController.h"
#import "Networking.h"
#import "GetNetworking.h"
#import "PostNetworking.h"
#import "RegExCategories.h"
#import "NSArray+JSONData.h"
#import "NSDictionary+JSONData.h"
#import "NSString+AccessJSONData.h"

typedef enum : NSUInteger {
    
    kGetButton = 0x11,
    kPostButton,
    kSaveButton,
    
    kGetNetworking,
    kPostNetworking,
    
} ViewControllerEnums;

@interface ViewController () <NetworkingDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSButton *saveButton;
@property (weak) IBOutlet NSButton *getButton;
@property (weak) IBOutlet NSButton *postButton;

@property (weak) IBOutlet NSTextField *urlTextField;
@property (weak) IBOutlet NSTextField *statusInfoTextField;

@property (weak) IBOutlet NSScrollView   *textScrollView;
@property (nonatomic, strong) NSTextView *textView;

@property (weak) IBOutlet NSProgressIndicator *indicator;

@property (nonatomic, strong) Networking *getNetworking;
@property (nonatomic, strong) Networking *postNetworking;

@property (nonatomic, strong) NSData  *jsonData;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
    
    [self initNetworking];
    
    [self getPostButtonEnabled:NO];
    
//    NSLog(@"%@", [@"data.json" JSONDataToListProperty]);
}

- (void)setup {
    
    // 初始化按钮
    self.saveButton.tag     = kSaveButton;
    self.getButton.tag      = kGetButton;
    self.postButton.tag     = kPostButton;
    self.saveButton.enabled = NO;
    
    // 初始化文本框
    self.urlTextField.delegate = self;
    
    // 开始提示
    [self.indicator startAnimation:nil];
    
    // 隐藏指示器
    self.indicator.hidden = YES;
    
    self.textView = [[NSTextView alloc] initWithFrame:self.textScrollView.bounds];
    [self.textScrollView setDocumentView:self.textView];
}

/**
 *  初始化网络链接
 */
- (void)initNetworking {
    
    self.getNetworking = [GetNetworking networkingWithUrlString:@""
                                              requestDictionary:nil
                                                       delegate:self
                                                timeoutInterval:@(5)
                                                            tag:kGetNetworking
                                           requestSerialization:nil
                                          responseSerialization:[AFJSONResponseSerializer serializer]];
    
    self.postNetworking = [PostNetworking networkingWithUrlString:@""
                                                requestDictionary:nil
                                                         delegate:self
                                                  timeoutInterval:@(5)
                                                              tag:kPostNetworking
                                             requestSerialization:nil
                                            responseSerialization:[AFJSONResponseSerializer serializer]];
}

- (IBAction)buttonsEvent:(NSButton *)sender {
    
    if (sender.tag == kGetButton) {
        
        [self getPostButtonEnabled:NO];
        [self statusInfoTextFieldState:@"hide"];
        [self.getNetworking startRequest];
        self.indicator.hidden = NO;
        
    } else if (sender.tag == kPostButton) {
        
        [self getPostButtonEnabled:NO];
        [self statusInfoTextFieldState:@"hide"];
        [self.postNetworking startRequest];
        self.indicator.hidden = NO;
        
    } else if (sender.tag == kSaveButton) {
        
        if (self.jsonData) {
            
            [self.jsonData writeToFile:[self filePath]
                            atomically:YES];
        }
    }
}

#pragma mark - NSTextField代理
- (void)controlTextDidChange:(NSNotification *)obj {
    
    NSString *regxString = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    BOOL isURL           = [self.urlTextField.stringValue isMatch:RX(regxString)];
    
    if (isURL) {
        
        [self getPostButtonEnabled:YES];
        self.getNetworking.urlString  = self.urlTextField.stringValue;
        self.postNetworking.urlString = self.urlTextField.stringValue;
        
    } else {
        
        [self getPostButtonEnabled:NO];
    }
}

#pragma mark - 请求代理
- (void)requestSucess:(Networking *)networking data:(id)data {
    
    [self getPostButtonEnabled:YES];
    [self statusInfoTextFieldState:@"sucess"];
    self.indicator.hidden = YES;
    
    if ([data isKindOfClass:[NSArray class]]) {
        
        NSArray *array = data;
        self.jsonData  = [array toJSONData];
        
        self.saveButton.enabled = YES;
        
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dictionary = data;
        self.jsonData            = [dictionary toJSONData];
        
        self.saveButton.enabled = YES;
    }
    
    // 加载文案
    NSString *dataString    = [NSString stringWithFormat:@"%@", data];
    self.textView.textColor = [NSColor blackColor];
    self.textView.string    = dataString;
}

- (void)requestFailed:(Networking *)networking error:(NSError *)error {
    
    [self getPostButtonEnabled:YES];
    [self statusInfoTextFieldState:@"failed"];
    self.indicator.hidden = YES;
    
    // 加载文案
    NSString *dataString    = [NSString stringWithFormat:@"%@", error.userInfo];
    self.textView.textColor = [NSColor redColor];
    self.textView.string    = dataString;
}

#pragma mark - 文件路径
- (NSString *)filePath {
    
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Desktop/data.json"]];
}

#pragma mark - 其他
- (void)getPostButtonEnabled:(BOOL)enable {
    
    self.getButton.enabled  = enable;
    self.postButton.enabled = enable;
}

- (void)statusInfoTextFieldState:(NSString *)state {
    
    if ([state isEqualToString:@"hide"]) {
        
        self.statusInfoTextField.stringValue = @"";
        
    } else if ([state isEqualToString:@"sucess"]) {
        
        self.statusInfoTextField.stringValue = @"Sucess!";
        self.statusInfoTextField.textColor   = [NSColor blueColor];
        
    } else if ([state isEqualToString:@"failed"]) {
        
        self.statusInfoTextField.stringValue = @"Failed!";
        self.statusInfoTextField.textColor   = [NSColor redColor];
    }
}

@end
