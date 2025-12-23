-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ResourceInfo.proto",
-- import"PB_ItemInfo.proto",


 PB_OpenBox_Req  =  {
    itemIds  =  1,-- repeated int32  , --宝箱id
    cityId  =  2,-- int32 cityId ,
    type  =  3,-- int32 type ,--0一个一个开，1城市全开，2全部城市全开
    playType  =  4,-- int32 playType ,--玩法，如果全开和type一起传
    playId  =  5,-- int32 playId ,--优先取 playId 来确定 cityId
}

 PB_OpenBox_Res  =  {
    boxes  =  1,-- repeated Boxes ,
    double          =  2,-- int32 double ,--0-没有双倍标识 1-有双倍标识
}

 Boxes{
    itemId  =  1,-- int32 itemId , --itemid
    resourceInfo  =  2,-- repeated PB_ResourceInfo ,--资源
    itemInfo  =  3,-- repeated PB_ItemInfo ,--物品
}