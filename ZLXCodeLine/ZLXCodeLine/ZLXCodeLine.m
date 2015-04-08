//
//  ZLXCodeLine.m
//  ZLXCodeLine
//
//  Created by 张磊 on 15-4-8.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "ZLXCodeLine.h"
#import <AppKit/AppKit.h>
#import "ZLXCodeLineViewController.h"

@interface ZLXCodeLine ()
@property (strong,nonatomic) ZLXCodeLineViewController *lineVc;
@property (copy,nonatomic) NSString *workspace;
@end

@implementation ZLXCodeLine

+ (void)pluginDidLoad:(NSBundle *)plugin{
    [self sharedXCodeLine];
}

+ (instancetype)sharedXCodeLine{
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - init
- (instancetype)init{
    if (self = [super init]) {
        [self addNotification];
    }
    return self;
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)noti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentAppPath:) name:@"IDEWorkspaceBuildProductsLocationDidChangeNotification" object:nil];
    
    NSMenuItem *appItem = [[NSApp menu] itemWithTitle:@"File"];
    [[appItem submenu] addItem:[NSMenuItem separatorItem]];
    NSMenuItem *item = [[NSMenuItem alloc] init];
    item.title = @"See Project Line!";
    item.action = @selector(seeProjectLine);
    item.target = self;
    [[appItem submenu] addItem:item];
}

- (void)seeProjectLine{
    self.lineVc = [[ZLXCodeLineViewController alloc] initWithWindowNibName:@"ZLXCodeLineViewController"];
    self.lineVc.workspace = self.workspace;
    [self.lineVc showWindow:self.lineVc];
}

#pragma mark - set workSpacePath
- (void)getCurrentAppPath:(NSNotification *)noti{
    NSString *notiStr = [noti.object description];
    notiStr = [notiStr stringByDeletingLastPathComponent];
    NSRange preRange = [notiStr rangeOfString:@"'"];
    notiStr = [notiStr substringFromIndex:preRange.location+preRange.length];
    notiStr = [notiStr stringByReplacingOccurrencesOfString:@".xcodeproj" withString:@""];
    self.workspace = notiStr;
}

@end
