//
//  ZLXCodeLineViewController.m
//  ZLXCodeLine
//
//  Created by 张磊 on 15-4-8.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "ZLXCodeLineViewController.h"
#import "ZLXCodeFileType.h"

static NSString *FilterExtensionKey = @"FilterExtensionKey";
@interface ZLXCodeLineViewController () <NSTableViewDataSource,NSTableViewDelegate>

// Manager
@property (strong,nonatomic) NSFileManager *fileManager;

// Data
@property (assign,nonatomic) NSUInteger codeLines;
@property (strong,nonatomic) NSMutableDictionary *fileExtesionDict;
@property (strong,nonatomic) NSMutableArray *files;
@property (strong,nonatomic) NSArray *originFilters;
@property (strong,nonatomic) NSMutableArray *filterExtension;

// IB
- (void)switchClickOnButton:(NSButton *)sender;

// IB UI
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSView *centerView;
@property (weak) IBOutlet NSTableView *tableView;
@property (strong,nonatomic) NSMutableArray *buttons;
@property (weak) IBOutlet NSView *topView;
@property (weak) IBOutlet NSScrollView *scrollView;

@end

@implementation ZLXCodeLineViewController

#pragma mark - Getter
- (NSMutableArray *)filterExtension{
    if (!_filterExtension) {
        NSArray *filters = [[NSUserDefaults standardUserDefaults] objectForKey:FilterExtensionKey];
        if (filters.count) {
            _filterExtension = [NSMutableArray arrayWithArray:filters];
        }else{
            _filterExtension = [NSMutableArray array];
        }
    
    }
    return _filterExtension;
}

- (NSArray *)originFilters{
    if (!_originFilters) {
        _originFilters = @[
                           @"过滤类型：",
                           @"\\n",
                           @".cocoapods",
                           @".xcworkspace"
                           ];
    }
    return _originFilters;
}

- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray *)files{
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
}

- (NSMutableDictionary *)fileExtesionDict{
    if (!_fileExtesionDict) {
        _fileExtesionDict = [NSMutableDictionary dictionary];
    }
    return _fileExtesionDict;
}

- (NSFileManager *)fileManager{
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (IBAction)switchClickOnButton:(NSButton *)sender {
    if (sender.state == NO) {
        [self.filterExtension removeObject:sender.title];
    }else{
        [self.filterExtension addObject:sender.title];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:self.filterExtension forKeyPath:FilterExtensionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)windowDidLoad{
    
    self.tableView.backgroundColor = [NSColor clearColor];
    self.tableView.headerView = nil;
    
    [self searchWorkSpaceFiles];
    
}

- (BOOL)switchButtonOnStateWithTitle:(NSString *)title{
    return [self.filterExtension containsObject:title];
}

/**
 *  获取所有的文件名 / 过滤
 */
- (NSMutableArray *)getAllWorkFiles{
    NSMutableArray *workfilesM = [NSMutableArray array];
    NSArray *workfiles = [self.fileManager subpathsAtPath:self.workspace];
    for (NSString *arr in workfiles) {
        BOOL isDir = NO;
        [self.fileManager fileExistsAtPath:[self.workspace stringByAppendingPathComponent:arr] isDirectory:&isDir];
        // 如果是文件夹 或者 存在于filterExtension里面的就直接 continue;
        if (isDir || [self.filterExtension containsObject:[NSString stringWithFormat:@".%@",[arr pathExtension]]]) {
            continue;
        }
        
        if ([self.filterExtension containsObject:@".cocoapods"]) {
            if ([arr rangeOfString:@"Pods"].location != NSNotFound) {
                continue;
            }
        }
        
        if([arr rangeOfString:@"/."].location == NSNotFound &&
           [arr rangeOfString:@".xcodeproj"].location == NSNotFound &&
           [arr rangeOfString:@".xcworkspace"].location == NSNotFound
           && ![arr hasPrefix:@"."]
           ){
            [workfilesM addObject:[self.workspace stringByAppendingPathComponent:arr]];
        }
    }
    return workfilesM;
}

/**
 *  搜索工程底下的文件
 */
- (void)searchWorkSpaceFiles{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1.获取所有的文件
        NSMutableArray *workfilesM = [self getAllWorkFiles];
        
        NSInteger arrCount = workfilesM.count;
        // 2.遍历每个文件
        for (NSInteger i = 0; i <= arrCount; i++) {
            
            // 记录遍历的百分比
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.titleField setStringValue:[NSString stringWithFormat:@"已经遍历 %% %f 一共有%ld文件,正在扫描%ld个文件!",((double)i / (double)(arrCount)) * 100,i,arrCount]];
            });
            
            // 最后的时候，调用block
            if (i == arrCount && self.buttons.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.titleField.stringValue = [NSString stringWithFormat:@"%@项目共有%ld行代码!", [[self.workspace componentsSeparatedByString:@"/"] lastObject],self.codeLines];
                    [self.tableView reloadData];

                    NSInteger colunm = 8;
                    CGFloat width = self.topView.frame.size.width / colunm;
                    
                    for (NSInteger i = 0; i < self.originFilters.count; i++) {
                        NSButton *btn = [[NSButton alloc] init];
                        
                        [btn setWantsLayer:YES];
                        [btn.layer setBackgroundColor:                            [NSColor colorWithCalibratedRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor];
                        if (i > 0) {
                            [btn setButtonType:NSSwitchButton];
                        }else{
                            [btn setButtonType:NSOnOffButton];
                            btn.enabled = NO;
                        }
                        
                        btn.title = [NSString stringWithFormat:@"%@",self.originFilters[i]];
                        btn.target = self;
                        btn.state = [self switchButtonOnStateWithTitle:btn.title];
                        btn.action = @selector(switchClickOnButton:);
                        btn.frame = NSRectFromCGRect(CGRectMake(width * i, self.topView.frame.size.height - 20, width, 20));
                        [self.topView addSubview:btn];
                    }
                    
                    NSMutableArray *fileNames = [NSMutableArray array];
                    for (ZLXCodeFileType *fileType in [self.fileExtesionDict allValues]) {
                        [fileNames addObject:fileType.typeName];
                    }
                    for (NSString *fileType in self.filterExtension) {
                        [fileNames addObject:fileType];
                    }
                    
                    [fileNames enumerateObjectsUsingBlock:^(NSString *fileType, NSUInteger index, BOOL *stop) {
                        
                        if (![self.originFilters containsObject:fileType] || [fileType isEqualToString:@"\n"]){
                            
                            NSButton *btn = [[NSButton alloc] init];
                            [btn setWantsLayer:YES];
                            [btn.layer setBackgroundColor:                            [NSColor colorWithCalibratedRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor];
                            
                            [btn setButtonType:NSSwitchButton];
                            btn.title = [NSString stringWithFormat:@"%@",fileType];
                            NSSize size = [btn.title boundingRectWithSize:NSSizeFromCGSize(CGSizeMake(self.topView.frame.size.width, MAXFLOAT)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.font}].size;
                            
                            btn.state = [self switchButtonOnStateWithTitle:btn.title];
                            btn.target = self;
                            btn.action = @selector(switchClickOnButton:);
                            NSInteger row = (index + 4) / 8;
                            NSInteger col = (index + 4) % 8;
                            
                            if (row == 0) {
                                btn.frame = NSRectFromCGRect(CGRectMake((col) * width, self.topView.frame.size.height - 20, size.width + 22, 20));
                            }else{
                                btn.frame = NSRectFromCGRect(CGRectMake(col * width, self.topView.frame.size.height - (row + 1) * 22,size.width + 22, 22));
                            }
                            
                            [self.topView addSubview:btn];
                            [self.buttons addObject:btn];
                        }
                        
                    }];
                    
                });
                
                break;
            }
            
            NSString *pathArr = workfilesM[i];
            NSString *str = [[NSString alloc] initWithContentsOfFile:pathArr encoding:NSUTF8StringEncoding error:nil];
            
            NSInteger lineCounts = 0;
            if ([self.filterExtension containsObject:@"\\n"]) {
                for (NSString *lineStr in [str componentsSeparatedByString:@"\n"]) {
                    
                    if (lineStr.length == 0) {
                        continue;
                    }
                    
                    BOOL isEmptyWarp = YES;
                    for(int i = 0; i < [lineStr length]; i++)
                    {
                        if (![[lineStr substringWithRange:NSMakeRange(i,1)] isEqualToString:@" "]){
                            isEmptyWarp = NO;
                            break;
                        }
                    }
                    
                    if (!isEmptyWarp) {
                        lineCounts++;
                    }
                }
            }else {
                lineCounts = [[str componentsSeparatedByString:@"\n"] count];
            }
            
            // 记录代码行数等信息
            if (lineCounts > 0) {
                ZLXCodeFileType *fileType = nil;
                if (![self.fileExtesionDict valueForKeyPath:[pathArr pathExtension]]) {
                    fileType = [[ZLXCodeFileType alloc] init];
                    fileType.counts = 1;
                }else{
                    fileType = [self.fileExtesionDict valueForKeyPath:[pathArr pathExtension]];
                    fileType.counts += 1;
                }
                
                fileType.typeName = [NSString stringWithFormat:@".%@",[pathArr pathExtension]];
                fileType.lines += lineCounts;
                [self.fileExtesionDict setValue:fileType forKeyPath:[pathArr pathExtension]];
                
                [self.files addObject:[NSString stringWithFormat:@"%ld行 %@",lineCounts, pathArr]];
                self.codeLines += lineCounts;
            }
            
        }
    });
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.files.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTextField *field = nil;
    if (self.files.count > row) {
        field = [[NSTextField alloc] init];
        field.editable = NO;
        [field setStringValue:self.files[row]];
    }
    return field;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 30;
}

@end
