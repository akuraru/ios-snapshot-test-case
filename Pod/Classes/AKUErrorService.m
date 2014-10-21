//
// Created by akuraru on 2014/10/19.
// Copyright (c) 2014 akuraru. All rights reserved.
//

#import "AKUErrorService.h"

NSString *const FBSnapshotTestControllerErrorDomain = @"FBSnapshotTestControllerErrorDomain";

NSString *const FBReferenceImageFilePathKey = @"FBReferenceImageFilePathKey";

@interface AKUErrorService ()
@end

@implementation AKUErrorService {

}
+ (NSError *)referenceImageError:(NSString *)filePath exists:(BOOL)exists {
    if (exists) {
        return [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain code:FBSnapshotTestControllerErrorCodeUnknown userInfo:nil];
    } else {
        return [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain code:FBSnapshotTestControllerErrorCodeNeedsRecord userInfo:@{
                FBReferenceImageFilePathKey : filePath,
                NSLocalizedDescriptionKey : @"Unable to load reference image.",
                NSLocalizedFailureReasonErrorKey : @"Reference image not found. You need to run the test in record mode",
        }];
    }
}

+ (NSError *)errorNotExist {
    return [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain code:FBSnapshotTestControllerErrorCodeCreateSnapShot userInfo:nil];
}

+ (NSError *)representationError {
    return [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain code:FBSnapshotTestControllerErrorCodePNGCreationFailed userInfo:nil];
}

+ (NSError *)imageDifferentError {
    return [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain code:FBSnapshotTestControllerErrorCodeImagesDifferent userInfo:@{
            NSLocalizedDescriptionKey : @"Images different",
    }];
}

+ (NSError *)differentSizeError:(UIImage *)referenceImage image:(UIImage *)image {
    return [NSError errorWithDomain:FBSnapshotTestControllerErrorDomain code:FBSnapshotTestControllerErrorCodeImagesDifferentSizes userInfo:@{
            NSLocalizedDescriptionKey : @"Images different sizes",
            NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"referenceImage:%@, image:%@", NSStringFromCGSize(referenceImage.size), NSStringFromCGSize(image.size)],
    }];
}
@end
