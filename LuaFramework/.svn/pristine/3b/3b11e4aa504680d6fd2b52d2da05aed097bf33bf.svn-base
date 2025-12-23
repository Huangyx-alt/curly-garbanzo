-- syntax =  "proto3",

-- packageGPBClass.Message,

 PB_SyncData_Req  =  {
    machineId  =  1,-- int32 machineId , --机台ID
    versions  =  2,-- string versions , --客户端机台数据版本信息(json格式:{"Task":1,"Item":2})
}

 PB_GameData  =  {
    module  =  1,-- string module , --模块名称
    version  =  2,-- int32 version , --数据版本
    data  =  3,-- string data , --数据内容(json格式)
}

 PB_SyncData_Res  =  {
    gameData  =  1,-- repeated PB_GameData , --最新数据(只返回服务器存储的比客户端新的数据)
    cas  =  2,-- string cas , --一致性校验码
}