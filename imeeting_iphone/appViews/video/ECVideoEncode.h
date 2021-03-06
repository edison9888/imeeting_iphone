//
//  ECVideoEncode.h
//  imeeting_iphone
//
//  Created by star king on 12-6-28.
//  Copyright (c) 2012年 elegant cloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "quicklibav.h"
#import "libswscale/swscale.h"

@interface ECVideoEncode : NSObject {
    QuickVideoOutput *_qvo;
    AVFrame *_raw_picture;
    AVFrame *_tmp_picture;
    struct SwsContext *_img_convert_ctx;    
    enum PixelFormat _src_pix_fmt;
    
    BOOL _videoEncodeReady;
}
@property (nonatomic,retain) NSString *rtmpUrl;
@property (nonatomic,retain) NSString *liveName;
@property (nonatomic,retain) NSString *groupId;

@property (readwrite) int outImgWidth;
@property (readwrite) int outImgHeight;

- (void)setupVideoEncode;
- (void)releaseVideoEncode;
- (void)processRawFrame: (uint8_t *)buffer_base_address andWidth: (int)width andHeight: (int)height;

@end
