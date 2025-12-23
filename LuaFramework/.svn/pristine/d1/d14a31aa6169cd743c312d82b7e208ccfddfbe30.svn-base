-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",

 PB_VolcanoFetch_Req  =  {
}

 PB_VolcanoFetch_Res  =  {
    mapId  =  1,-- int32 mapId , --地图进度id，默认1（活动周期内只增不减）
    step  =  2,-- int32 step , --当前进度（浮台）id （0开始） -1为掉落
    lastStep  =  3,-- int32 lastStep , --上次进度（浮台）id （0开始）
    round  =  4,-- int32 round , --当前进度已对局数
    totalRound  =  5,-- int32 totalRound , --当前进度总对局数
    resource  =  6,-- int32 resource , --资源数量
    totalResource  =  7,-- int32 totalResource , --当前进度所需资源数量
    stepRewards  =  8,-- repeated PB_StepReward , -- 阶段的额外奖励
    members  =  9,-- repeated PB_Members , --当前剩余玩家
    endTime  =  1,-- int32 endTime 0,
    lastMapId  =  1,-- int32 lastMapId 1,
    stepCount  =  1,-- int32 stepCount 2,
    groupId  =  1,-- int32 groupId 3,
    mapCount  =  1,-- int32 mapCount 4,
    reliveTimes  =  1,-- int32 reliveTimes 5,
    rewardSteps  =  1,-- repeated int32 6 ,-- 已经领过的阶段宝箱
    lastRewardSteps  =  1,-- repeated int32 7 ,-- 上次已经领过的阶段宝箱
    stepNeeds  =  1,-- repeated int32 8 ,-- 每个台阶需要的资源数量，会比stepCount多一个，代表通关
}

 PB_StepReward  =  {
    step  =  1,-- int32 step ,
    reward  =  2,-- PB_ItemInfo reward ,
}

 PB_Members  =  {
    uid  =  1,-- int32 uid ,
    step  =  2,-- int32 step , --跟玩家相等的为伴随，-1的为掉落
    gameProps  =  3,-- repeated int32  ,--游戏加成道具
    deadStep  =  4,-- int32 deadStep ,-- 死亡台阶，比如1跳2死亡，这里就是1
}