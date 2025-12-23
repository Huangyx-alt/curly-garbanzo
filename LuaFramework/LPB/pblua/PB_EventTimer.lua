-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_EventTimer  =  {
    type  =  1,-- int32  type , --定时器 类型 参考common  EventTimerType
    expireTime  =  2,--	int32  expireTime , --过期时间戳 在线的时候 非战斗界面 在这个时间戳之后随机1-10s  根据type 对应协议 查询最新值
}
