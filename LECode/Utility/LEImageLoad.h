//
//  LEImageLoad.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/28/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"

@interface LEImageLoad : NSObject


+ (void)imageView:(UIImageView *)imageView setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock ;
    
@end
