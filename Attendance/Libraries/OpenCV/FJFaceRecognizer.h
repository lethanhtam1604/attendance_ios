//
//  FaceRecognizer.h
//  opencvtest
//
//  Created by Engin Kurutepe on 21/01/15.
//  Copyright (c) 2015 Fifteen Jugglers Software. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FJFaceRecognizer : NSObject

+ (FJFaceRecognizer*)sharedManager;

- (NSInteger)predict:(UIImage*)img confidence:(double)confidence;

- (void)createDataForTrain:(UIImage*)img label:(NSInteger)label;

- (void)save:(NSString *)path;

- (void)load:(NSString *)path;

- (void)trainingFace;

@end
