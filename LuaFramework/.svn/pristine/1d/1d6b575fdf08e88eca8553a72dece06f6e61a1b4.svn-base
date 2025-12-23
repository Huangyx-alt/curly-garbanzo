-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_SaveData_Req  =  {
    machineId  =  1,-- int32 machineId , --机台ID
    gameData  =  2,-- string gameData , --最新数据(json格式:{"Task":{...},"Item":{...}})
    cas  =  3,-- string cas , --一致性校验码
}

 PB_SaveData_Res  =  {
    versions  =  1,-- string versions , --数据的新版本号(json格式:{"Task":1,"Item":2})
    cas  =  2,-- string cas , --新的一致性校验码
}