//
//  MyMTKRender.m
//  MetalShowCamera
//
//  Created by 高明阳 on 2021/3/15.
//
@import MetalKit;

#import "MyMTKRender.h"
#import <MetalPerformanceShaders/MetalPerformanceShaders.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MyMTKRender()<MTKViewDelegate>


// data
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;


@end

@implementation MyMTKRender

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super init];
    if (self) {
        [self setupMetalWithFrame:frame];
    }
    return self;
}


- (void)setupMetalWithFrame:(CGRect )frame {
    self.mtkView = [[MTKView alloc] initWithFrame:frame];
    
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    self.mtkView.delegate = self;
    self.mtkView.framebufferOnly = NO; // 允许读写操作
    //    self.mtkView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    self.commandQueue = [self.mtkView.device newCommandQueue];
    CVMetalTextureCacheCreate(NULL, NULL, self.mtkView.device, NULL, &_textureCache);
}

#pragma mark - delegate

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

- (void)drawInMTKView:(MTKView *)view {
//    NSLog(@"进入 drawInMTKView:(MTKView *)view ");
    if (self.texture) {
//        NSLog(@"self.texture 不为空");
        id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer]; // 创建指令缓冲
        id<MTLTexture> drawingTexture = view.currentDrawable.texture; // 把MKTView作为目标纹理
        
        MPSImageGaussianBlur *filter = [[MPSImageGaussianBlur alloc] initWithDevice:self.mtkView.device sigma:1]; // 这里的sigma值可以修改，sigma值越高图像越模糊
        [filter encodeToCommandBuffer:commandBuffer sourceTexture:self.texture destinationTexture:drawingTexture]; // 把摄像头返回图像数据的原始数据
        
        [commandBuffer presentDrawable:view.currentDrawable]; // 展示数据
        [commandBuffer commit];
        
        self.texture = NULL;
    }else {
        NSLog(@"self.texture 为空");
    }
}
@end
