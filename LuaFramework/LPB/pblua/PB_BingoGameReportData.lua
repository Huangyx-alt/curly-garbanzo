-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_ReportCardInfo.proto",
-- import"PB_MessageBase64List.proto",

 PB_BingoGameReportData_Req  =  {
    gameId                                   =  1,-- string gameId , -- 游戏ID
    settleType                                =  2,-- int32 settleType , -- 结算流程，0-默认，1-提前退出
    cardInfo             =  3,-- repeated PB_ReportCardInfo , -- 卡牌盖章数据
    calledNumbers                    =  4,-- repeated int32  , -- 已叫号列表，漏号验证
    extra                                    =  5,-- string extra , -- 拓展数据
}

 PB_BingoGameReportData_Res  =  {
    nextMessages      =  1,-- repeated PB_MessageBase64List , -- 附带其它-推送协议
}