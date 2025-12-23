-- syntax =  "proto3",
-- packageGPBClass.Message,
-- import"PB_MailInfo.proto",

 PB_MailList_Req  =  {
    page                       =  1,-- int32 page ,--邮件列表翻页， 默认1
}

 PB_MailList_Res  =  {
    mailList    =  1,-- repeated PB_MailInfo ,--邮件列表
    maxPage                    =  2,-- int32 maxPage ,--最大页数
    string                    =  3,--错误、成功提示
    code                       =  4,-- int32 code ,--接口返回码  0成功  1失败
}