-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_VictoryBeatsPlay_Req  =  {
}

 PB_VictoryBeatsPlay_Res  =  {
    allRound  =  1,-- int32 allRound , -- 总局数
    curRound  =  2,-- int32 curRound , -- 当前局
    countDown  =  3,-- int32 countDown , -- 倒计时
    jackpotRuleId  =  4,-- int32 jackpotRuleId ,--本轮需要达成的jackpotID
    rate  =  5,-- int32 rate ,  --用户选择的档位，0 未选择
    ultraRate  =  6,-- int32 ultraRate ,  --UltraBet 档位
}