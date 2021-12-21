//
//  JbbAnimatedLabelTextViewController.m
//  AnimatedLabelText
//
//  Created by 9haomi on 2021/12/8.
//

#import "JbbAnimatedLabelTextViewController.h"

#import <Lottie/Lottie.h>

@interface JbbAnimatedLabelTextViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *disPlayImageView;

@property (nonatomic, strong) CAGradientLayer *layer;
@property (nonatomic, strong) UILabel *mylabel;

@property (nonatomic, strong) dispatch_source_t playTimer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) LOTAnimationView * startanimation;

@end

@implementation JbbAnimatedLabelTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.imageArray = [[NSMutableArray alloc] init];
//    
//    self.mylabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
//    
//    self.mylabel.text = @"一个人的时候，我想静一静";
//    
//    self.mylabel.adjustsFontSizeToFitWidth = YES;
//    
//    [self.view addSubview:self.mylabel];
//    
//    
//    
//    //创建透明层和label控件的大小一致
//    
//    self.layer = [CAGradientLayer layer];
//    
//    self.layer.frame = self.mylabel.frame;
//    
//    //设定渐变层变化color的数组
//    
//    self.layer.colors = @[(id)[self randomColor].CGColor,(id)[self randomColor].CGColor,(id)[self randomColor].CGColor,(id)[self randomColor].CGColor,(id)[self randomColor].CGColor];
//    
//    //把渐变层加到整个view上面
//    
//    [self.view.layer addSublayer:self.layer];
//    
//    //最关键的一步，设置渐变图层的mask为label图层，就能用文字裁剪渐变图层了
//    
//    self.layer.mask = self.mylabel.layer;
//    
//    self.mylabel.frame = self.layer.bounds;
//    
//    //这个相比于NStimer的区别，大家自己去查
//    
//    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(textColorChange)];
//    
//    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    //获取全局子线程队列
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.playTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.playTimer,dispatch_walltime(NULL, 0),0.1*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.playTimer, ^{
        //在主线程刷新页面
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf playImagesInOrder];
        });
    });
    dispatch_resume(self.playTimer);
    
    self.startanimation = [[LOTAnimationView alloc] initWithFrame:CGRectMake(0, 100, 200, 100)];
    //self.startanimation.backgroundColor = [UIColor redColor];
//    [self.startanimation setAnimationNamed:@"play2" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"play2" ofType:@"bundle"]]];
    [self.startanimation setAnimationNamed:@"wenzi"];//音乐加载动画
    //self.startanimation.loopAnimation = NO; //是否是循环播放
    //self.startanimation.animationSpeed = 1;
    [self.startanimation playWithCompletion:^(BOOL animationFinished) {
        //取消GCD定时器
        if (weakSelf.playTimer) {
            dispatch_source_cancel(weakSelf.playTimer);
        }
        
        NSLog(@"得到录屏数据：%lu",(unsigned long)weakSelf.imageArray.count);
    }];
    self.startanimation.cacheEnable = YES;//缓存动画
    [self.view addSubview:self.startanimation];
}

// 定时器触发方法

-(void)textColorChange {
    self.layer.colors = @[(id)[self randomColor].CGColor,

                              (id)[self randomColor].CGColor,

                              (id)[self randomColor].CGColor,

                              (id)[self randomColor].CGColor,

                              (id)[self randomColor].CGColor];

}


-(UIColor*)randomColor{
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0

                           green:arc4random_uniform(255)/255.0

                            blue:arc4random_uniform(255)/255.6

                           alpha:1];

}

- (void)playImagesInOrder{
    NSLog(@"当前进度：%f",self.startanimation.animationProgress);
    UIImage *image2 = [self getImageHighdeScalen:self.startanimation];
    [self.imageArray addObject:image2];
    
    
//    UIImage *image2 = [self getImageHighdeScalen:self.startanimation];
//    [self.imageArray addObject:image2];
//
//    if (self.imageArray.count>0) {
//
//        if (self.currentIndex >= self.imageArray.count) {
//            self.currentIndex = 0;
//        }
//
//        UIImage *image = self.imageArray[self.currentIndex];
//
//        self.disPlayImageView.image = image;
//
//
//
//        self.currentIndex++;
//
//    }
//
}

- (IBAction)clickSaveBtn:(id)sender {
//    self.imageArray = [[NSMutableArray alloc] init];
//    for (int i= 0; i<10; i++) {
//        UIImage *image = [self getImageHighdeScalen:self.startanimation];
//        [self.imageArray addObject:image];
//    }
    
}

//超级高清目前给文本编辑后转图片用
- (UIImage *)getImageHighdeScalen:(UIView *)view{
    //1.开启一个位图上下文
    CGSize size = CGSizeMake(view.layer.bounds.size.width, view.layer.bounds.size.height);
    //NSLog(@"====我的比例：%f",[UIScreen mainScreen].scale);
    //缩放因子scale大于2.5之后，微信选择相册后发送的GIF会报尺寸过大问题，qq就不会
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    //2.把画板上的内容渲染到上下文当中
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    //3.从上下文当中取出一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    //4.关闭上下文
    UIGraphicsEndImageContext();

    return newImage;
}

@end
