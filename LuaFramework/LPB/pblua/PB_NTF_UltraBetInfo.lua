-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_NTF_UltraBetInfo_Req  =  {

}

 PB_NTF_UltraBetInfo_Res  =  {
    isOpen  =  1,-- bool isOpen ,--是否开启活动
    bet  =  2,-- int32 bet ,--档位等级
    expire  =  3,-- int64 expire ,--过期时间
    isPopup  =  4,-- bool isPopup ,--是否弹窗
    cdTime  =  5,-- int64 cdTime ,--cd结束时间
    isPrize  =  6,-- bool isPrize ,--是否下发激励
}