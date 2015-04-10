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

typedef void(^callBack)();

@interface ZLXCodeLineViewController () <NSTableViewDataSource,NSTableViewDelegate>

// Manager
@property (strong,nonatomic) NSFileManager *fileManager;
// UI
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSView *centerView;
@property (weak) IBOutlet NSTableView *tableView;

// Data
@property (assign,nonatomic) NSUInteger codeLines;
@property (strong,nonatomic) NSMutableDictionary *fileExtesionDict;
@property (strong,nonatomic) NSMutableArray *files;
@property (strong,nonatomic) NSMutableArray *filterExtension;

// IB
- (IBAction)switchClickOnButton:(NSButton *)sender;
@property (weak) IBOutlet NSButton *plistButton;
@property (weak) IBOutlet NSButton *xibButton;
@property (weak) IBOutlet NSButton *storyboardButton;
@property (weak) IBOutlet NSButton *warpButton;
@property (weak) IBOutlet NSButton *cocoapodsButton;
@property (weak) IBOutlet NSButton *jsonButton;
@property (weak) IBOutlet NSButton *pchButton;
@property (weak) IBOutlet NSButton *stringsButton;
@property (weak) IBOutlet NSButton *xcworkspaceButton;
@property (weak) IBOutlet NSButton *lockButton;

@end

@implementation ZLXCodeLineViewController

- (NSMutableArray *)filterExtension{
    if (!_filterExtension) {
        NSArray *filters = [[NSUserDefaults standardUserDefaults] objectForKey:FilterExtensionKey];
        if (filters) {
            _filterExtension = [NSMutableArray arrayWithArray:filters];
        }else{
            _filterExtension = [NSMutableArray array];
            if (self.plistButton.state == NO) {
                [_filterExtension addObject:self.plistButton.title];
            }
            if (self.xibButton.state == NO){
                [_filterExtension addObject:self.xibButton.title];
            }
            if (self.storyboardButton.state == NO){
                [_filterExtension addObject:self.storyboardButton.title];
            }
            if (self.warpButton.state == NO){
                [_filterExtension addObject:self.warpButton.title];
            }
        }
        
    }
    return _filterExtension;
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

- (void)windowDidLoad{
    
    self.tableView.backgroundColor = [NSColor clearColor];
    self.tableView.headerView = nil;
    self.plistButton.state = [self switchButtonOnStateWithTitle:self.plistButton.title];
    self.xibButton.state = [self switchButtonOnStateWithTitle:self.xibButton.title];
    self.storyboardButton.state = [self switchButtonOnStateWithTitle:self.storyboardButton.title];
    self.warpButton.state = [self switchButtonOnStateWithTitle:self.warpButton.title];
    self.cocoapodsButton.state = [self switchButtonOnStateWithTitle:self.cocoapodsButton.title];
    self.pchButton.state = [self switchButtonOnStateWithTitle:self.pchButton.title];
    self.stringsButton.state = [self switchButtonOnStateWithTitle:self.stringsButton.title];
    self.jsonButton.state = [self switchButtonOnStateWithTitle:self.jsonButton.title];
    self.lockButton.state = [self switchButtonOnStateWithTitle:self.lockButton.title];
    self.xcworkspaceButton.state = [self switchButtonOnStateWithTitle:self.xcworkspaceButton.title];
    
    [self searchFiles];
    
//    for (NSString *text in self.array) {
//        [self.textView setString:[NSString stringWithFormat:@"%@\n%@",[[self.textView textStorage] string],text]];
//    }
//    for (ZLXCodeFileType *fileType in [self.fileExtesionDict allValues]) {
//        [self.textView setString:[NSString stringWithFormat:@"%@\n.%@后缀名有%ld个，有%ld行",[[self.textView textStorage] string],fileType.typeName,fileType.counts, fileType.lines]];
//    }
}

- (BOOL)switchButtonOnStateWithTitle:(NSString *)title{
    return [self.filterExtension containsObject:title];
}

- (void)searchFiles{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *array = [self.fileManager subpathsAtPath:self.workspace];
        for (NSString *arr in array) {
            BOOL isDir = NO;
            [self.fileManager fileExistsAtPath:[self.workspace stringByAppendingPathComponent:arr] isDirectory:&isDir];
            // 如果是文件夹 或者 存在于filterExtension里面的就直接 continue;
            if (isDir) {
                continue;
            }
            if ([self.filterExtension containsObject:[NSString stringWithFormat:@".%@",[arr pathExtension]]]) {
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
                [arrM addObject:[self.workspace stringByAppendingPathComponent:arr]];
            }
        }
        
        NSInteger arrCount = arrM.count;
        for (NSInteger i = 0; i <= arrCount; i++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.titleField setStringValue:[NSString stringWithFormat:@"已经遍历 %% %f 一共有%ld文件,正在扫描%ld个文件!",((double)i / (double)(arrCount)) * 100,i,arrCount]];
            });
            
            if (i == arrCount) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.titleField.stringValue = [NSString stringWithFormat:@"%@项目共有%ld行代码!", [[self.workspace componentsSeparatedByString:@"/"] lastObject],self.codeLines];
                    [self.tableView reloadData];
                });
                break;
            }
            
            NSString *pathArr = arrM[i];
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
            if (lineCounts > 0) {
                ZLXCodeFileType *fileType = nil;
                if (![self.fileExtesionDict valueForKeyPath:[self.workspace pathExtension]]) {
                    fileType = [[ZLXCodeFileType alloc] init];
                    fileType.counts = 1;
                }else{
                    fileType = [self.fileExtesionDict valueForKeyPath:[self.workspace pathExtension]];
                    fileType.counts += 1;
                }
                
                fileType.typeName = [self.workspace pathExtension];
                fileType.lines += lineCounts;
                [self.fileExtesionDict setValue:fileType forKeyPath:[self.workspace pathExtension]];
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
