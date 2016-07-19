//
//  UserDefaultKey.h
//  HLMagic
//
//  Created by fengzifeng on 1/1/14.
//  Copyright (c) 2014 fengzifeng. All rights reserved.
//

#ifndef HLMagic_UserDefaultKey_h
#define HLMagic_UserDefaultKey_h

#define UserDefaultKey_LoginUser                           @"LoginUser"                         //当前登录用户

#define UserDefaultKey_ConfigFlags                         @"ConfigFlags"                       //服务器端返回的功能配置信息

#define UserDefaultKey_MiPushInfo                          @"MiPushInfo"                       //注册的小米Push的信息
#define UserDefaultKey_sinaAuthInfo                        @"sinaAuthInfo"                     //新浪用户认证信息
#define UserDefaultKey_mediaUploadList                     @"mediaUploadList"                  //等待上传的多媒体列表
#define UserDefaultKey_backgroundTask                      @"backgroundTask"                   //需要在后台执行的任务（上传动态）
#define UserDefaultKey_ComeAccrossLimit                    @"comeAccrossLimit"                 //发偶遇是否需要vip限制
#define UserDefaultKey_ComeAccrossRule                     @"comeAccrossRule"                //自动发偶遇的规则信息

#define UserDefaultKey_albumImprovement                    @"albumImprovement"                 //是否已显示完善照片墙页面
#define UserDefaultKey_advertActive                        @"advertActive"                     //是否已报送服务器端已激活

#define UserDefaultKey_apiDomain                           @"apiDomain"                        //API 域名
#define UserDefaultKey_rpcDomain                           @"rpcDomain"                        //RPC 域名
#define UserDefaultKey_xmppDomain                          @"xmppDomain"                       //XMPP 域名
#define UserDefaultKey_downloadDomain                      @"downloadDomain"                   //下载图片 域名
#define UserDefaultKey_uploadDomain                        @"uploadDomain"                     //上传文件 域名
#define UserDefaultKey_logDomain                           @"logDomain"                        //上传日志文件 域名
#define UserDefaultKey_deviceToken                         @"deviceToken"                      //app 推送token
#define UserDefaultKey_favoriteArea                        @"favoriteArea"                     //常用国家

#define UserDefaultKey_customApiDomain                     @"customApiDomain"                   //自定义的API 域名

#define UserDefaultKey_RpcVersion                          @"RpcVersion"                       //rpc数据的版本号

#define UserDefaultKey_genderFilter                        @"genderFilter"                     //附近的人性别筛选
#define UserDefaultKey_regionFilter                        @"regionFilter"                     //附近的人地区筛选

#define UserDefaultKey_latitude                            @"latitude"                         //当前位置纬度
#define UserDefaultKey_longtitude                          @"longtitude"                       //当前位置经度
#define UserDefaultKey_city                                @"city"                             //当前城市
#define UserDefaultKey_cityCode                            @"cityCode"                         //当前城市编码

#define UserDefaultKey_showSendFlowerTip                   @"showSendFlowerTip"                //送花提示
#define UserDefaultKey_newNoticeInfo                       @"newNoticeInfo"                    //未读提示信息

#define UserDefaultKey_registerType                        @"registerType"                      //登录类型 1手机登录2qq登录3微博登录 4facebook登录
#define UserDefaultKey_versionUpdate                       @"versionUpdate"                     //是否有版本更新
#define UserDefaultKey_nextTimeUpdate                      @"nextTimeUpdate"                    //更新时用户点击下次再说
#define UserDefaultKey_timeDifference                      @"timeDifference"                    //本地时间和服务器端时间之间的差值
#define UserDefaultKey_devFeedback                         @"devFeedback"                       //是否有新的反馈信息
#define UserDefaultKey_imageCacheSize                      @"imageCacheSize"                    //图片缓存的大小

#define UserDefaultKey_mailBoxNotice                       @"mailBoxNotice"                     //信箱通知
#define UserDefaultKey_giftNotice                          @"giftNotice"                        //礼物通知
#define UserDefaultKey_messageNotice                       @"messageNotice"                     //消息通知
#define UserDefaultKey_autoNotice                          @"autoNotice"                        //自动关注

#define UserDefaultKey_myFriendList                        @"FriendListDic"                     //好友列表
#define UserDefaultKey_myGroupList                         @"myGroupList"                        //群组列表
#define UserDefaultKey_blackList                           @"blackList"                         //黑名单列表
#define UserDefaultKey_ignoredGroup                        @"ignoredGroup"                      //关闭群消息通知的列表
#define UserDefaultKey_visitorList                         @"visitorList"                       //访客列表

#define UserDefaultKey_lastVideoRecommend                  @"lastVideoRecommend"                //最后一次加载的视频推荐信息
#define UserDefaultKey_lastQuestAccost                     @"lastQuestAccost"                   //最后一次加载的求勾搭信息
#define UserDefaultKey_lastQuestJoke                       @"lastQuestJoke"                     //最后一次加载的笑话信息
#define UserDefaultKey_lastQuestEssence                    @"lastQuestEssence"                  //最后一次加载的笑话精华信息

#define UserDefaultKey_lastVideoList                       @"lastVideoList"                     //最后一次加载的视频认证列表信息
#define UserDefaultKey_lastNearByGroup                     @"lastNearByGroup"                   //最后一次加载的附近的群信息
#define UserDefaultKey_lastNearByUser                      @"lastNearByInfo"                    //最后一次加载的附近的人信息
#define UserDefaultKey_lastCommentList                     @"lastCommentList"                   //最后一次加载的评论列表信息
#define UserDefaultKey_lastAccostSendTime                  @"lastAccostSendTime"                //最后一次发送求勾搭的时间

#define UserDefaultKey_telephoneReceiver                   @"telephoneReceiver"                 //是否已开启听筒模式
#define UserDefaultKey_helpUrl                             @"helpUrl"                           //帮助页面的链接
#define UserDefaultKey_startUrl                            @"startUrl"                          //启动图片的链接
#define UserDefaultKey_receiptCache                        @"receiptCache"                      //购买收据缓存
#define UserDefaultKey_activeNum                           @"activeNum"                         //活跃次数
#define UserDefaultKey_hasGrade                            @"hasGrade"                          //是否已评价
#define UserDefaultKey_fillChargesPhone                    @"fillChargesPhone"                  //已填写的兑换话费的手机号

#define UserDefaultKey_cacheArray                          @"cacheArray"                        //发布动态缓存数组
#define UserDefaultKey_failedCacheArray                    @"failedCacheArray"                  //发布动态失败缓存数组
#define UserDefaultKey_taskArray                           @"taskArray"                         //发布动态队列数组
#define UserDefaultKey_failedArray                         @"failedArray"                       //发布动态失败队列数组

#define UserDefaultKey_unSyncUserInfo                      @"unSyncdUserInfo"                   //未同步的用户信息

#define UserDefaultKey_vipExpireTime                       @"vipExpireTime"                     //vip到期时间

#define UserDefaultKey_flowerCourse                        @"flowerCourse"                      //小秘书送花教程

#define UserDefaultKey_authingLocaWaiting                  @"authingLocaWaiting"                //视频认证本地未上传状态
#define UserDefaultKey_authingLocaTime                     @"authingLocaTime"                   //视频认证本地未上传状态视频时间
#define UserDefaultKey_authingLocaFileName                 @"authingLocaFileName"               //视频认证本地未上传状态存储文件名
#define UserDefaultKey_authingSecondStatus                 @"authingLocaStatus"                 //视频认证二次认证状态

#define UserDefaultKey_captcha                             @"captcha"                           //请求验证码

#define UserDefaultKey_everydayFlowerNum                   @"everydayFlowerNum"                 //每日鲜花数量
#define UserDefaultKey_everydayFlowerStatus                @"everydayFlowerStatus"              //每日任务领花状态
#define UserDefaultKey_shareFlowerNewsId                   @"shareFlowerNewsId"                 //分享领花ids
#define UserDefaultKey_shareFlowerStatus                   @"shareFlowerStatus"                 //分享领花状态

#define UserDefaultKey_magicCacheData                      @"magicCacheData"                    //魔圈第一次加载缓存数据
#define UserDefaultKey_exchangingOrder                     @"exchangingOrder"                   //正在兑换中订单信息

#define UserDefaultKey_suppressedUIds(UID)  [NSString stringWithFormat:@"suppressedUIdsWithUID_%@",UID] //三天内出现过的人的id
#define UserDefaultKey_photoLikeUIDArr                     @"photoLikeUIDArr"
#define UserDefaultKey_photoNopeUIDArr                     @"photoNopeUIDArr"
#define UserDefaultsKey_hiddenPhotoRate                    @"hiddenPhotoRate"                    //隐藏照片打分
#define UserDefaultsKey_hiddenAdvertise                    @"hiddenAdvertise"                    //隐藏广告banner条

#define UserDefaultKey_thisRanking                         @"my_this_ranking"                    //排行榜新老排名数据字典
#define UserDefaultKey_startupLogPath                      @"startupLogPath"                     //本次启动日志文件

#define UserDefaultKey_publishCommentTip                   @"publishCommentTip"                  //存储是否是第一次评论

#endif
