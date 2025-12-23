-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ClubChatPacketInfo.proto",

-- 公会礼盒消息内容，
 PB_ClubChatPacket_Res  =  {
    itemId  =  1,-- int32  itemId  ,-- 礼盒ID
    packetInfo  =  2,-- repeated PB_ClubChatPacketInfo ,-- 已经打开列表
    maxOpenNum  =  3,-- int32  maxOpenNum ,  -- 最多打开数量
    rewardUnix  =  4,-- int32  rewardUnix ,  -- 过期时间
}