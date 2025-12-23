-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_GuideInfo.proto",

 PB_GuideFetch_Req  =  {
    guideId  =  1,-- int32 guideId ,--引导id 0 表示查询全部
}

 PB_GuideFetch_Res  =  {
    guide  =  1,-- repeated PB_GuideInfo ,
}
