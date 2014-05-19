
#import "PPBallViewController.h"

@interface PPBallViewController ()
@property (nonatomic) SKView * skView;
@end

@implementation PPBallViewController

-(id)init{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor blackColor];
        
        
        // 准备战斗画面
        // CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 480)/2, 320, 450)
        _skView = [[SKView alloc] initWithFrame:self.view.bounds];
        _skView.backgroundColor = [UIColor clearColor];
        _skView.alpha = 0.0f;
        _skView.showsFPS = YES;
        
        // 如果skView没有scene则添加scene
        [self.view addSubview:_skView];
        if(!_skView.scene){
            PPBattleScene * battleScene = [[PPBattleScene alloc] initWithSize:_skView.bounds.size];
            battleScene.scaleMode = SKSceneScaleModeAspectFill;
            [self.skView presentScene:battleScene];
        }
        
        // 播放显示动画
        [UIView animateWithDuration:1.0f animations:^(void){
            _skView.alpha = 1.0f;
        } completion:^(BOOL finished){
        }];
        
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

// 开始战斗画面
-(void)startBattle{
    
}

@end