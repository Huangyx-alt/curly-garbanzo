-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ItemInfo.proto",
-- import"PB_NumberItemInfo.proto",
-- import"PB_BeginSkillData.proto",

 PB_GameCardInfo  =  {
    cardId  =  1,-- int32 cardId ,						                        -- 卡牌ID
    numbers  =  2,-- repeated int32  , 				  -- 顺序-从左上角向下遍历-再向右同理 25个号码
    beginMarkedPos  =  3,-- repeated int32  ,    -- 初始已经盖章坐标数组
    cardReward  =  4,-- repeated PB_ItemInfo ,                -- 奖励绑定 ，卡牌
    cardNumberReward  =  5,-- repeated PB_NumberItemInfo ,    -- 奖励绑定 ，号码
    beginSkillData  =  6,-- repeated PB_BeginSkillData ,      -- 初始技能效果
}