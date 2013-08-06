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

#import <UIKit/UIKit.h>

@class KiiFile, KTProgressIndicator;

/* Block definitions for this class */
typedef void (^KTImageViewProgressBlock)(KiiFile *file, double progress);
typedef void (^KTImageViewCompletionBlock)(KiiFile *file, NSError *error);

/**
 A UI element that will asynchronously load and display a KiiFile image in a UIImageView by simply passing in a valid KiiFile object. Also provides a progress indicator by default. All attributes can be overriden and customized.
 */
@interface KTImageView : UIImageView

/** The KiiFile object associated with the KTImageView. Setting this alone won't load the file, you must also call show: */
@property (nonatomic, strong) KiiFile *imageFile;

/** The progress indicator, visible and on by default */
@property (nonatomic, strong) KTProgressIndicator *progressIndicator;

/**
 Initialize a KTImageView object
 
 Make sure that you call one of the show: methods once initialized and added to your view. This method will simply create the object.
 @param frame The frame of the image view
 @param imageFile The KiiFile object to load and display
 @return A KTImageView object
 */
- (KTImageView*) initWithFrame:(CGRect)frame
                    andKiiFile:(KiiFile*)imageFile;

/**
 Create a KTImageView object and begin loading the image automatically
 
 If you wish to customize your view before it starts loading, use the init and show method(s). This method will automatically begin loading the image file into the view. This method provides no callbacks - if you wish to know when the image is progressing/loaded, use one of the other creation methods with blocks.
 @param frame The frame of the image view
 @param imageFile The KiiFile object to load and display
 @return A KTImageView object
 */
+ (KTImageView*) createWithFrame:(CGRect)frame
                      andKiiFile:(KiiFile*)imageFile;

/**
 Create a KTImageView object and begin loading the image automatically - with callbacks
 
 If you wish to customize your view before it starts loading, use the init and show method(s). This method will automatically begin loading the image file into the view. This method provides callback blocks for you to receive updates as the image is downloaded and shown
 @param frame The frame of the image view
 @param imageFile The KiiFile object to load and display
 @param progressBlock Called as the image file is downloading
 @param completionBlock Called once the image file is downloaded (or if an error occurred)
 @return A KTImageView object
 */
+ (KTImageView*) createWithFrame:(CGRect)frame
                      andKiiFile:(KiiFile*)imageFile
                    withProgress:(KTImageViewProgressBlock)progressBlock
                   andCompletion:(KTImageViewCompletionBlock)completionBlock;

/**
 Start downloading the image file and display the image once it's ready
 
 This method provides no callbacks. If you wish to have notifications, use the other show method
 */
- (void) show;

/**
 Start downloading the image file and display the image once it's ready - with callbacks
 
 @param progressBlock Called as the image file is downloading
 @param completionBlock Called once the image file is downloaded (or if an error occurred)
 */
- (void) showWithProgress:(KTImageViewProgressBlock)progressBlock
            andCompletion:(KTImageViewCompletionBlock)completionBlock;

@end
