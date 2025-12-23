-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_FinalCardInfo.proto",
-- import"PB_MessageBase64List.proto",

--gameOver之前上报-主验证和结算，如果后端没有收到-按照PB_UploadPlayEvent数据验证和结算
 PB_UpFinalInfo_Req  =  {
    gameId                                   =  1,--	string gameId ,
    playType                                  =  2,--	int32 playType ,--PLAY_TYPE 新玩法完成前 继续使用该字段
    cardInfo              =  3,--	repeated PB_FinalCardInfo ,--卡牌盖章数据
    robotData                                =  4,--	string robotData ,--机器人数据json 后面可能有变化
    type                                      =  5,--	int32 type ,--0-默认走完正常结算,1-提前退出
    calledNumbers                    =  6,--	repeated int32  ,--已叫号列表
    powerUpNo                                 =  7,--	int32 powerUpNo ,--已使用powerUp序号
    fastMarked                       =  8,--	repeated int32  , --实现方式id 拼接 快速盖章时的叫号(固定2位不足补0) 实现方式id： 叫号命中原号码为0 powerUp命中为powerUpId
    playId                                    =  9,--	int32 playId ,--PLAY_ID  新玩法完成前不给或给0 新玩法完成后 填充非0值
    ext                                      =  1,--	string ext 0,--拓展数据
	
}

 PB_UpFinalInfo_Res  =  {
    res                                   =  1,-- int32 res ,--返回值 用于客户端确认是否上报成功,没有成功需要重试，成功之后-没有收到预结算或结算-重试gameOver
    nextMessages  =  2,-- repeated PB_MessageBase64List ,--附带其它-推送协议
}