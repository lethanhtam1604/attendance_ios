//
//  CVCameraProvider.mm
//  opencvtest
//
//  Created by Engin Kurutepe on 16/01/15.
//  Copyright (c) 2015 Fifteen Jugglers Software. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif


#import "FJFaceDetector.h"
#import "UIImage+OpenCV.h"
using namespace cv;

@interface FJFaceDetector () {
    
    CascadeClassifier _faceDetector;
    CascadeClassifier _eyesDetector;
    
    std::vector<cv::Rect> _faceRects;
    std::vector<cv::Mat> _faceImgs;

    std::vector<cv::Rect> _faceRects1;
    std::vector<cv::Mat> _faceImgs1;

    cv::Mat originalImage;
}

@property (nonatomic, assign) CGFloat scale;


@end

@implementation FJFaceDetector

- (instancetype)initWithCameraView:(UIImageView *)view scale:(CGFloat)scale {
    self = [super init];
    if (self) {
        self.videoCamera = [[CvVideoCamera alloc] initWithParentView:view];
        self.videoCamera.defaultAVCaptureDevicePosition =  AVCaptureDevicePositionFront;
        self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
        self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        self.videoCamera.defaultFPS = 30;
        self.videoCamera.grayscaleMode = NO;
        self.videoCamera.delegate = self;
        self.scale = scale;

        NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
        
        const CFIndex CASCADE_NAME_LEN = 2048;
        char *CASCADE_NAME = (char *) malloc(CASCADE_NAME_LEN);
        CFStringGetFileSystemRepresentation( (CFStringRef)faceCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
        
        _faceDetector.load(CASCADE_NAME);
        
    }
    
    return self;
}


- (void)startCapture {
    [self.videoCamera start];
}

- (void)stopCapture; {
    [self.videoCamera stop];
}

- (NSArray *)detectedFaces {
    NSMutableArray *facesArray = [NSMutableArray array];
    for( std::vector<cv::Rect>::const_iterator r = _faceRects.begin(); r != _faceRects.end(); r++ )
    {
        CGRect faceRect = CGRectMake(_scale*r->x/480., _scale*r->y/640., _scale*r->width/480., _scale*r->height/640.);
        [facesArray addObject:[NSValue valueWithCGRect:faceRect]];
    }
    return facesArray;
}

- (UIImage *)faceWithIndex:(NSInteger)idx {

    cv::Mat img = self->_faceImgs[idx];
    
    UIImage *ret = [UIImage imageFromCVMat:img];
    
    return ret;
}

- (void)processImage:(cv::Mat&)image {

    originalImage = image;
    
    [self detectAndDrawFacesOn:image scale:_scale];
}

- (UIImage*)getImageFromCamera {

    return [UIImage imageFromCVMat:originalImage];
}

- (void)detectAndDrawFacesOn:(Mat&) img scale:(double) scale
{
    int i = 0;
    double t = 0;
    
    const static Scalar colors[] =  { CV_RGB(0,0,255),
        CV_RGB(0,128,255),
        CV_RGB(0,255,255),
        CV_RGB(0,255,0),
        CV_RGB(255,128,0),
        CV_RGB(255,255,0),
        CV_RGB(255,0,0),
        CV_RGB(255,0,255)} ;

    Mat gray, smallImg( cvRound (img.rows/scale), cvRound(img.cols/scale), CV_8UC1 );
    
    cvtColor( img, gray, COLOR_BGR2GRAY );
    resize( gray, smallImg, smallImg.size(), 0, 0, INTER_LINEAR );
    equalizeHist( smallImg, smallImg );

    t = (double)cvGetTickCount();
    double scalingFactor = 1.1;
    int minRects = 2;
    cv::Size minSize(30, 30);

    // detect face
    self->_faceDetector.detectMultiScale( smallImg, self->_faceRects, scalingFactor, minRects, 0, minSize);

    // Draw rectangle at the position of the face
    t = (double)cvGetTickCount() - t;
    std::vector<cv::Mat> faceImages;
    
    for( std::vector<cv::Rect>::const_iterator r = _faceRects.begin(); r != _faceRects.end(); r++, i++ ) {
        cv::Mat smallImgROI;
        cv::Point center;
        Scalar color = colors[i%8];
        std::vector<cv::Rect> nestedObjects;
        rectangle(img,
                cvPoint(cvRound(r->x*scale), cvRound(r->y*scale)),
                  cvPoint(cvRound((r->x + r->width-1)*scale), cvRound((r->y + r->height-1)*scale)),
                  color, 1, 8, 0);

        smallImgROI = smallImg(*r);
        
        faceImages.push_back(smallImgROI.clone());

    }
   
    @synchronized(self) {
        self->_faceImgs = faceImages;
    }
}

- (NSArray *)detectedFaces1 {
    NSMutableArray *facesArray = [NSMutableArray array];
    for( std::vector<cv::Rect>::const_iterator r = _faceRects1.begin(); r != _faceRects1.end(); r++ )
    {
        CGRect faceRect = CGRectMake(2*r->x/480., 2*r->y/640., 2*r->width/480., 2*r->height/640.);
        [facesArray addObject:[NSValue valueWithCGRect:faceRect]];
    }
    return facesArray;
}


- (void)detectFace:(UIImage*)image scale:(double) scale {

    cv::Mat img = [image cvMatGrayFromUIImage];

    int i = 0;
    double t = 0;

    const static Scalar colors[] =  { CV_RGB(0,0,255),
        CV_RGB(0,128,255),
        CV_RGB(0,255,255),
        CV_RGB(0,255,0),
        CV_RGB(255,128,0),
        CV_RGB(255,255,0),
        CV_RGB(255,0,0),
        CV_RGB(255,0,255)};

    Mat gray, smallImg( cvRound (img.rows/scale), cvRound(img.cols/scale), CV_8UC1 );

//    cvtColor( img, gray, COLOR_BGR2GRAY );
    resize( img, smallImg, smallImg.size(), 0, 0, INTER_LINEAR );
    equalizeHist( smallImg, smallImg );

    t = (double)cvGetTickCount();
    double scalingFactor = 1.1;
    int minRects = 2;
    cv::Size minSize(30, 30);

    // detect face
    self->_faceDetector.detectMultiScale( smallImg, self->_faceRects1, scalingFactor, minRects, 0, minSize);

    // Draw rectangle at the position of the face
    t = (double)cvGetTickCount() - t;
    std::vector<cv::Mat> faceImages;

    for( std::vector<cv::Rect>::const_iterator r = _faceRects1.begin(); r != _faceRects1.end(); r++, i++ ) {
        cv::Mat smallImgROI;
        cv::Point center;
        Scalar color = colors[i%8];
        std::vector<cv::Rect> nestedObjects;
        rectangle(img, cvPoint(cvRound(r->x*scale), cvRound(r->y*scale)), cvPoint(cvRound((r->x + r->width-1)*scale), cvRound((r->y + r->height-1)*scale)), color, 1, 8, 0);

        smallImgROI = smallImg(*r);

        faceImages.push_back(smallImgROI.clone());

    }

    @synchronized(self) {
        self->_faceImgs1 = faceImages;
    }

}

@end
