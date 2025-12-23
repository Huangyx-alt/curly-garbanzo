-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_CardPowerUpEffect.proto",

--basePosType-投放坐标类型 说明
--0-不寻找格子投放(basePos = 0),可能是投放卡牌,可能是直接生效技能
--1-前端随机(优先找空格-用于投放普通物品,无空格随机投),
--2-后端指定坐标位置,如果extraPos非空 不可忽略extraPos【不可提前被盖章】
----废弃--3-叫号可能命中坐标集合-callHitPos(减去已经盖章坐标集合，无可选即不能命中-从6中选择),
----废弃--4-全部可能盖章坐标集合-allHitPos(减去已经盖章坐标集合，无可选即不能命中-从6中选择[特例：直接涂抹N个格子出现无可选 一般已盖满结束/从5中计算选取]),
----废弃--5-不会形成额外bingo、jackpot的坐标集合(),
----废弃--6-不会命中的坐标(cardAllPos减去allHitPos)

--7-后端指定坐标位置,忽略extraPos【可以提前被盖章】【部分玩法有特殊逻辑根据玩法自行添加-比如绿头人extraPos已全部被盖，会切换到其它材料关联坐标集合】

--*****powerUp-使用信息************--
 PB_PowerUpData  =  {
    powerUpId  =  1,-- int32 powerUpId ,                                 --powerUpId
    type  =  2,-- int32 type ,                                      --可用状态 0-初始已经使用掉(不可使用-客户端仅展示) 1-可使用
    basePosType  =  6,-- int32 basePosType ,						         --初始投放坐标类型
    cardPowerUpEffect  =  5,-- repeated PB_CardPowerUpEffect , --所有卡上效果数据
}
