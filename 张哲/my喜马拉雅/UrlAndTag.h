//
//  UrlAndTag.h
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/17.
//  Copyright (c) 2015年 张哲. All rights reserved.
//

#ifndef my_____UrlAndTag_h
#define my_____UrlAndTag_h


#define kViewWidth self.view.frame.size.width
#define kViewHeight self.view.frame.size.height

#define LINE_TAG 100
#define BTN_TAG  200
#define BACKVIEW_TAG 400
#define HEADSCROLLIMAGE_TAG 500

#define BIGSCROLL_TAG 300
// -----发现
// 推荐
#define kRecommengURL @"http://mobile.ximalaya.com/mobile/discovery/v1/recommends?channel=ios-b1&device=iPhone&includeActivity=true&includeSpecial=true&scale=2&version=4.3.20"
// 分类
#define kFaxianFenleiUrl @"http://mobile.ximalaya.com/mobile/discovery/v1/categories?device=iPhone&picVersion=11&scale=2"
// 直播
#define  kFaxianZhiboUrl @"http://live.ximalaya.com/live-web/v1/getHomePageRadiosList?device=iPhone"
// 榜单
#define kFaxianBangdanUrl @"http://mobile.ximalaya.com/mobile/discovery/v2/rankingList/group?channel=ios-b1&device=iPhone&includeActivity=true&includeSpecial=true&scale=2&version=4.3.20"
// 主播
#define kFaxianZhuboUrl @"http://mobile.ximalaya.com/m/explore_user_index?device=iPhone&page=1"

#endif
