-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_CardPos.proto",
-- import"PB_ItemInfo.proto",

 PB_SuperMatchData  =  {
    matchId  =  1,-- int32 matchId ,    -- 匹配机器人ID
    beginMarkedPos  =  2,-- repeated PB_CardPos ,   -- 机器人初始盖章
    markTick  =  3,-- repeated PB_MarkPosTick ,     -- 机器人盖章Tick
    callNum  =  4,-- repeated PB_RobotCallNumber ,  -- 叫号数值
    userMarkPos  =  5,-- repeated PB_UserMarkPos ,  -- 用户叫号盖章机器人位置
    markAccReward  =  6,-- repeated PB_ItemInfo ,   -- 盖章充能奖励
}

-- 机器人盖章 Tick 数据
 PB_MarkPosTick  =  {
    tick  =  1,-- int32 tick ,       -- 时间线
    markPos  =  2,-- repeated PB_CardPos , -- 盖章位置
}

-- 机器人叫号
 PB_RobotCallNumber  =  {
    callOrder  =  1,-- int32 callOrder ,  -- 叫号顺序位置，从 1 开始
    number  =  2,-- int32 number ,     -- 叫号号码
}

-- 用户叫号盖章机器人位置
 PB_UserMarkPos  =  {
    callOrder  =  1,-- int32 callOrder ,  -- 叫号顺序位置，从 1 开始
    markPos  =  2,-- repeated PB_CardPos , -- 盖章位置
}
