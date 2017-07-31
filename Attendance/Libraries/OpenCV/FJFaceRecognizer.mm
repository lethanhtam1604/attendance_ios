//
//  FaceRecognizer.mm
//  opencvtest
//
//  Created by Engin Kurutepe on 21/01/15.
//  Copyright (c) 2015 Fifteen Jugglers Software. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/ml/ml.hpp>
#include <opencv2/imgproc.hpp>
#include "opencv2/highgui/highgui_c.h"
#include <iostream>
#include <sstream>
#include <fstream>

#endif

#import "FJFaceRecognizer.h"
#import "UIImage+OpenCV.h"

using namespace cv;
using namespace std;

@interface FJFaceRecognizer () {

    Ptr<FaceRecognizer> _faceClassifier;
    vector<Mat> images;
    vector<int> labels;
}

@end
@implementation FJFaceRecognizer

+ (FJFaceRecognizer*)sharedManager {
    static FJFaceRecognizer *faceRecognizer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        faceRecognizer = [[self alloc] init];
    });
    return faceRecognizer;
}

- (id)init {
    if (self = [super init]) {
        self->_faceClassifier = createEigenFaceRecognizer();
    }
    return self;
}

- (NSInteger)predict:(UIImage*)img confidence:(double)confidence {

    int predicted_label = -1;

    cv::Size minSize(128,128);
    cv::Mat image = [img cvMatGrayFromUIImage];
    resize(image, image, minSize);

    self->_faceClassifier->predict(image, predicted_label, confidence);

    return predicted_label;
}

- (void)createDataForTrain:(UIImage*)img label:(NSInteger)label {

    cv::Size minSize(128,128);
    cv::Mat src = [img cvMatGrayFromUIImage];
    resize(src, src, minSize);

    images.push_back(src);
    labels.push_back((int)label);
}

- (void)trainingFace {
    self->_faceClassifier->train(images, labels);
}

- (void)save:(NSString *)path {
    self->_faceClassifier->save(path.UTF8String);
}

- (void)load:(NSString *)path {
    self->_faceClassifier->load(path.UTF8String);
}

@end
