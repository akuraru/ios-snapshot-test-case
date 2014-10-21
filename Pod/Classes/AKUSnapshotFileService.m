//
//  AKUSnapshotFileService.m
//  AKUAssetManager
//
//  Created by akuraru on 2014/10/17.
//  Copyright (c) 2014年 akuraru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKUSnapshotFileService.h"

@implementation AKUSnapshotFileService {
}
+ (NSString *)referenceFilePathForSelector:(SEL)selector identifier:(NSString *)identifier referenceImagesDirectory:(NSString *)referenceImagesDirectory testClass:(Class)testClass {
    NSString *filePath = [self directory:referenceImagesDirectory testClass:testClass];
    NSString *fileName = [AKUSnapshotFileService fileNameForSelector:selector identifier:identifier];
    return [filePath stringByAppendingPathComponent:fileName];
}

+ (NSString *)directory:(NSString *)referenceImagesDirectory testClass:(Class)testClass {
    NSString *filePath = [referenceImagesDirectory stringByAppendingPathComponent:NSStringFromClass(testClass)];
    return filePath;
}

+ (NSString *)fileNameForSelector:(SEL)selector identifier:(NSString *)identifier {
    NSString *fileName = @"";
    if (selector) {
        fileName = [fileName stringByAppendingFormat:@"_%@", NSStringFromSelector(selector)];
    }
    if (0 < identifier.length) {
        fileName = [fileName stringByAppendingFormat:@"_%@", identifier];
    }
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale >= 2.0) {
        fileName = [fileName stringByAppendingFormat:@"@%dx", (int)scale];
    }
    fileName = [fileName stringByAppendingPathExtension:@"png"];
    return [fileName substringFromIndex:1];
}

+ (NSString *)prefixForType:(FBTestSnapshotFileNameType)fileNameType {
    switch (fileNameType) {
        case FBTestSnapshotFileNameTypeFailedReference:
            return @"reference_";
        case FBTestSnapshotFileNameTypeFailedTest:
            return @"failed_";
        case FBTestSnapshotFileNameTypeFailedTestDiff:
            return @"diff_";
        default:
            return @"";
    }
}

+ (NSString *)failedFilePathForFilePath:(NSString *)baseFilePath fileNameType:(FBTestSnapshotFileNameType)fileNameType testClass:(Class)testClass {
    NSString *filePath = [baseFilePath stringByDeletingLastPathComponent];
    NSString *fileName = [[self prefixForType:fileNameType] stringByAppendingString:[baseFilePath lastPathComponent]];
    return [filePath stringByAppendingPathComponent:fileName];
}

+ (NSError *)writeToData:(NSData *)data filePath:(NSString *)path {
    NSError *error;
    BOOL b = [data writeToFile:path options:NSDataWritingAtomic error:&error];
    return b ? nil : error;
}
@end