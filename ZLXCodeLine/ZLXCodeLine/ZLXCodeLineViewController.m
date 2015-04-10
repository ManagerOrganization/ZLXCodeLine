//
//  ZLXCodeLineViewController.m
//  ZLXCodeLine
//
//  Created by 张磊 on 15-4-8.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "ZLXCodeLineViewController.h"
#import "ZLXCodeFileType.h"

typedef void(^callBack)();

@interface ZLXCodeLineViewController () <NSTableViewDataSource,NSTableViewDelegate>
@property (strong,nonatomic) NSFileManager *fileManager;
@property (assign,nonatomic) NSUInteger codeLines;
@property (strong,nonatomic) NSMutableDictionary *fileExtesionDict;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSView *centerView;
@property (weak) IBOutlet NSTableView *tableView;

@property (strong,nonatomic) NSMutableArray *files;

@end

@implementation ZLXCodeLineViewController

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
    [self searchFiles];
    
//    for (NSString *text in self.array) {
//        [self.textView setString:[NSString stringWithFormat:@"%@\n%@",[[self.textView textStorage] string],text]];
//    }
//    for (ZLXCodeFileType *fileType in [self.fileExtesionDict allValues]) {
//        [self.textView setString:[NSString stringWithFormat:@"%@\n.%@后缀名有%ld个，有%ld行",[[self.textView textStorage] string],fileType.typeName,fileType.counts, fileType.lines]];
//    }
}

- (void)searchFiles{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *array = [self.fileManager subpathsAtPath:self.workspace];
        for (NSString *arr in array) {
            BOOL isDir = NO;
            [self.fileManager fileExistsAtPath:[self.workspace stringByAppendingPathComponent:arr] isDirectory:&isDir];
            if (isDir) {
                continue;
            }
            if([arr rangeOfString:@"/."].location == NSNotFound && ![arr hasPrefix:@"."]){
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
            NSInteger lineCounts = [[str componentsSeparatedByString:@"\n"] count];
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
