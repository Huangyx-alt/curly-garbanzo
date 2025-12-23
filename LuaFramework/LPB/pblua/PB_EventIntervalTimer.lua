-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_EventIntervalTimer  =  {
    type  =  1,-- int32  type , --定时器 类型 参考common  EventTimerType
    beginTime  =  2,--	int32  beginTime , --定时器开始时间
    interval  =  3,--	int32  interval , --间隔时间 秒数
    times  =  4,--	int32  times , --执行次数
}
