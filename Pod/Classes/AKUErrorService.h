//
// Created by akuraru on 2014/10/19.
// Copyright (c) 2014 akuraru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FBSnapshotTestControllerErrorCode) {
    FBSnapshotTestControllerErrorCodeUnknown,
    FBSnapshotTestControllerErrorCodeNeedsRecord,
    FBSnapshotTestControllerErrorCodePNGCreationFailed,
    FBSnapshotTestControllerErrorCodeImagesDifferentSizes,
    FBSnapshotTestControllerErrorCodeImagesDifferent,
    FBSnapshotTestControllerErrorCodeCreateDirectory,
    FBSnapshotTestControllerErrorCodeCreateSnapShot,
};

/**
Errors returned by the methods of AKUSnapshotTestService use this domain.
*/
extern NSString *const FBSnapshotTestControllerErrorDomain;

/**
Errors returned by the methods of AKUSnapshotTestService sometimes contain this key in the `userInfo` dictionary.
*/
extern NSString *const FBReferenceImageFilePathKey;

@interface AKUErrorService : NSObject
+ (NSError *)referenceImageError:(NSString *)filePath exists:(BOOL)exists;

+ (NSError *)errorNotExist;

+ (NSError *)representationError;

+ (NSError *)imageDifferentError;

+ (NSError *)differentSizeError:(UIImage *)referenceImage image:(UIImage *)image;
@end
