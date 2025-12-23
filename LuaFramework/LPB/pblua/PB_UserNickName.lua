-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_UserNickName_Req  =  {
    nickname  =  1,-- string nickname , --nickname
}

 PB_UserNickName_Res  =  {
    nickname  =  1,-- string nickname , --nickname
    nextCanChangeUnix  =  2,-- int32 nextCanChangeUnix , --下次可修改时间
}