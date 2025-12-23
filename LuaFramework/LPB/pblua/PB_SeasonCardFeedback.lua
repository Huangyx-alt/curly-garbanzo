-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_SeasonCardFeedback_Req  =  {
    recordId                   =  1,-- int32 recordId ,--邮件记录ID
    cardId                   =  2,-- int32 cardId ,--卡片ID
    seasonId                  =  3,-- int32 seasonId , -- 卡包赛季Id
}
 PB_SeasonCardFeedback_Res  =  {
    code           =  1,-- int32 code , -- code
    string       =  2, -- msg
}