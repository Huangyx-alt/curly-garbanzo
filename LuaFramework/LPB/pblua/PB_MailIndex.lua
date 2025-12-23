-- syntax =  "proto3",
-- packageGPBClass.Message,
-- import"PB_MailInfo.proto",

 PB_MailIndex_Req  =  {
}

 PB_MailIndex_Res  =  {
    haveMail                        =  1,-- bool haveMail ,--是否展示首页邮箱红点  true展示，  false不展示
    mailList        =  2,-- repeated PB_MailInfo ,--邮件列表（只给弹窗类邮件）
}