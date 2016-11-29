//
//  LEImageLoad.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/28/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "LEImageLoad.h"

@implementation LEImageLoad

+ (void)imageView:(UIImageView *)imageView setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    if (url) {
        [imageView sd_setImageWithURL:url
                          placeholderImage:nil
                                   options:options
                                  progress:progressBlock completed:completedBlock];
    }
}

@end
