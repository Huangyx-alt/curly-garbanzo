-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_Material.proto",

 PB_Exchange_Req  =  {
    itemId  =  1,-- int32 itemId , --兑换物品id
    type  =  2,-- int32 type , --物品类型[1-菜品,2-贴纸，3-任务道具……]
    city  =  3,-- int32 city , --城市id
    playType  =  4,-- int32 playType ,--玩法[1普通2挂机]
}

 PB_Exchange_Res  =  {
    itemId  =  1,--	int32 itemId ,
    used  =  2,--	PB_Material used ,--消耗物资集合
    reward  =  3,--	PB_Material reward ,--奖励物资集合
}