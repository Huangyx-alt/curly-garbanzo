
-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_GiftInfo.proto",

 PB_GiftPackInfo{
    pId  =  1,--	int32  pId ,--大礼包id
    giftInfo  =  2,--	repeated PB_GiftInfo , --礼包信息
    type  =  3,--	int32  type ,--类型:0-登录全量获取[是否弹客户端判断],1-事件触发推送[只要过cd就弹],2-购买之后推送[仅用于限购次数礼包推送可购买次数]
}