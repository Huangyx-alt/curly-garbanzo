-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_RoleInfo.proto",
-- import"PB_Connector.proto",
-- import"PB_RechargeInfo.proto",
-- import"PB_ResourceInfo.proto",
-- import"PB_ItemInfo.proto",
-- import"PB_CityInfo.proto",
-- import"PB_AutoCityInfo.proto",
-- import"PB_AdCount.proto",
-- import"PB_GiftPackInfo.proto",
-- import"PB_ActivityInfo.proto",
-- import"PB_AbParams.proto",
-- import"PB_GuideInfo.proto",
-- import"PB_Coupon.proto",
-- import"PB_PlatformOpenidGroup.proto",
-- import"PB_NormalActivity.proto",
-- import"PB_GroceryInfo.proto",
-- import"PB_RecommendModule.proto",
-- import"PB_CompetitionCupInfo.proto",
-- import"PB_Club.proto",
-- import"PB_EventTimer.proto",
-- import"PB_EventIntervalTimer.proto",
-- import"PB_ClubPacket.proto",
-- import"PB_CustomPopUp.proto",


 PB_UserLogin_Req  =  {
    openid         =  1,-- string openid , --平台用户的标识 游客使用设备ID
    token          =  2,-- string token , --平台验证token
    platform       =  3,-- int32  platform , --用户所属平台
    version        =  4,-- string version , --客户端版本号
    deviceId       =  5,-- string deviceId , --设备ID
    idfa           =  6,-- string idfa , --广告追踪ID
    arch           =  7,-- string arch , --应用架构
    appsflyerId    =  8,-- string appsflyerId ,--appsflyer Id--20230207废弃 不再使用始终传空
    traceAdId      =  9,-- string traceAdId ,--traceAdId--通用id 具体sdk按照需求
    platformInfo  =  1,-- string platformInfo 0, --平台相关信息，json格式
    isRestrict  =  1,-- bool isRestrict 1, --Facebook是否受限登录  true 受限登录 false 非受限登录
}


 PB_UserLogin_Res  =  {
    sessionId                                            =  1,-- string sessionId ,--sessionId
    uid                                                   =  2,-- int32 uid ,--uid
    roleInfo                                        =  3,-- PB_RoleInfo roleInfo ,--角色基本信息
    connector                                      =  4,-- PB_Connector connector ,--连接服务器信息
    rechargeInfo                                =  5,-- PB_RechargeInfo rechargeInfo ,--付费信息
    resourceInfo                       =  6,-- repeated PB_ResourceInfo ,--不区分城市的资源
    itemInfo                               =  7,-- repeated PB_ItemInfo ,--不区分城市的物品
    cityInfo                               =  8,-- repeated PB_CityInfo ,--普通城市区分的 物品、资源、进度等信息
    loginType                                             =  9,-- int32 loginType ,--当前登录类型 0-普通登录 1-首次登录 2-今天首次登录
    systemTime                                            =  1,-- int32 systemTime 0, --当前系统时间戳
    tomorrowTime                                          =  1,-- int32 tomorrowTime 1, --次日零点时间戳
    regTime                                               =  1,-- int32 regTime 2, --用户注册时间戳
    platform                                              =  1,-- int32 platform 3, --用户账号平台类型
    resUrl                                               =  1,-- string resUrl 4, --网络资源地址
    areaCode                                             =  1,-- string areaCode 5, --地区代码
    interstitialAdPushedButNoView          =  1,-- repeated PB_ItemInfo 6, --已推送未播放的插屏集合
    adCount                                 =  1,-- repeated PB_AdCount 7, --激励广告可观看次数
    giftPackInfo                       =  1,-- repeated PB_GiftPackInfo 8, --礼包信息
    activityInfo                       =  1,-- repeated PB_ActivityInfo 9, --在activity_open配置的活动信息
    abParams                               =  2,-- repeated PB_AbParams 0, --AB测试分组信息
    guide                                 =  2,-- repeated PB_GuideInfo 1, --新手引导
    autoCityInfo                       =  2,-- repeated PB_AutoCityInfo 2, --挂机城市区分的 物品、资源、进度等信息
    freeGoods                                    =  2,-- repeated int32 3 , -- 免费并且可以购买的商品
    coupon                                   =  2,-- repeated PB_Coupon 4,--优惠券
    platformOpenidGroups        =  2,-- repeated PB_PlatformOpenidGroup 5,--第三方登录平台的分组openid
    openPlatforms                                =  2,-- repeated int32 6 ,--第三方登录平台id集合
    rofyId                                                =  2,-- int32 rofyId 7,--废弃不再使用 天降奇遇放到 normalActivity
    normalActivity                            =  2,-- PB_NormalActivity normalActivity 8,--不在activity_open配置的-不通用的活动
    groceryInfo                         =  2,-- repeated PB_GroceryInfo 9, --杂货铺列表
    recommendPlay                            =  3,-- PB_RecommendModule recommendPlay 0, --推荐玩法配置
    competitionInfo                       =  3,-- PB_CompetitionCupInfo competitionInfo 1, --杯赛相关数据（废弃）
    groupIds                                     =  3,-- repeated int32 2 , -- 用户群组id集合-目前后端只给一个maxGroupId【方便后续拓展】
    eventTimer                           =  3,-- repeated PB_EventTimer 3, --通用事件定时器
    eventTimerCheckInterval                               =  3,-- int32 eventTimerCheckInterval 4, --通用事件定时器 登录之后 间隔指定秒数 都重新查询一次
    useNewWeekRank                                         =  3,-- bool useNewWeekRank 5, --是否使用新的周榜协议,配合旧周榜协议返回错误码1055
    nextCanChangeUnix                                     =  3,-- int32 nextCanChangeUnix 6, --下次可修改昵称时间戳
    groupPrefix                                          =  3,-- string groupPrefix 7, --分组配置前缀，默认空
    hadFollowFacebook                                      =  3,-- bool hadFollowFacebook 8, --是否已关注fb
    hadFirstShowFollowFacebook                             =  3,-- bool hadFirstShowFollowFacebook 9, --是否已展示follow-fb页面
    firstShowFollowFacebookRewarded                        =  4,-- bool firstShowFollowFacebookRewarded 0, --是否已领取首次展示follow-fb奖励
    clubInfo                                            =  4,-- PB_Club clubInfo 1, --关联公会基本信息
    clubPacket                           =  4,-- repeated PB_ClubPacket 2, --公会红包
    customPopUp                         =  4,-- repeated PB_CustomPopUp 3, --自定义弹框--弹出时机前端控制
    eventIntervalTimer           =  4,-- repeated PB_EventIntervalTimer 4, -- 通用间隔事件定时器
    recGameResBaseUrl                                    =  4,-- string recGameResBaseUrl 5, -- 推荐玩法资源下载Base URL
    isAnniversaryActive                                    =  4,-- bool isAnniversaryActive 6, -- 周年庆活动是否开启
    anniversaryCloseTime                                  =  4,-- int32 anniversaryCloseTime 7, -- 周年庆结束时间
    anniversaryStartTime                                  =  4,-- int32 anniversaryStartTime 8, -- 周年庆开始时间
    debugLevel                                            =  4,-- int32 debugLevel 9, -- DebugLevel
    hasStorePopup                                          =  5,-- bool hasStorePopup 0, -- 是否存在官方商城弹窗
    isSimpleLogin                                          =  5,-- bool isSimpleLogin 1, -- 是否简化登录过程
    serverHosts                         =  5,-- repeated PB_ServerHosts 2, -- 服务器列表
}

 PB_ServerHosts  =  {
    name  =  1,-- string name ,  -- 名称
    host  =  2,-- string host ,  -- 服务器地址
}