-- syntax =  "proto3",

-- packageGPBClass.Message,

-- 加入公会
 PB_ClubJoin_Req  =  {
    clubId  = 1,-- int32 clubId ,-- 公会ID，唯一
}
 PB_ClubJoin_Res  =  {
    -- 可以考虑返回公会内容信息，减少查询过程
    res  = 1,--	int32 res ,-- 公会ID，唯一
}