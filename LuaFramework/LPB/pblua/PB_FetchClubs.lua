-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_Club.proto",

-- 查询公会列表
 PB_FetchClubs_Req  =  {
    --后续考虑加入页码功能
}
 PB_FetchClubs_Res  =  {
    clubs = 1,-- repeated PB_Club , -- 公会列表 --后续考虑加入页码功能
}