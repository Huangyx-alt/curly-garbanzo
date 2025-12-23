-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_MiniGameState  =  {
    id                                    =  1,-- int32 id , --miniGame id
    progress                              =  2,--	int32 progress , --进度值
    target                                =  3,--	int32 target , --目标值
    complete                               =  4,--	bool complete , --完成状态
    fullUnix                              =  5,--	int32 fullUnix , --完成【进度满】时间戳
}
