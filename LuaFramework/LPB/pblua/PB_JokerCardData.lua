-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_CardPowerUpEffect.proto",

--*****jokerPowerUp-使用信息************--
--basePosType-投放坐标类型 说明
--0-不寻找格子投放(basePos = 0),可能是投放卡牌,可能是直接生效技能
--1-前端随机(优先找空格-用于投放普通物品,无空格随机投),
--2-后端指定坐标位置【posList】,如果extraPos非空 不可忽略extraPos【不可提前被盖章】
--7-后端指定坐标位置【posList】,忽略extraPos【可以提前被盖章】【部分玩法有特殊逻辑根据玩法自行添加-比如绿头人extraPos已全部被盖，会切换到其它材料关联坐标集合】
--8-后端指定坐标位置【posList】,extraPos不是盖章而是让井【中心为posList】四周的格子上的普通道具无需盖章也被收集,忽略extraPos【可以提前被盖章】
 PB_JokerCardData  =  {
    powerUpId  =  1,-- int32 powerUpId ,                                 --powerUpId
    itemIds  =  2,-- repeated int32  ,  			 --小丑卡-道具ID
    callNumbers  =  3,-- repeated int32  ,  		 --小丑卡-额外叫号
    cardPowerUpEffect  =  5,--	repeated PB_CardPowerUpEffect , --所有卡上效果数据
    basePosType  =  6,--	int32 basePosType ,                               --类型判断
}
