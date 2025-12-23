-- syntax =  "proto3",

-- packageGPBClass.Message,


-- 退出公会
 PB_ClubQuit_Req  =  {
    clubId  = 1,-- int32 clubId ,-- 公会ID，唯一
}
 PB_ClubQuit_Res  =  {
    res = 1,-- int32 res ,-- 可以考虑返回公会列表，减少查询过程
}