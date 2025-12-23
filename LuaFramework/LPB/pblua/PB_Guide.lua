-- syntax =  "proto3",

-- packageGPBClass.Message,

-- import"PB_GuideInfo.proto",

 PB_Guide_Req  =  {
    guideId  =  1,-- int32 guideId ,--引导id
    step  =  2,-- int32 step ,--当前需要进行步骤
}

 PB_Guide_Res  =  {
    guide  =  1,-- repeated PB_GuideInfo ,

}
