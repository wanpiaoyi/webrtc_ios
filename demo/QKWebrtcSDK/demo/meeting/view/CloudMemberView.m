//
//  CloudMemberView.m
//  QKWebrtcSDK
//
//  Created by yangpeng on 2020/4/18.
//  Copyright © 2020 袁儿宝贝. All rights reserved.
//

#import "CloudMemberView.h"
#import "CloudMemberCell.h"
#import "QKWebrtcPubs.h"
#import "UIScrollView+Touch.h"

#define hlWidth ((webpubs.allWidth - 60)/4.3)

@interface CloudMemberView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong,nonatomic) UICollectionView *collect;
@property(nonatomic) UIInterfaceOrientation oldOrientation;
@property(nonatomic) CGSize itemSize;
@end

@implementation CloudMemberView

-(id)init{
    self = [super initWithFrame:CGRectMake(0, 0, 200, 200)];
    if(self){
        self.oldOrientation = UIInterfaceOrientationUnknown;
        [self initCollection];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initCollection];
    }
    return self;
}

-(void)initCollection{
    if(self.collect != nil){
        [self.collect removeFromSuperview];
    }
    UICollectionViewFlowLayout *flowLayout =  [self getLayout];
    self.collect = [[UICollectionView alloc]
                    initWithFrame:self.bounds
                    collectionViewLayout:flowLayout];
    
    self.collect.dataSource = self;
    self.collect.delegate = self;
    self.collect.backgroundColor = [UIColor clearColor];
    self.collect.scrollEnabled = YES;
    UINib *nib = [UINib nibWithNibName:@"CloudMemberCell"
                                bundle:[NSBundle mainBundle]];
    [self.collect registerNib:nib forCellWithReuseIdentifier:@"cell"];
    [self addSubview:self.collect];
}


#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex {
    return self.array_members.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"cell";
    QKRTCUser *part = [self.array_members objectAtIndex:indexPath.row];

    CloudMemberCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:str
                                              forIndexPath:indexPath];
    
    WS(weakSelf);
    [cell setTabItem:^{
        if(weakSelf.clickItem && part.objId != nil){
            weakSelf.clickItem(part,indexPath.row + 1);
        }
    }];
    
    if(part.objId == nil){
        cell.v_main.hidden = YES;
        return cell;
    }
    cell.v_main.hidden = NO;

    cell.lbl_name.text = part.name;
    cell.layer.cornerRadius = 5.0;
    
    BOOL hasMic = part.audio;
    BOOL hasVideo = part.video;
    QKRTCRenderView *v = nil;
    
    NSString *memberId = part.objId;
    NSString *type = part.type;
    if(hasMic || hasVideo){
        v = [QKMeetingCloud getRenderView:memberId type:type];
    }
    if([part.type isEqualToString:screenType]){
        cell.img_back.image = [UIImage imageNamed:@"qkrtc_defaule_share"];
    }else{
        cell.img_back.image = [UIImage imageNamed:userDefaultHeader];
    }
    if([part.type isEqualToString:screenType]){
         v.videoMode = QKRenderModeFit;
    }else{
         v.videoMode = QKRenderModeFill;
    }


    for(UIView *view in cell.v_layouts.subviews){
        [view removeFromSuperview];
    }
    if(v != nil&&hasVideo){
        v.frame = CGRectMake(0, 0, self.itemSize.width,  self.itemSize.height);
        [cell.v_layouts addSubview:v];
        cell.img_back.hidden = YES;
    }else{
        cell.img_back.hidden = NO;
    }
    
 
    if(hasMic){
        cell.img_mic.image = [UIImage imageNamed:@"qkrtc_watch_audioOpened"];
    }else{
        cell.img_mic.image = [UIImage imageNamed:@"qkrtc_watch_audioClosed"];
    }
    
    

    cell.lbl_name.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    cell.memberId = memberId;
    cell.type = type;

    return cell;

}


- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)reloadData{
    [self.collect reloadData];
}

-(void)changeFrame{
    BOOL reinit = false;

    UIInterfaceOrientation nowOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(self.oldOrientation != nowOrientation){
        self.oldOrientation = nowOrientation;
        reinit = true;
    }
    int width = 0;
    int height = 0;
    int x = 0;
    int y = 0;
    
    if(nowOrientation == UIInterfaceOrientationPortrait || nowOrientation == UIInterfaceOrientationPortraitUpsideDown){
        height = hlWidth;
        width = webpubs.allWidth - 30;
        x = 15;
        y = webpubs.allHeight - height - webpubs.safeBottom - 100 - webpubs.safeTop;
        if(self.titleHidden){
            y = y + 90;
        }
    }else{
        int top = 0;
        if(webpubs.safeTop != 20){
            top = webpubs.safeTop;
        }
        height = webpubs.allWidth - 30;
        width = hlWidth;
        y = 15;
        x = webpubs.allHeight - width - webpubs.safeBottom - 20 - top;
        if(!self.titleHidden){
            y = y + 31;
            height = height - 31;
        }
        
    }
    CGRect rect = CGRectMake(x, y, width, height);
    self.frame = rect;
    if(reinit){
        [self initCollection];
    }else{
        self.collect.frame = self.bounds;
    }
}

-(UICollectionViewFlowLayout*)getLayout{
    UIInterfaceOrientation nowOrientation = [UIApplication sharedApplication].statusBarOrientation;

    UICollectionViewFlowLayout *flowLayout = nil;
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    if(nowOrientation == UIInterfaceOrientationPortrait || nowOrientation == UIInterfaceOrientationPortraitUpsideDown){
        [flowLayout setItemSize:CGSizeMake(hlWidth, hlWidth)]; //设置cell的尺寸
        flowLayout.sectionInset = UIEdgeInsetsMake(8, 0, 8,0); //设置其边界
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //设置其布局方向
    }else{
        [flowLayout setItemSize:CGSizeMake(hlWidth, hlWidth)]; //设置cell的尺寸
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0,8); //设置其边界
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置其布局方向
    }
    self.itemSize = CGSizeMake(hlWidth, hlWidth);


    return flowLayout;
}

-(CGRect)reckonRect:(CGRect)rect scale:(double)scale{
    
    CGSize superBoundSize = rect.size;
    float width = superBoundSize.width;
    float height = superBoundSize.height;
    
    float fitheight = width / scale;
    
    float fitWidth = height * scale;
    if(fitheight < height){
        return CGRectMake(rect.origin.x, rect.origin.y + (height - fitheight) / 2, width, fitheight);
    }
    return CGRectMake(rect.origin.x + (width - fitWidth)/ 2, rect.origin.y,fitWidth , height);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan");
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesEnded");
    if(self.touchEnd != nil){
        self.touchEnd();
    }
    
//    [[self nextResponder] touchesBegan:touches withEvent:event];
}

-(void)titleChanged:(BOOL)hidden{
    if(self.titleHidden != hidden){
        self.titleHidden = hidden;
  
        [self changeFrame];
    }
}
@end
