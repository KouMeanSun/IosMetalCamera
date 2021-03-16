//
//  MyMTKRender.h
//  MetalShowCamera
//
//  Created by 高明阳 on 2021/3/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyMTKRender : NSObject
// view
@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, strong) id<MTLTexture> texture;
@property (nonatomic, assign) CVMetalTextureCacheRef textureCache; //output
-(instancetype)initWithFrame:(CGRect )frame;

@end

NS_ASSUME_NONNULL_END
