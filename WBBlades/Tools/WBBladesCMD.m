//
//  WBBladesCMD.m
//  WBBlades
//
//  Created by 邓竹立 on 2019/12/25.
//  Copyright © 2019 邓竹立. All rights reserved.
//

#import "WBBladesCMD.h"

// Execute command in console.
static const char *cmd(NSString *cmd) {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];  // Start task
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];    // Get execution results.
    return [data bytes];
}

void stripFile(NSString *filePath) {

    NSLog(@"正在去除bitcode中间码...");    // Remove bitcode information.
    NSString *bitcodeCmd = [NSString stringWithFormat:@"xcrun bitcode_strip -r %@_copy -o %@_copy",filePath,filePath];
    cmd(bitcodeCmd);
    
    NSLog(@"正在剥离符号表..."); // Strip symbol table.
    NSString *stripCmd = [NSString stringWithFormat:@"xcrun strip -x -S %@_copy",filePath];
    cmd(stripCmd);
}

void copyFile(NSString *filePath) {
    NSString *cpCmd = [NSString stringWithFormat:@"cp  -f %@ %@_copy",filePath,filePath];
    cmd(cpCmd);
}

void thinFile(NSString *filePath) {
    NSString *thinCmd = [NSString stringWithFormat:@"lipo %@_copy -thin arm64  -output %@_copy",filePath,filePath];
    cmd(thinCmd);
}

void removeFile(NSString *filePath) {
    NSString *rmCmd = [NSString stringWithFormat:@"rm -rf %@", filePath];
    cmd(rmCmd);
}

void removeCopyFile(NSString *filePath) {
    NSString *rmCmd = [NSString stringWithFormat:@"rm -rf %@_copy",filePath];
    cmd(rmCmd);
}

/**
 actool(apple command line tool)    --filter-for-device-model iPhone7,2（Specify the device） --filter-for-device-os-version 13.0（Specify the system）  --target-device iphone --minimum-deployment-target 9（Specify the minimum version） --platform iphoneos（Specify operation system type）  --compile /Users/a58/Desktop/BottomDlib/BottomDlib/  /Users/a58/Desktop/BottomDlib/BottomDlib/YXUIBase.xcassets （Specify the path where the compiled files are located. If there are multiple paths, concatenate them with spaces.）
 */

/**
 * Compile xcassert resources.
 * 使用 actool 编译成 Assets.car
 * 原本actool会把所有的资源文件找到，然后“输出”到2个地方，car file和--compile指定的目录下（在xcassets中的资源输出到car file，零散的资源输出到app包里）。在mac OC 10.13和iOS 11.0之后的版本，icon会被拷贝到car file中（可能苹果希望这么做吧）
 * 链接：https://www.jianshu.com/p/0fcf68e69564
 */
void compileXcassets(NSString *path) {
    NSString *complieCmd = [NSString stringWithFormat:@"actool   --compress-pngs --filter-for-device-model iPhone9,2 --filter-for-device-os-version 13.0  --target-device iphone --minimum-deployment-target 9 --platform iphoneos --compile %@ %@", [path stringByDeletingLastPathComponent],path];
    cmd(complieCmd);
}

#pragma mark Tools
void colorPrint(NSString *info) {
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];
    NSString *cmd = [NSString stringWithFormat:@"echo -e '\e[1;36m %@ \e[0m'",info];
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    
    [task launch];
}
