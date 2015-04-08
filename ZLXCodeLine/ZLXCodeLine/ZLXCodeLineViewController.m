//
//  ZLXCodeLineViewController.m
//  ZLXCodeLine
//
//  Created by 张磊 on 15-4-8.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "ZLXCodeLineViewController.h"
#import "ZLXCodeFileType.h"

@interface ZLXCodeLineViewController ()
@property (strong,nonatomic) NSFileManager *fileManager;
@property (assign,nonatomic) NSUInteger codeLines;
@property (strong,nonatomic) NSMutableDictionary *fileExtesionDict;
@property (weak) IBOutlet NSTextField *titleField;
@property (strong,nonatomic) NSTextView *textView;
@property (weak) IBOutlet NSView *centerView;
@end

@implementation ZLXCodeLineViewController

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
    [self searchCodeWithPath:self.workspace];
    self.textView = [[NSTextView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(20, 0, self.titleField.frame.size.width, 280))];
    self.textView.editable = NO;
    self.textView.alignment = NSCenterTextAlignment;
    self.textView.backgroundColor = [NSColor clearColor];
    self.textView.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable | kCALayerMinXMargin | kCALayerMinYMargin;
    [self.centerView addSubview:self.textView];
    
    self.titleField.stringValue = [NSString stringWithFormat:@"%@项目共有%ld行代码!", [[self.workspace componentsSeparatedByString:@"/"] lastObject],self.codeLines];
    for (ZLXCodeFileType *fileType in [self.fileExtesionDict allValues]) {
        [self.textView setString:[NSString stringWithFormat:@"%@\n.%@后缀名有%ld个，有%ld行",[[self.textView textStorage] string],fileType.typeName,fileType.counts, fileType.lines]];
    }
}
- (void)searchCodeWithPath:(NSString *)path{
    // 如果存在这个目录就遍历
    BOOL isDir = NO;
    if([self.fileManager fileExistsAtPath:path isDirectory:&isDir]){
        
        if (isDir) {
            NSArray *paths = [self.fileManager contentsOfDirectoryAtPath:path error:nil];
            for (NSString *pathName in paths) {
                if ([pathName hasPrefix:@"."]) {
                    continue;
                }
                BOOL pathIsDir = NO;
                NSString *pathComponentName = [path stringByAppendingPathComponent:pathName];
                
                if ([self.fileManager fileExistsAtPath:pathComponentName isDirectory:&pathIsDir]) {
                    if (!pathIsDir) {
                        NSString *str = [[NSString alloc] initWithContentsOfFile:pathComponentName encoding:NSUTF8StringEncoding error:nil];
                        NSInteger lineCounts = [[str componentsSeparatedByString:@"\n"] count];
                        
                        ZLXCodeFileType *fileType = nil;
                        
                        if (![self.fileExtesionDict valueForKeyPath:[pathComponentName pathExtension]]) {
                            fileType = [[ZLXCodeFileType alloc] init];
                            fileType.counts = 1;
                        }else{
                            fileType = [self.fileExtesionDict valueForKeyPath:[pathComponentName pathExtension]];
                            fileType.counts += 1;
                        }
                        
                        fileType.typeName = [pathComponentName pathExtension];
                        fileType.lines += lineCounts;
                        [self.fileExtesionDict setValue:fileType forKeyPath:[pathComponentName pathExtension]];
                        self.codeLines += lineCounts;
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self searchCodeWithPath:pathComponentName];
                        });
                    }
                    
                }
            }
        }else{
            if ([path hasPrefix:@"."]) {
                return ;
            }
            NSString *str = [[NSString alloc] initWithContentsOfFile:[path stringByAppendingPathComponent:path] encoding:NSUTF8StringEncoding error:nil];
            
            NSInteger lineCounts = [[str componentsSeparatedByString:@"\n"] count];
            
            ZLXCodeFileType *fileType = nil;
            
            if (![self.fileExtesionDict valueForKeyPath:[path pathExtension]]) {
                fileType = [[ZLXCodeFileType alloc] init];
                fileType.counts = 1;
            }else{
                fileType = [self.fileExtesionDict valueForKeyPath:[path pathExtension]];
                fileType.counts += 1;
            }
            
            fileType.typeName = [path pathExtension];
            fileType.lines += lineCounts;
            [self.fileExtesionDict setValue:fileType forKeyPath:[path pathExtension]];
            
            self.codeLines += lineCounts;
        }
    }
}

@end
