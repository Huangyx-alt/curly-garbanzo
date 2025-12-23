-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_UserBind_Req  =  {
    openid  =  1,-- string openid , --fb用户的标识
    token  =  2,-- string token , --fb验证token
    platform  =  3,-- int32 platform , --平台标识
    userName  =  4,-- string userName , --玩家昵称
    platformInfo  =  5,-- string platformInfo , --平台相关信息，json格式
    isRestrict  =  6,-- bool isRestrict , --Facebook是否受限登录 true 受限登录 false 非受限登录
}

 PB_UserBind_Res  =  {
    uid  =  1,-- int32 uid , --绑定后的用户ID
    nickname  =  2,-- string nickname , --绑定后的昵称
    avatar  =  3,-- string avatar , --绑定后的头像
    platform  =  4,-- int32 platform , --平台标识
}