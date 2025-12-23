-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_ResourceInfo.proto",
-- import"PB_ItemInfo.proto",
-- import"PB_CityInfo.proto",
-- import"PB_AutoCityInfo.proto",
-- import"PB_Coupon.proto",
-- import"PB_ClubPacket.proto",

 PB_UpdateMaterial_Req  =  {
}

 PB_UpdateMaterial_Res  =  {
    resourceInfo  =  1,--	repeated PB_ResourceInfo ,--资源
    itemInfo  =  2,--	repeated PB_ItemInfo ,--物品
    cityInfo  =  3,--	repeated PB_CityInfo ,--区分普通城市
    autoCityInfo  =  4,--	repeated PB_AutoCityInfo ,--区分挂机城市
    coupon  =  5,--	repeated PB_Coupon ,--优惠券
    upcoupon  =  6,--	bool upcoupon ,--whether up coupon
    seasonCardInfo  =  7,--	repeated PB_ItemInfo ,-- season card
    updateSeasonCard  =  8,--	bool updateSeasonCard ,-- 是否更新赛季卡包
    clubPacket  =  9,--	repeated PB_ClubPacket ,--公会礼盒
}