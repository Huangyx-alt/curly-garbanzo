-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_Club.proto",

-- 查询公会列表
 PB_ClubQuery_Req  =  {
    q  =  1,-- string q ,--模糊查询
    sortType  =  2,-- int32 sortType ,--排序 1-公会名称a-z升序 2-公会名称z-a降序 3-公会人数降序  4-公会人数升序
    page  =  3,-- int32 page ,--分页 第一版不用 直接传0 查询全部
}
 PB_ClubQuery_Res  =  {
    clubs = 1,-- repeated PB_Club , -- 公会列表 第一版全部
    sortType  =  2,-- int32 sortType ,--
    page  =  3,-- int32 page ,--
}