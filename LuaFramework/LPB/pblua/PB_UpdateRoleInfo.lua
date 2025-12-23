-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_AbParams.proto",
-- import"PB_AutoCityPhotoState.proto",


 PB_UpdateRoleInfo_Req  =  {
}

 PB_UpdateRoleInfo_Res  =  {
    nickname  =  1,-- string nickname , --昵称
    avatar  =  2,-- string avatar , --头像
    level  =  3,-- int32  level , --等级
    exp  =  4,-- int32  exp , --等级经验
    vip  =  5,-- int32  vip , --vip等级
    vipPts  = 6,-- int32  vipPts ,--vip积分
    city  =  7,-- int32  city , --城市
    autoCity  =  8,-- string autoCity , --语言
    maxCity  =  9,-- int32  maxCity , --最大城市，废弃字段
    maxAutoCity  =  1,-- int32  maxAutoCity 0, --挂机玩法最大城市，废弃字段
    lang  =  1,-- string lang 1, --语言
    userPayType  =  1,-- int32 userPayType 2, --用户付费类型
    autoCityPhotoState  =  1,-- PB_AutoCityPhotoState autoCityPhotoState 3,--挂机玩法相册进度状态数据
    abParams  =  1,-- repeated PB_AbParams 4,--abParams 暂时保留后面走单独协议MSG_ABPARAMS_NOTIFY
    email  =  1,-- string email 5,--用户邮箱
}
