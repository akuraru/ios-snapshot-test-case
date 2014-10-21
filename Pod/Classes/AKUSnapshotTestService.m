/*
 *  Copyright (c) 2013, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 *
 */

#import "AKUSnapshotTestService.h"

#import "UIImage+Compare.h"
#import "UIImage+Diff.h"
#import "AKUSnapshotFileService.h"
#import "AKUErrorService.h"
#import "AKUSnapshotService.h"
#import "AKUEither.h"

#import <objc/runtime.h>

@interface AKUSnapshotTestService ()
@end

@implementation AKUSnapshotTestService {
    NSFileManager *_fileManager;
}

#pragma mark -
#pragma mark Lifecycle

- (id)initWithTestClass:(Class)testClass; {
    if ((self = [super init])) {
        _testClass = testClass;
        _fileManager = [[NSFileManager alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Public API

- (AKUEither *)referenceImageForFilePath:(NSString *)filePath {
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (image) {
        return [AKUEither t:EitherTypeRight v:image];
    } else {
        return [AKUEither t:EitherTypeLeft v:[self referenceImageError:filePath]];
    }
}

- (NSError *)referenceImageError:(NSString *)filePath {
    BOOL exists = [_fileManager fileExistsAtPath:filePath];
    return [AKUErrorService referenceImageError:filePath exists:exists];
}

- (NSError *)saveReferenceImage:(UIImage *)image filePath:(NSString *)filePath {
    return [[[AKUEither error:[self createDirectoryAtPath:filePath]] map:^AKUEither *(id o) {
        return [self checkImage:image];
    }] map:^AKUEither *(id pngData) {
        return [AKUEither error:[AKUSnapshotFileService writeToData:pngData filePath:filePath]];
    }].value;
}

- (AKUEither *)checkImage:(UIImage *)image {
    if (nil == image) {
        return [AKUEither error:[AKUErrorService errorNotExist]];
    }
    NSData *pngData = UIImagePNGRepresentation(image);
    if (nil == pngData) {
        return [AKUEither error:[AKUErrorService representationError]];
    } else {
        return [AKUEither t:EitherTypeRight v:pngData];
    }
}

- (NSError *)createDirectoryAtPath:(NSString *)filePath {
    NSError *creationError;
    BOOL didCreateDir = [_fileManager createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&creationError];
    return !didCreateDir ? creationError : nil;
}

- (NSError *)saveFailedReferenceImage:(UIImage *)referenceImage testImage:(UIImage *)testImage filePath:(NSString *)filePath {
    return [[[[[AKUEither error:nil] map:^AKUEither *(id value) {
        NSString *directory = [filePath stringByDeletingLastPathComponent];
        return [AKUEither error:[self createDirectoryAtPath:directory]];
    }] map:^AKUEither *(id value) {
        NSData *referencePNGData = UIImagePNGRepresentation(referenceImage);
        NSString *referencePath = [AKUSnapshotFileService failedFilePathForFilePath:filePath fileNameType:FBTestSnapshotFileNameTypeFailedReference testClass:_testClass];
        return [AKUEither error:[AKUSnapshotFileService writeToData:referencePNGData filePath:referencePath]];
    }] map:^AKUEither *(id value) {
        NSData *testPNGData = UIImagePNGRepresentation(testImage);
        NSString *testPath = [AKUSnapshotFileService failedFilePathForFilePath:filePath fileNameType:FBTestSnapshotFileNameTypeFailedTest testClass:_testClass];
        return [AKUEither error:[AKUSnapshotFileService writeToData:testPNGData filePath:testPath]];
    }] map:^AKUEither *(id value) {
        NSString *diffPath = [AKUSnapshotFileService failedFilePathForFilePath:filePath fileNameType:FBTestSnapshotFileNameTypeFailedTestDiff testClass:_testClass];

        UIImage *diffImage = [referenceImage diffWithImage:testImage];
        NSData *diffImageData = UIImagePNGRepresentation(diffImage);
        return [AKUEither error:[AKUSnapshotFileService writeToData:diffImageData filePath:diffPath]];
    }].value;
}

- (NSError *)compareReferenceImage:(UIImage *)referenceImage toImage:(UIImage *)image {
    if (CGSizeEqualToSize(referenceImage.size, image.size)) {
        return [referenceImage compareWithImage:image] ? nil : [AKUErrorService imageDifferentError];
    } else {
        return [AKUErrorService differentSizeError:referenceImage image:image];
    }
}

#pragma mark -
#pragma mark Private API

- (NSError *)compareSnapshotOfLayer:(CALayer *)layer filePath:(NSString *)filePath referenceImagesDirectory:(NSString *)referenceImagesDirectory {
    return [self compareSnapshotOfViewOrLayer:layer filePath:filePath referenceImagesDirectory:referenceImagesDirectory];
}

- (NSError *)compareSnapshotOfView:(UIView *)view filePath:(NSString *)filePath referenceImagesDirectory:(NSString *)referenceImagesDirectory {
    return [self compareSnapshotOfViewOrLayer:view filePath:filePath referenceImagesDirectory:referenceImagesDirectory];
}

- (NSError *)compareSnapshotOfViewOrLayer:(id)viewOrLayer filePath:(NSString *)filePath referenceImagesDirectory:(NSString *)referenceImagesDirectory {
    if (self.recordMode) {
        return [self _recordSnapshotOfViewOrLayer:viewOrLayer filePath:filePath];
    }
    else {
        return [self _performPixelComparisonWithViewOrLayer:viewOrLayer filePath:filePath];
    }
}

#pragma mark -
#pragma mark Private API

- (NSError *)_performPixelComparisonWithViewOrLayer:(UIView *)viewOrLayer filePath:(NSString *)filePath {
    AKUEither *referenceImage = [self referenceImageForFilePath:filePath];
    if (referenceImage.type == EitherTypeLeft) {
        return referenceImage.value;
    }
    UIImage *snapshot = [AKUSnapshotService snapshotViewOrLayer:viewOrLayer];
    NSError *e = [self compareReferenceImage:referenceImage.value toImage:snapshot];

    if (e) {
        NSError *error = [self saveFailedReferenceImage:referenceImage.value testImage:snapshot filePath:filePath];
        return error ?: e;
    } else {
        return nil;
    }
}

- (NSError *)_recordSnapshotOfViewOrLayer:(id)viewOrLayer filePath:(NSString *)filePath {
    UIImage *snapshot = [AKUSnapshotService snapshotViewOrLayer:viewOrLayer];
    return [self saveReferenceImage:snapshot filePath:filePath];
}
@end
