-- syntax =  "proto3",

-- packageGPBClass.Message,
-- import"PB_SeasonCardGroupInfo.proto",


 PB_FetchFeedbackSeasonCards_Req  =  {
    recordId                   =  1,-- int32 recordId ,--邮件记录ID
}
 PB_FetchFeedbackSeasonCards_Res  =  {
    feedbackTimes                           =  1,-- int32 feedbackTimes , -- 剩余可回赠次数
    groups      =  2,-- repeated PB_SeasonCardGroupInfo , -- 卡组信息
}