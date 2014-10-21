/*
 *  Copyright (c) 2013, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the BSD-style license found in the
 *  LICENSE file in the root directory of this source tree. An additional grant
 *  of patent rights can be found in the PATENTS file in the same directory.
 *
 */

#import <UIKit/UIKit.h>

/**
Provides the heavy-lifting for FBSnapshotTestCase. It loads and saves images, along with performing the actual pixel-
by-pixel comparison of images.
Instances are initialized with the test class, and directories to read and write to.
*/
@interface AKUSnapshotTestService : NSObject

@property(readonly, nonatomic, retain) Class testClass;
/**
Record snapshots.
**/
@property(readwrite, nonatomic, assign) BOOL recordMode;

/**
Designated initializer.
Before this methods returns the controller enumerates over the test methods in `testClass` and loads the images
for those tests.
@param testClass The subclass of FBSnapshotTestCase that is using this controller.
@param referenceImagesDirectory The directory where the reference images are stored.
@returns An instance of AKUSnapshotTestService.
*/
- (id)initWithTestClass:(Class)testClass;


/**
Performs the comparison of the layer.
@param layer The Layer to snapshot.
@param referenceImagesDirectory The directory in which reference images are stored.
@param identifier An optional identifier, used is there are muliptle snapshot tests in a given -test method.
@param error An error to log in an XCTAssert() macro if the method fails (missing reference image, images differ, etc).
@returns YES if the comparison (or saving of the reference image) succeeded.
*/
- (NSError *)compareSnapshotOfLayer:(CALayer *)layer filePath:(NSString *)filePath referenceImagesDirectory:(NSString *)referenceImagesDirectory;

/**
Performs the comparison of the view.
@param view The view to snapshot.
@param referenceImagesDirectory The directory in which reference images are stored.
@param identifier An optional identifier, used is there are muliptle snapshot tests in a given -test method.
@param error An error to log in an XCTAssert() macro if the method fails (missing reference image, images differ, etc).
@returns YES if the comparison (or saving of the reference image) succeeded.
*/
- (NSError *)compareSnapshotOfView:(UIView *)view filePath:(NSString *)filePath referenceImagesDirectory:(NSString *)referenceImagesDirectory;

/**
Performs the comparison of a view or layer.
@param view The view or layer to snapshot.
@param referenceImagesDirectory The directory in which reference images are stored.
@param identifier An optional identifier, used is there are muliptle snapshot tests in a given -test method.
@param error An error to log in an XCTAssert() macro if the method fails (missing reference image, images differ, etc).
@returns YES if the comparison (or saving of the reference image) succeeded.
*/
- (NSError *)compareSnapshotOfViewOrLayer:(id)viewOrLayer filePath:(NSString *)filePath referenceImagesDirectory:(NSString *)referenceImagesDirectory;

/**
Saves a reference image.
@param filePath file path.
@param error An error, if this methods returns NO, the error will be something useful.
@returns An image.
*/
- (NSError *)saveReferenceImage:(UIImage *)image filePath:(NSString *)filePath;

/**
Performs a pixel-by-pixel comparison of the two images.
@param referenceImage The reference (correct) image.
@param image The image to test against the reference.
@param error An error that indicates why the comparison failed if it does.
@param YES if the comparison succeeded and the images are the same.
*/
- (NSError *)compareReferenceImage:(UIImage *)referenceImage toImage:(UIImage *)image;

/**
Saves the reference image and the test image to `failedOutputDirectory`.
@param referenceImage The reference (correct) image.
@param testImage The image to test against the reference.
@param selector The test method being run.
@param identifier The optional identifier, used when multiple images are tested in a single -test method.
@param error An error that indicates why the comparison failed if it does.
@param YES if the save succeeded.
 */
- (NSError *)saveFailedReferenceImage:(UIImage *)referenceImage testImage:(UIImage *)testImage filePath:(NSString *)filePath;
@end
