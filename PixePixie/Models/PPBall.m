
#import "PPPixie.h"

@interface PPBall ()
@property (nonatomic) SKTexture * defaultTexture;
@end




@implementation PPBall
@synthesize sustainRounds,pixie, ballElementType, pixieEnemy,ballStatus,comboBallTexture,comboBallSprite;

#pragma mark Factory Method

// 创建元素球
+(PPBall *)ballWithElement:(PPElementType) elementType{
    
    NSString * imageName = [NSString stringWithFormat:@"%@%@%@",@"ball_", kPPElementTypeString[elementType],@".png"];
    NSLog(@"imageName=%@",imageName);
    
    if (imageName == nil) return nil;
    SKTexture * tTexture = [SKTexture textureWithImageNamed:imageName];
    
    PPBall * tBall = [PPBall spriteNodeWithTexture:tTexture];
    
    if (tBall){
        
        tBall.defaultTexture = tTexture;
        tBall.name = [NSString stringWithFormat:@"ball_%@", kPPElementTypeString[elementType]];
        tBall.ballElementType = elementType;
        tBall.size = CGSizeMake(kBallSize, kBallSize);
        
        [PPBall defaultBallPhysicsBody:tBall];
        
        tBall.pixie = nil;
    }
    
    PPBasicLabelNode *roundsLabel = [[PPBasicLabelNode alloc] init];
    roundsLabel.name = @"roundsLabel";
    roundsLabel.fontColor = [UIColor redColor];
    roundsLabel.position = CGPointMake(10, 10);
    [roundsLabel setText:@"0"];
    roundsLabel.fontSize=15;
    
    [tBall addChild:roundsLabel];
    
    
    tBall.ballType = PPBallTypeElement;
    return tBall;
}
-(void)setRoundsLabel:(int)rounds
{
    
    PPBasicLabelNode *roundsLabel =(PPBasicLabelNode *)[self childNodeWithName:@"roundsLabel"];
    [roundsLabel setText:[NSString stringWithFormat:@"%d",rounds]];
    
    
}

// 创建玩家宠物的球
+(PPBall *)ballWithPixie:(PPPixie *)pixie{
    
    NSString * imageName = [NSString stringWithFormat:@"ball_pixie_%@%d.png",
                            kPPElementTypeString[PPElementTypePlant],
                            pixie.pixieGeneration];
//    NSString * imageName = [NSString stringWithFormat:@"ball_pixie_%@%d.png",
//                            [ConstantData elementName:PPElementTypePlant],
//                            pixie.pixieGeneration];

    if (imageName == nil) return nil;
    
    SKTexture * tTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@%d_ball.png",kPPElementTypeString[pixie.pixieElement],pixie.pixieGeneration]];
    PPBall * tBall = [PPBall spriteNodeWithTexture:tTexture];
    
    if (tBall){
        tBall.ballElementType = pixie.pixieElement;
        tBall.size = CGSizeMake(kBallSize, kBallSize);
        [PPBall defaultBallPhysicsBody:tBall];
        
        tBall.pixie = pixie;
    }
    
    //    PPBasicLabelNode *additonLabel= [[PPBasicLabelNode alloc] init];
    //    additonLabel.position = CGPointMake(0.0f, 10.0f);
    //    [additonLabel setText:@"%100"];
    //    [tBall addChild:additonLabel];
    
    tBall.ballType = PPBallTypePlayer;
    return tBall;
    
}

// 创建敌人的球
+(PPBall *)ballWithPixieEnemy:(PPPixie *)pixieEnemy;
{
    
    NSString * imageName = [NSString stringWithFormat:@"ball_pixie_%@%d.png",
                            kPPElementTypeString[PPElementTypePlant],
                            pixieEnemy.pixieGeneration];
    
    if (imageName == nil) return nil;
    //    SKTexture * tTexture = [SKTexture textureWithImageNamed:imageName];
    SKTexture * tTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@%d_ball.png",kPPElementTypeString[pixieEnemy.pixieElement],pixieEnemy.pixieGeneration]];
    
    
    NSLog(@"imageName=%@",imageName);
    
    PPBall * tBall = [PPBall spriteNodeWithTexture:tTexture];
    
    if (tBall){
        
        tBall.ballElementType = pixieEnemy.pixieElement;
        tBall.size = CGSizeMake(kBallSize, kBallSize);
        [PPBall defaultBallPhysicsBody:tBall];
        tBall.pixieEnemy = pixieEnemy;
        
    }
    
    
    tBall.ballType = PPBallTypeEnemy;
    return tBall;
    
}

// 创建连击球
+(PPBall *)ballWithCombo
{
    
    NSString * imageName = @"combo_ball.png";
    
 
    
    
    if (imageName == nil) return nil;
    SKTexture * tTexture = [SKTexture textureWithImageNamed:imageName];
    
    PPBall * tBall = [PPBall spriteNodeWithTexture:tTexture];
    
    NSMutableArray *textureArray=[[NSMutableArray alloc] init];
    for (int i=0; i<25; i++) {
        SKTexture *textureCombo = [[TextureManager ball_table] textureNamed:[NSString stringWithFormat:@"combo_ball_00%d",i]];
        [textureArray addObject:textureCombo];
    }
    tBall.comboBallTexture = textureArray;
    
    
   
    
    
    if (tBall){
        
        tBall.defaultTexture = tTexture;
        tBall.name = @"combo";
        tBall.ballElementType = PPElementTypeNone;
        tBall.size = CGSizeMake(kBallSize, kBallSize);
        
        [PPBall defaultBallPhysicsBody:tBall];
        
        tBall.pixie = nil;
    }
    
    tBall.ballType = PPBallTypeCombo;
    return tBall;
}

// 改为默认皮肤
-(void)setToDefaultTexture{
    [self runAction:[SKAction setTexture:_defaultTexture]];
}
-(void)startComboAnimation
{
    if (self.comboBallSprite !=nil) {
        [self.comboBallSprite removeFromParent];
        self.comboBallSprite = nil;
    }
    
    self.comboBallSprite =[[PPBasicSpriteNode alloc] init];
    self.comboBallSprite.size = CGSizeMake(50.0f, 50.0f);
    [self.comboBallSprite setPosition:CGPointMake(0.0f, 0.0f)];
    [self addChild:self.comboBallSprite];
    
    
    [self.comboBallSprite runAction:[SKAction animateWithTextures:self.comboBallTexture timePerFrame:0.02] completion:^{
        [self.comboBallSprite removeFromParent];
      }];
    
}

// 默认的球的物理属性
+(void)defaultBallPhysicsBody:(SKSpriteNode *)ball{
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:kBallSize / 2];
    
    ball.physicsBody.linearDamping = kBallLinearDamping;    // 线阻尼系数
    ball.physicsBody.angularDamping = kBallAngularDamping;  // 角阻尼系数
    ball.physicsBody.friction = kBallFriction;              // 表面摩擦力
    ball.physicsBody.restitution = kBallRestitution;        // 弹性恢复系数
    
    ball.physicsBody.dynamic = YES;                         // 说明物体是动态的
    ball.physicsBody.usesPreciseCollisionDetection = YES;   // 使用快速运动检测碰撞
    
}

@end
