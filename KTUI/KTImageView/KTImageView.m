//
//
// Copyright 2013 Kii Corporation
// http://kii.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//

#import "KTImageView.h"

#if __has_include(<KiiSDK/Kii.h>)

#import <KiiSDK/Kii.h>

#import "UIView+KTUtilities.h"
#import "KTProgressIndicator.h"

@implementation KTImageView

- (void) showWithProgress:(KTImageViewProgressBlock)progressBlock
            andCompletion:(KTImageViewCompletionBlock)completionBlock
{
    
    // by default, we want it to be 80% of the width and
    // 10% of the height (min 10px high)
    CGFloat width = 0.8f * self.frame.size.width;
    CGFloat height = 0.1f * self.frame.size.height;
    
    if(height < 10.f) {
        height = 10.f;
    }
    
    // create the progress indicator
    CGRect f = CGRectMake(0, 0, width, height);
    _progressIndicator = [[KTProgressIndicator alloc] initWithFrame:f];
    [self addSubview:_progressIndicator];
    
    // center the progress bar
    _progressIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    // normalize it (round the pixels so it's not blurry)
    [_progressIndicator normalizeView];
    
    // load the file from the cloud
    [_imageFile getFileBody:nil
          withProgressBlock:^(KiiFile *file, double progress) {
              
              // update our progress indicator
              if(_progressIndicator != nil) {
                  [_progressIndicator setProgress:progress];
              }
              
              // if the developer wants to track progress
              if(progressBlock) {
                  
                  // send them the status
                  progressBlock(file, progress);
              }
          }
         andCompletionBlock:^(KiiFile *file, NSString *toPath, NSError *error) {
             
             // remove the progress indicator
             [UIView animateWithDuration:0.3f
                                   delay:0.0f
                                 options:UIViewAnimationOptionCurveEaseIn
                              animations:^{
                                  _progressIndicator.alpha = 0.f;
                              }
                              completion:^(BOOL finished) {
                                  [_progressIndicator removeFromSuperview];
                              }];
             
             // TODO: display error graphic when needed
             
             // load the file data into the image
             self.image = [UIImage imageWithData:file.data];
             
             // if the developer wants to track progress
             if(completionBlock) {
                 
                 // send them the status
                 completionBlock(file, error);
             }
         }];
    
}

- (void) show
{
    
    // show with the default nil parameters
    [self showWithProgress:nil
             andCompletion:nil];
}

- (KTImageView*) initWithFrame:(CGRect)frame
                    andKiiFile:(KiiFile*)imageFile
{
    
    self = [super initWithFrame:frame];
    
    if(self) {
        _imageFile = imageFile;
    }
    
    return self;
}

+ (KTImageView*) createWithFrame:(CGRect)frame
                      andKiiFile:(KiiFile*)imageFile
{
    // create the view and show it automatically
    KTImageView *view = [[KTImageView alloc] initWithFrame:frame andKiiFile:imageFile];
    [view show];
    return view;
}

+ (KTImageView*) createWithFrame:(CGRect)frame
                      andKiiFile:(KiiFile*)imageFile
                    withProgress:(KTImageViewProgressBlock)progressBlock
                   andCompletion:(KTImageViewCompletionBlock)completionBlock
{
    // create the view and show it automatically
    KTImageView *view = [[KTImageView alloc] initWithFrame:frame andKiiFile:imageFile];
    [view showWithProgress:progressBlock andCompletion:completionBlock];
    return view;
}

@end

#endif
