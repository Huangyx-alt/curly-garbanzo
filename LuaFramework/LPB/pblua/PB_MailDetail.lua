-- syntax =  "proto3",
-- packageGPBClass.Message,
-- import"PB_MailInfo.proto",

 PB_MailDetail_Req  =  {
}

 PB_MailDetail_Res  =  {
    mailInfo    =  1,-- PB_MailInfo mailInfo ,--邮件详情
    isReceive          =  2,-- bool isReceive ,--是否领取奖励  true已领  false未领
    isRead             =  3,-- bool isRead ,--是否已读  true已读  false未读
}