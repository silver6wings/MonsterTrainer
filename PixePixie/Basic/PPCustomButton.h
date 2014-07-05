
#import <SpriteKit/SpriteKit.h>

@interface PPCustomButton : SKShapeNode

@property(nonatomic,assign) id target; //回调对象
@property(nonatomic,assign) SEL selector; //回调方法

//便利构造器
+(PPCustomButton *)buttonWithSize:(CGSize)size andTitle:(NSString *)title withTarget:(id)targetTmp withSelecter:(SEL)selectorTmp;
+(PPCustomButton *)buttonWithSize:(CGSize)size andImage:(NSString *)image withTarget:(id)targetTmp withSelecter:(SEL)selectorTmp;

@end