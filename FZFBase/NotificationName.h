//
//  NotificationName.h
//  HLMagic
//
//  Created by fengzifeng on 1/2/14.
//  Copyright (c) 2014 fengzifeng. All rights reserved.
//

//http://segmentfault.com/q/1010000000193333

#ifndef HLMagic_NotificationName_h
#define HLMagic_NotificationName_h

#define UMFBGetFinishedNotification                             @"UMFBGetFinishedNotification"          //友盟完成数据刷新通知
#define UMFBPostFinishedNotification                            @"UMFBPostFinishedNotification"         //友盟上传数据完成通知

#define Notification_ApplicationActive                          @"ApplicationActive"                    //应用激活
#define Notification_LoginComplete                              @"loginComplete"                        //用户完成登录请求
#define Notification_LoginSuccess                               @"loginSuccess"                         //用户登录成功，可以开始刷新其他界面数据
#define Notification_LogoutSuccess                              @"LogoutSuccess"                        //用户退出登录
#define Notification_ShowBinding                                @"ShowBinding"                          //需要显示绑定页面
#define Notification_ShowPhoneLogin                             @"ShowPhoneLogin"                       //显示手机登陆页
#define Notification_HasShowNoticeObject                        @"HasShowNoticeObject"                  //是否已经显示过提示性的消息

#define Notification_HideTimeLineOptionBar                      @"HideTimeLineOptionBar"                //隐藏魔圈、他的TimeLine中的送花评论面板
#define Notification_ChatNewMessage                             @"aNewChatMessage"                      //收到新的聊天消息
#define Notification_ShowSendFlowerAlert                        @"showSendFlowerAlert"                  //送花提示信息
#define Notification_UpdatePublish                              @"updatePublish"                        //更新发布界面刷新
#define Notification_UpdateRegister                             @"updateRegisterImage"                  //更新注册页面图片
#define Notification_UpdateRegisterData                         @"updateRegisterData"                   //更新注册页面

#define Notification_DeleteSomeDynamic                          @"deleteSomeDynamic"                    //删除某条动态

#define Notification_DeleteSomeComment                          @"deleteSomeComment"                    //删除某条评论
#define Notification_Praise                                     @"KeepPraiseConsistent"                    //使详情里面的赞和魔圈里面一致
#define Notification_UpdateNewNotice                            @"UpdateNewNotice"                      //显示未读评论数量、动态红点、新粉丝、新访客
#define Notification_UpdateMagicHeader                          @"UpdateMagicHeader"                    //刷新魔圈的 header 包括 广告、未读消息、定位、网络状况
#define Notification_GoHeadToMessage                            @"GoHeadToMessage"                      //进入未读消息页面
#define Notification_UpdateDynamicModel                         @"UpdateDynamicModel"                   //更新缓存中的动态模 魔圈、TimeLine、详情
#define Notification_RollToFirstMagic                           @"RollToFirstMagic"                     //滚动到魔圈中的第一条数据

#define Notification_UpdateAccostData                           @"upDateAccostData"                     //请求更新偶遇数据

#define Notification_PublishActivity                            @"PublishActivity"                      //发布了一条新的活动

#define Notification_ChangePlayMode                             @"ChangePlayMode"                       //聊天中播放语音
#define Notification_ChatPlayingAudio                           @"ChatPlayingAudio"                     //聊天中播放语音
#define Notification_ChatUpdateUnreadCount                      @"updateUnreadChatCount"                //更新聊天未读消息数量
#define Notification_ChatUploadProgress                         @"uploadProgress"                       //聊天上传进度通知

#define Notification_RefreshMyTimeLine                          @"RefreshMyTimeLine"                    //刷新我的TimeLine
#define Notification_RefreshUserInfo                            @"RefreshUserInfo"                      //刷新用户信息
#define Notification_RefreshChatMessage                         @"RefreshChatMessage"                   //刷新聊天信息
#define Notification_NewGroupAnnouncement                       @"NewGroupAnnouncement"                 //有新的群公告
#define Notification_DeleteGroupMessage                         @"DeleteGroupMessage"                   //删除群聊天信息
#define Notification_DeleteChatMessage                          @"DeleteChatMessage"                    //删除聊天信息

#define Notification_EnterTimeline                              @"enterTimeLine"                        //进入timel
#define Notification_FlowerLack                                 @"myFlowerLack"                         //鲜花不足
#define Notification_HideChatToolBar                            @"hideChatToolBar"                      //隐藏聊天面板

#define Notification_UpdateAlbum                                @"updateAlbum"                          //更新相册
#define Notification_UpdateEditingUserInfo                      @"UpdateEditingUserInfo"                //更新正在编辑的用户信息

#define Notification_RefreshFonceOn                             @"refreshFonceOn"                       //otherTimeline关注
#define Notification_DetailFonceOn                              @"detailFonceOn"                        //他人详情页关注

#define Notification_updateFreeFlowerData                       @"updateFreeFlowerData"                 //刷新免费得花页面
#define Notification_updateGroupZoneData                        @"updateGroupZoneData"                  //刷新群动态页面

#define Notification_updateSelectLine                           @"Notification_updateSelectLine"        //刷新选择路线页面
#define Notification_delPicUpdateGroupZone                      @"Notification_delPicUpdateGroupZone"   //删除图片刷新群动态
#define Notification_showOptionBar                              @"Notification_showOptionBar"           //评论页面弹出操作栏
#define Notification_deleteDynamic                              @"Notification_deleteDynamic"           //评论页面删除自己的动态
#define Notification_clickPraise                                @"Notification_clickPraise"             //评论页面操作栏的点击点赞
#define Notification_sendFlower                                 @"Notification_sendFlower"              //评论页面操作栏的点击送花
#define Notification_clickCommemt                               @"Notification_clickCommemt"            //评论页面操作栏的点击评论
#define Notification_LoadingMorerComment                        @"Notification_LoadingMorerComment"     //评论页面获取更多的评论
#define Notification_PublishCommentTip                               @"Notification_PublishCommentTip"       //第一次评论提示


#define Notification_reloadPhotoList                            @"NotiReloadPhotoList"                  //重新刷新 照片打分的照片列表数据
#define Notification_refreshBanner                              @"NotiRefreshBanner"                    //刷新广告条
#define Notification_refreshBroadcatView                        @"Notification_refreshBroadcatView"     //刷新跑道
#define Notification_showDownSlideArrow                        @"Notification_showDownSlideArrow"       //跑道下拉列表按钮显示
#define Notification_refreshSlideDownListView                   @"Notification_refreshSlideDownListView"//刷新跑道下拉列表
#define Notification_removeSlideDownListView                    @"Notification_removeSlideDownListView" //移除跑道下拉列表

#define Notification_refreshRankList                            @"refreshRankList"                      //刷新排行榜数据
#define Notification_locationGet                                @"locationGet"                          //定位到位置后的通知


#endif