-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_AutoCityPhotoState.proto",
-- import"PB_AbParams.proto",


 PB_RoleInfo  =  {
    nickname  =  1,-- string nickname , --昵称
    avatar  =  2,-- string avatar , --头像
    level  =  3,-- int32  level , --等级
    exp  =  4,-- int32  exp , --等级经验
    vip  =  5,-- int32  vip , --vip等级
    vipPts  = 6,-- int32  vipPts ,--vip经验(积分)
    city  =  7,-- int32  city , --上次进行战斗的城市-登录不使用这个，登录进入等级解锁最大城市【排除挂机城市】
    autoCity  =  8,-- int32  autoCity , --城市
    lang  =  9,-- string lang , --语言
    maxCity  =  1,-- int32  maxCity 0, --最大城市，废弃字段
    maxAutoCity  =  1,-- int32  maxAutoCity 1, --挂机玩法最大城市，废弃字段
    userPayType  =  1,-- int32  userPayType 2, --用户付费类型
    autoCityPhotoState  =  1,-- PB_AutoCityPhotoState autoCityPhotoState 3,--挂机城市相册进度状态
    abParams  =  1,-- repeated PB_AbParams 4,--ab测试参数暂时保留后面走单独协议MSG_ABPARAMS_NOTIFY
    email  =  1,-- string email 5,--用户邮箱
    groups  =  1,-- string groups 6, -- 用户分组，前端使用 json
}