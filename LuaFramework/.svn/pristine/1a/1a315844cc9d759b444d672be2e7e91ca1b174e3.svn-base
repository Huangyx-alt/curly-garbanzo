-- syntax =  "proto3",
-- packageGPBClass.Message,

-- import"PB_MessageBase64List.proto",
-- import"PB_ItemInfo.proto",
 PB_Competition  =  {
    id  =  1,-- int32 id ,    -- 竞赛类型ID，枚举值
    unlockLevel  =  2,-- int32 unlockLevel ,      -- 解锁等级
    leftBuff  =  3,-- repeated PB_ItemInfo ,  -- 剩余BUff信息，注意这里的value值为剩余时间
}
 PB_CompetitionOptions_Req  =  {
}
 PB_CompetitionOptions_Res  =  {
    chooseId  =  1,-- int32 chooseId , -- 玩家选择的竞赛，0 没选择，其他对应竞赛类型枚举ID
    options  =  2,-- repeated PB_Competition ,   -- 可选择竞赛活动列表
    nextMessages  =  3,-- repeated PB_MessageBase64List ,   -- 附带其它-推送协议
}