//
//  WBBladesCMD.h
//  WBBlades
//
//  Created by 邓竹立 on 2019/12/25.
//  Copyright © 2019 邓竹立. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Input file path, strip the symbol table.
 */
void stripFile(NSString *filePath);

/**
 * Input file path, copy the file.
 */
void copyFile(NSString *filePath);

/**
 * Input file path, strip multiple architectures and keep the arm64 architecture.
 */
void thinFile(NSString *filePath);

/**
 * Remove the file.
 */
void removeFile(NSString *filePath);
 
/**
 * Remove the copied file.
 */
void removeCopyFile(NSString *filePath);
 
/**
 * Compile xcassert resources.
 * 使用 actool 编译成 Assets.car
 * 原本actool会把所有的资源文件找到，然后“输出”到2个地方，car file和--compile指定的目录下（在xcassets中的资源输出到car file，零散的资源输出到app包里）。在mac OC 10.13和iOS 11.0之后的版本，icon会被拷贝到car file中（可能苹果希望这么做吧）
 * 链接：https://www.jianshu.com/p/0fcf68e69564
 */
void compileXcassets(NSString *path);

/**
 * Color printing to console.
 * @param info Information to be printed.
 */
void colorPrint(NSString *info);

