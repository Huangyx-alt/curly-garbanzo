-- syntax =  "proto3",
-- packageGPBClass.Message,
-- import"PB_BankInfo.proto",
-- import"PB_ActivityInfo.proto",

 PB_BankInfoMain_Req  =  {

}

 PB_BankInfoMain_Res  =  {
    isOpen                          =  1,-- bool isOpen ,--银行是否开启  true是 false否
    bankList        =  2,-- repeated PB_BankInfo ,--银行信息列表
    activityList    =  3,-- repeated PB_ActivityInfo ,--活动列表
}
