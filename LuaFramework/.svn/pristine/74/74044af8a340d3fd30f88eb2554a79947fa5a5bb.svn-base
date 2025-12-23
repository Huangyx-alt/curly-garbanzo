-- syntax =  "proto3",
-- packageGPBClass.Message,

-- import"PB_MessageBase64List.proto",

 PB_GetPowerup_Req  =  {
    uidId  =  1,-- string uidId ,
    scenes  =  2,-- int32 scenes ,--场景区分 0-打开或展示出pu界面【触发后端结算未结算的战斗】 1-场景1 2-场景2
    playId  =  3,-- int32 playId ,--玩法id PLAY_ID 玩法id可以反推所属城市id 0或者空-取全量powerUp 否则取特定 PLAY_ID 下的 powerUp
}

 PB_GetPowerup_Res  =  {
    powerups  =  1,-- repeated PB_PowerUps , --卡牌
    unfit  =  2,-- bool unfit ,--是否不一致，true全量更新，false无需更新
    uidId  =  3,-- string uidId ,--最新的uidId，客户端直接替换本地的uidId
    scenes  =  4,-- int32 scenes ,--场景区分 0-打开或展示出pu界面【触发后端结算未结算的战斗】 1-场景1 2-场景2
    seasonPu  =  5,-- PB_SeasonPowerUp seasonPu ,  -- 赛季PU数据
    nextMessages  =  6,-- repeated PB_MessageBase64List ,   -- 附带其它-推送协议
}

 PB_PowerUps  =  {
    cityId  =  1,-- int32 cityId , --城市ID
    powerUp  =  2,-- repeated int32  , --卡牌ID
    jokerPowerups  = 3,-- repeated int32  , --小丑卡牌ID
    id  =  4,-- int64 id ,--id
    type  =  5,-- int32 type ,--1正常2挂机
    groupId  =  6,-- int32 groupId ,--powerUpGroup 配置ID
    playId  =  7,-- int32 playId ,--playId
    power  =  8,-- int32 power ,--PU分数
    level  =  9,-- int32 level ,--PU等级
    puLevel  =  1,-- int32 puLevel 0, --pu卡界面得等级
    cardNum  =  1,-- int32 cardNum 1, --对应的bingo卡数量
}

 PB_SeasonPowerUp  =  {
    seasonId  =  1,-- int32 seasonId ,--pu赛季id
    seasonEndTime  =  2,-- int32 seasonEndTime ,--pu赛季结束时间
}