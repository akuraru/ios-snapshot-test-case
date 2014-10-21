//
//  AKUSnapshotFileService.h
//  AKUAssetManager
//
//  Created by akuraru on 2014/10/17.
//  Copyright (c) 2014年 akuraru. All rights reserved.
//


typedef NS_ENUM(NSUInteger, FBTestSnapshotFileNameType) {
    FBTestSnapshotFileNameTypeReference,
    FBTestSnapshotFileNameTypeFailedReference,
    FBTestSnapshotFileNameTypeFailedTest,
    FBTestSnapshotFileNameTypeFailedTestDiff,
};

@interface AKUSnapshotFileService : NSObject
+ (NSString *)referenceFilePathForSelector:(SEL)selector identifier:(NSString *)identifier referenceImagesDirectory:(NSString *)referenceImagesDirectory testClass:(Class)testClass ;

+ (NSString *)fileNameForSelector:(SEL)selector identifier:(NSString *)identifier;

+ (NSString *)failedFilePathForFilePath:(NSString *)baseFilePath fileNameType:(FBTestSnapshotFileNameType)fileNameType testClass:(Class)testClass;

+ (NSError *)writeToData:(NSData *)data filePath:(NSString *)path;
@end
